import 'package:flutter/foundation.dart';
import '../../../core/constants/turkish_letters.dart';
import '../../../data/models/board.dart';
import '../../../data/models/cell.dart';
import '../../../data/models/difficulty.dart';
import '../../../data/models/inventory_model.dart';
import '../../../data/models/joker.dart';
import '../../../data/models/stats_model.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/repositories/stats_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/board_analyzer.dart';
import '../../../data/services/board_factory.dart';
import '../../../data/services/joker_executor.dart';
import '../../../data/services/letter_generator.dart';
import '../../../data/services/power_executor.dart';
import '../../../data/services/word_validator.dart';

enum TurnFeedbackType { none, success, invalid, short }

class TurnFeedback {
  final TurnFeedbackType type;
  final String word;
  final int earnedScore;
  final int baseScore;
  final int comboScore;
  final int powerScore;
  final List<String> subWords;
  final CellPower power;
  final String message;

  const TurnFeedback({
    required this.type,
    this.word = '',
    this.earnedScore = 0,
    this.baseScore = 0,
    this.comboScore = 0,
    this.powerScore = 0,
    this.subWords = const [],
    this.power = CellPower.none,
    this.message = '',
  });

  static const empty = TurnFeedback(type: TurnFeedbackType.none);
}

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    required this.difficulty,
    required WordValidator validator,
    required StatsRepository statsRepo,
    required UserRepository userRepo,
    required InventoryRepository inventoryRepo,
    BoardFactory? factory,
    LetterGenerator? generator,
    PowerExecutor? powerExecutor,
    JokerExecutor? jokerExecutor,
    BoardAnalyzer? analyzer,
  })  : _validator = validator,
        _statsRepo = statsRepo,
        _userRepo = userRepo,
        _inventoryRepo = inventoryRepo,
        _factory = factory ?? BoardFactory(),
        _generator = generator ?? LetterGenerator(),
        _power = powerExecutor ?? const PowerExecutor(),
        _joker = jokerExecutor ?? JokerExecutor(),
        _analyzer = analyzer {
    _board = _factory.create(difficulty);
    _remainingMoves = difficulty.moveCount;
    _startedAt = DateTime.now();
    _inventoryModel = _inventoryRepo.current;
    _loadMultiplier();
    _ensureSolvable();
  }

  final Difficulty difficulty;
  final WordValidator _validator;
  final StatsRepository _statsRepo;
  final UserRepository _userRepo;
  final InventoryRepository _inventoryRepo;
  final BoardFactory _factory;
  final LetterGenerator _generator;
  final PowerExecutor _power;
  final JokerExecutor _joker;
  final BoardAnalyzer? _analyzer;

  late Board _board;
  late int _remainingMoves;
  late DateTime _startedAt;
  int _score = 0;
  int _totalWords = 0;
  String _longestWord = '';
  final List<Cell> _selection = [];
  TurnFeedback _feedback = TurnFeedback.empty;
  bool _finalized = false;
  InventoryModel _inventoryModel = const InventoryModel();
  int _scoreMultiplier = 1;
  String? _jokerMessage;

  Board get board => _board;
  int get remainingMoves => _remainingMoves;
  int get score => _score;
  int get totalWords => _totalWords;
  String get longestWord => _longestWord;
  List<Cell> get selection => List.unmodifiable(_selection);
  TurnFeedback get feedback => _feedback;
  InventoryModel get inventory => _inventoryModel;
  int get scoreMultiplier => _scoreMultiplier;
  String? get jokerMessage => _jokerMessage;
  bool get isGameOver => _remainingMoves <= 0;
  int get durationSeconds =>
      DateTime.now().difference(_startedAt).inSeconds;

  void _ensureSolvable() {
    final analyzer = _analyzer;
    if (analyzer == null) return;
    var attempts = 0;
    while (attempts < 5 && !analyzer.hasAnyValidWord(_board)) {
      _board = _factory.reshuffle(_board);
      attempts++;
    }
  }

  Future<void> _loadMultiplier() async {
    final value = await _userRepo.consumeNextScoreMultiplier();
    if (value != _scoreMultiplier) {
      _scoreMultiplier = value;
      notifyListeners();
    }
  }

  String get currentWord => _selection.map((c) => c.letter).join();

  int get currentPreviewScore {
    if (_selection.length < 3) return 0;
    var sum = 0;
    for (final c in _selection) {
      sum += c.point;
    }
    return sum;
  }

  CellPower get previewPower =>
      CellPower.fromWordLength(_selection.length);

  bool isSelected(Cell cell) => _selection.contains(cell);
  int indexOfSelected(Cell cell) => _selection.indexOf(cell);

  void startSelection(Cell cell) {
    if (isGameOver || cell.isEmpty) return;
    _selection
      ..clear()
      ..add(cell);
    _feedback = TurnFeedback.empty;
    notifyListeners();
  }

  void extendSelection(Cell cell) {
    if (isGameOver || cell.isEmpty) return;
    if (_selection.isEmpty) {
      _selection.add(cell);
      notifyListeners();
      return;
    }
    if (_selection.length >= 2 && _selection[_selection.length - 2] == cell) {
      _selection.removeLast();
      notifyListeners();
      return;
    }
    if (_selection.contains(cell)) return;
    final last = _selection.last;
    if (!_board.isNeighbor(last, cell)) return;
    _selection.add(cell);
    notifyListeners();
  }

  void cancelSelection() {
    _selection.clear();
    notifyListeners();
  }

  Future<void> commitSelection() async {
    if (isGameOver) return;
    if (_selection.isEmpty) return;

    final result = _validator.validate(currentWord);
    if (!result.isValid) {
      _feedback = TurnFeedback(
        type: result.word.length < 3
            ? TurnFeedbackType.short
            : TurnFeedbackType.invalid,
        word: result.word,
        message: result.reason,
      );
      _selection.clear();
      _remainingMoves = (_remainingMoves - 1).clamp(0, _remainingMoves);
      await _finalizeIfNeeded();
      notifyListeners();
      return;
    }

    final baseScore = result.score;
    final subWords = _validator.findSubWords(result.word);
    final comboScore = subWords.fold<int>(0, (sum, w) => sum + _wordScore(w));
    final power = CellPower.fromWordLength(result.word.length);
    final selectedIds = _selection.map((c) => c.id).toSet();
    final powerIds = _power
        .extraCellsFor(board: _board, selection: _selection, power: power)
        .difference(selectedIds);
    final powerScore = powerIds.fold<int>(
      0,
      (sum, id) => sum +
          _board.grid
              .expand((row) => row)
              .firstWhere((c) => c.id == id)
              .point,
    );

    final totalScore =
        (baseScore + comboScore + powerScore) * _scoreMultiplier;
    _score += totalScore;
    _totalWords += 1;
    if (result.word.length > _longestWord.length) {
      _longestWord = result.word;
    }

    _feedback = TurnFeedback(
      type: TurnFeedbackType.success,
      word: result.word,
      earnedScore: totalScore,
      baseScore: baseScore,
      comboScore: comboScore,
      powerScore: powerScore,
      subWords: subWords,
      power: power,
      message: '+$totalScore puan',
    );

    final removedIds = {...selectedIds, ...powerIds};
    _board =
        _board.withRemovedCells(removedIds).applyGravity(_generator.next);
    _selection.clear();
    _remainingMoves = (_remainingMoves - 1).clamp(0, _remainingMoves);
    _ensureSolvable();
    await _finalizeIfNeeded();
    notifyListeners();
  }

  int _wordScore(String word) {
    var total = 0;
    for (final ch in word.split('')) {
      total += TurkishLetters.pointOf(ch);
    }
    return total;
  }

  Future<void> _finalizeIfNeeded() async {
    if (_finalized || !isGameOver) return;
    _finalized = true;
    final result = GameResult(
      score: _score,
      wordCount: _totalWords,
      longestWord: _longestWord,
      durationSeconds: durationSeconds,
      difficultyKey: difficulty.key,
    );
    await _statsRepo.recordGame(result);
    final coinReward = (_score / 10).floor();
    if (coinReward > 0) {
      await _userRepo.setCoins(_userRepo.getCoins() + coinReward);
    }
  }

  Future<void> abandonGame() async {
    if (_finalized) return;
    _remainingMoves = 0;
    await _finalizeIfNeeded();
    notifyListeners();
  }

  void clearFeedback() {
    if (_feedback.type == TurnFeedbackType.none) return;
    _feedback = TurnFeedback.empty;
    notifyListeners();
  }

  void reshuffleBoard() {
    _board = _factory.reshuffle(_board);
    _selection.clear();
    notifyListeners();
  }

  Future<bool> useJoker(Joker joker) async {
    if (isGameOver) return false;
    if (_inventoryModel.countOf(joker) <= 0) {
      _jokerMessage = 'Stok yok';
      notifyListeners();
      return false;
    }
    final outcome = _joker.apply(_board, joker);
    _board = outcome.board;
    _selection.clear();
    _inventoryModel = await _inventoryRepo.consume(joker);
    if (outcome.pendingScoreMultiplier > 1) {
      await _userRepo
          .setNextScoreMultiplier(outcome.pendingScoreMultiplier);
    }
    _jokerMessage = outcome.message;
    notifyListeners();
    return true;
  }

  void clearJokerMessage() {
    if (_jokerMessage == null) return;
    _jokerMessage = null;
    notifyListeners();
  }
}
