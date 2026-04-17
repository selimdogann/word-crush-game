import 'cell.dart';
import 'difficulty.dart';

class Board {
  final Difficulty difficulty;
  final List<List<Cell>> grid;

  const Board({required this.difficulty, required this.grid});

  int get size => difficulty.gridSize;

  Cell cellAt(int row, int col) => grid[row][col];

  bool inBounds(int row, int col) =>
      row >= 0 && row < size && col >= 0 && col < size;

  Board copyWithGrid(List<List<Cell>> newGrid) =>
      Board(difficulty: difficulty, grid: newGrid);

  List<Cell> neighborsOf(int row, int col) {
    final list = <Cell>[];
    for (var dr = -1; dr <= 1; dr++) {
      for (var dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final nr = row + dr;
        final nc = col + dc;
        if (inBounds(nr, nc)) list.add(grid[nr][nc]);
      }
    }
    return list;
  }
}
