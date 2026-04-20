import 'package:flutter/foundation.dart';
import '../../../core/constants/turkish_letters.dart';
import '../../../data/models/board.dart';
import '../../../data/models/cell.dart';
import '../../../data/models/difficulty.dart';
import '../../../data/services/board_factory.dart';
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
    BoardFactory? factory,
    LetterGenerator? generator,
    PowerExecutor? powerExecutor,
  })  : _validator = validator,
        _factory = factory ?? BoardFactory(),
        _generator = generator ?? LetterGenerator(),
        _power = powerExecutor ?? const PowerExecutor() {
    _board = _factory.create(difficulty);
    _remainingMoves = difficulty.moveCount;
  }

  final Difficulty difficulty;
  final WordValidator _validator;
  final BoardFactory _factory;
  final LetterGenerator _generator;
  final PowerExecutor _power;

  late Board _board;
  late int _remainingMoves;
  int _score = 0;
  int _totalWords = 0;
  String _longestWord = '';
  final List<Cell> _selection = [];
  TurnFeedback _feedback = TurnFeedback.empty;

  Board get board => _board;
  int get remainingMoves => _remainingMoves;
  int get score => _score;
  int get totalWords => _totalWords;
  String get longestWord => _longestWord;
  List<Cell> get selection => List.unmodifiable(_selection);
  TurnFeedback get feedback => _feedback;
  bool get isGameOver => _remainingMoves <= 0;

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
      (sum, id) => sum + _board.grid
          .expand((row) => row)
          .firstWhere((c) => c.id == id)
          .point,
    );

    final totalScore = baseScore + comboScore + powerScore;
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
    notifyListeners();
  }

  int _wordScore(String word) {
    var total = 0;
    for (final ch in word.split('')) {
      total += TurkishLetters.pointOf(ch);
    }
    return total;
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
}
