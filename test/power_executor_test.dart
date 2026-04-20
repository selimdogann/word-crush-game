import 'package:flutter_test/flutter_test.dart';
import 'package:word_crush_game/data/models/board.dart';
import 'package:word_crush_game/data/models/cell.dart';
import 'package:word_crush_game/data/models/difficulty.dart';
import 'package:word_crush_game/data/services/power_executor.dart';

void main() {
  Board buildBoard(int size) {
    final grid = List<List<Cell>>.generate(
      size,
      (r) => List<Cell>.generate(
        size,
        (c) => Cell(row: r, col: c, letter: 'A'),
      ),
    );
    return Board(difficulty: Difficulty.hard, grid: grid);
  }

  const executor = PowerExecutor();

  test('Row clear tum satir hucrelerini kapsar', () {
    final board = buildBoard(6);
    final selection = [
      board.cellAt(2, 1),
      board.cellAt(2, 2),
      board.cellAt(2, 3),
      board.cellAt(2, 4),
    ];
    final ids = executor.extraCellsFor(
      board: board,
      selection: selection,
      power: CellPower.rowClear,
    );
    expect(ids.length, 6);
    expect(ids, contains('2-0'));
    expect(ids, contains('2-5'));
  });

  test('Column clear tum sutun hucrelerini kapsar', () {
    final board = buildBoard(6);
    final selection = [
      board.cellAt(0, 3),
      board.cellAt(1, 3),
      board.cellAt(2, 3),
      board.cellAt(3, 3),
      board.cellAt(4, 3),
      board.cellAt(5, 3),
    ];
    final ids = executor.extraCellsFor(
      board: board,
      selection: selection,
      power: CellPower.columnClear,
    );
    expect(ids.length, 6);
    expect(ids, contains('0-3'));
    expect(ids, contains('5-3'));
  });

  test('Area blast 3x3 alani kapsar', () {
    final board = buildBoard(6);
    final selection = [
      board.cellAt(2, 1),
      board.cellAt(2, 2),
      board.cellAt(2, 3),
      board.cellAt(2, 4),
      board.cellAt(2, 5),
    ];
    final ids = executor.extraCellsFor(
      board: board,
      selection: selection,
      power: CellPower.areaBlast,
    );
    expect(ids.length, 9);
  });

  test('Mega blast 5x5 alani kapsar', () {
    final board = buildBoard(6);
    final selection = List<Cell>.generate(
      7,
      (i) => board.cellAt(2, i % 6),
    );
    final ids = executor.extraCellsFor(
      board: board,
      selection: selection,
      power: CellPower.megaBlast,
    );
    expect(ids.length, greaterThanOrEqualTo(9));
  });
}
