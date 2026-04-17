import 'package:flutter/foundation.dart';
import '../../../data/models/board.dart';
import '../../../data/models/cell.dart';
import '../../../data/models/difficulty.dart';
import '../../../data/services/board_factory.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    required this.difficulty,
    BoardFactory? factory,
  }) : _factory = factory ?? BoardFactory() {
    _board = _factory.create(difficulty);
    _remainingMoves = difficulty.moveCount;
  }

  final Difficulty difficulty;
  final BoardFactory _factory;

  late Board _board;
  late int _remainingMoves;
  final int _score = 0;
  final List<Cell> _selection = [];

  Board get board => _board;
  int get remainingMoves => _remainingMoves;
  int get score => _score;
  List<Cell> get selection => List.unmodifiable(_selection);

  String get currentWord => _selection.map((c) => c.letter).join();

  void reshuffleBoard() {
    _board = _factory.reshuffle(_board);
    _selection.clear();
    notifyListeners();
  }
}
