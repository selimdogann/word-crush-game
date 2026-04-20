import 'cell.dart';
import 'difficulty.dart';

class Board {
  final Difficulty difficulty;
  final List<List<Cell>> grid;

  const Board({required this.difficulty, required this.grid});

  int get size => grid.length;

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

  bool isNeighbor(Cell a, Cell b) {
    final dr = (a.row - b.row).abs();
    final dc = (a.col - b.col).abs();
    return (dr <= 1 && dc <= 1) && !(dr == 0 && dc == 0);
  }

  Board withRemovedCells(Set<String> removedIds) {
    final newGrid = List<List<Cell>>.generate(
      size,
      (r) => List<Cell>.generate(size, (c) {
        final current = grid[r][c];
        if (removedIds.contains(current.id)) {
          return Cell.empty(row: r, col: c);
        }
        return current;
      }),
    );
    return copyWithGrid(newGrid);
  }

  Board applyGravity(String Function() nextLetter) {
    final newGrid = List<List<Cell>>.generate(
      size,
      (r) => List<Cell>.filled(
        size,
        const Cell(row: -1, col: -1, letter: ''),
        growable: false,
      ),
    );
    for (var c = 0; c < size; c++) {
      var writeRow = size - 1;
      for (var r = size - 1; r >= 0; r--) {
        final current = grid[r][c];
        if (!current.isEmpty) {
          newGrid[writeRow][c] = Cell(
            row: writeRow,
            col: c,
            letter: current.letter,
            power: current.power,
          );
          writeRow--;
        }
      }
      for (var r = writeRow; r >= 0; r--) {
        newGrid[r][c] = Cell(row: r, col: c, letter: nextLetter());
      }
    }
    return copyWithGrid(newGrid);
  }
}
