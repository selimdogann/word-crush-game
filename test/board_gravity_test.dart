import 'package:flutter_test/flutter_test.dart';
import 'package:word_crush_game/data/models/board.dart';
import 'package:word_crush_game/data/models/cell.dart';
import 'package:word_crush_game/data/models/difficulty.dart';

void main() {
  Board buildBoard(List<List<String>> letters) {
    final grid = List<List<Cell>>.generate(
      letters.length,
      (r) => List<Cell>.generate(
        letters[r].length,
        (c) => letters[r][c].isEmpty
            ? Cell.empty(row: r, col: c)
            : Cell(row: r, col: c, letter: letters[r][c]),
      ),
    );
    return Board(difficulty: Difficulty.hard, grid: grid);
  }

  test('Bos hucre ustundeki harf asagi duser', () {
    final board = buildBoard([
      ['A', 'B'],
      ['', 'D'],
    ]);
    expect(board.size, 2);
    final fed = board.applyGravity(() => 'X');
    expect(fed.cellAt(1, 0).letter, 'A');
    expect(fed.cellAt(0, 0).letter, 'X');
  });

  test('Komsu hucre kontrolu 8 yon', () {
    final board = buildBoard([
      ['A', 'B', 'C'],
      ['D', 'E', 'F'],
      ['G', 'H', 'I'],
    ]);
    final cCenter = board.cellAt(1, 1);
    final cDiagonal = board.cellAt(0, 0);
    expect(board.isNeighbor(cCenter, cDiagonal), isTrue);
    final cFar = board.cellAt(0, 0);
    final cFar2 = board.cellAt(2, 2);
    expect(board.isNeighbor(cFar, cFar2), isFalse);
  });
}
