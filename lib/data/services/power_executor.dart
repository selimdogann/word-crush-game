import '../models/board.dart';
import '../models/cell.dart';

class PowerExecutor {
  const PowerExecutor();

  Set<String> extraCellsFor({
    required Board board,
    required List<Cell> selection,
    required CellPower power,
  }) {
    if (selection.isEmpty || power == CellPower.none) return const {};
    final anchor = selection.last;

    switch (power) {
      case CellPower.rowClear:
        return _rowIds(board, anchor.row);
      case CellPower.columnClear:
        return _columnIds(board, anchor.col);
      case CellPower.areaBlast:
        final center = selection[selection.length ~/ 2];
        return _areaIds(board, center.row, center.col, radius: 1);
      case CellPower.megaBlast:
        final center = selection[selection.length ~/ 2];
        return _areaIds(board, center.row, center.col, radius: 2);
      case CellPower.none:
        return const {};
    }
  }

  Set<String> _rowIds(Board board, int row) {
    final ids = <String>{};
    for (var c = 0; c < board.size; c++) {
      final cell = board.cellAt(row, c);
      if (!cell.isEmpty) ids.add(cell.id);
    }
    return ids;
  }

  Set<String> _columnIds(Board board, int col) {
    final ids = <String>{};
    for (var r = 0; r < board.size; r++) {
      final cell = board.cellAt(r, col);
      if (!cell.isEmpty) ids.add(cell.id);
    }
    return ids;
  }

  Set<String> _areaIds(Board board, int row, int col, {required int radius}) {
    final ids = <String>{};
    for (var dr = -radius; dr <= radius; dr++) {
      for (var dc = -radius; dc <= radius; dc++) {
        final r = row + dr;
        final c = col + dc;
        if (!board.inBounds(r, c)) continue;
        final cell = board.cellAt(r, c);
        if (!cell.isEmpty) ids.add(cell.id);
      }
    }
    return ids;
  }
}
