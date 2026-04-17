import '../models/board.dart';
import '../models/cell.dart';
import '../models/difficulty.dart';
import 'letter_generator.dart';

class BoardFactory {
  BoardFactory({LetterGenerator? generator})
      : _generator = generator ?? LetterGenerator();

  final LetterGenerator _generator;

  Board create(Difficulty difficulty) {
    final size = difficulty.gridSize;
    final letters = _generator.generateGrid(size);
    final grid = List<List<Cell>>.generate(
      size,
      (r) => List<Cell>.generate(
        size,
        (c) => Cell(row: r, col: c, letter: letters[r][c]),
      ),
    );
    return Board(difficulty: difficulty, grid: grid);
  }

  Board reshuffle(Board board) => create(board.difficulty);
}
