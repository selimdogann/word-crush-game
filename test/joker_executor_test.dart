import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_crush_game/data/models/board.dart';
import 'package:word_crush_game/data/models/cell.dart';
import 'package:word_crush_game/data/models/difficulty.dart';
import 'package:word_crush_game/data/models/joker.dart';
import 'package:word_crush_game/data/services/joker_executor.dart';
import 'package:word_crush_game/data/services/letter_generator.dart';

Board _board(List<List<String>> letters) {
  final grid = List<List<Cell>>.generate(
    letters.length,
    (r) => List<Cell>.generate(
      letters[r].length,
      (c) => Cell(row: r, col: c, letter: letters[r][c]),
    ),
  );
  return Board(difficulty: Difficulty.hard, grid: grid);
}

void main() {
  test('Lolipop Kirici bir harfi patlatir', () {
    final board = _board([
      ['A', 'B'],
      ['C', 'D'],
    ]);
    final exec = JokerExecutor(
      random: Random(1),
      generator: LetterGenerator(random: Random(1)),
    );
    final before = board.grid.expand((r) => r).where((c) => !c.isEmpty).length;
    final out = exec.apply(board, Joker.lolipopKirici);
    final after = out.board.grid
        .expand((r) => r)
        .where((c) => !c.isEmpty && c.letter.isNotEmpty)
        .length;
    expect(after, before);
    expect(out.message.isNotEmpty, true);
  });

  test('Parti Guclendirici skor carpani yukseltir', () {
    final board = _board([
      ['A', 'B'],
      ['C', 'D'],
    ]);
    final exec = JokerExecutor();
    final out = exec.apply(board, Joker.partiGuclendirici);
    expect(out.pendingScoreMultiplier, 2);
    expect(out.board, board);
  });

  test('Harf Karistirma harfleri korur', () {
    final board = _board([
      ['A', 'B'],
      ['C', 'D'],
    ]);
    final exec = JokerExecutor(random: Random(7));
    final out = exec.apply(board, Joker.harfKaristirma);
    final before = ['A', 'B', 'C', 'D']..sort();
    final after = out.board.grid
        .expand((r) => r)
        .map((c) => c.letter)
        .toList()
      ..sort();
    expect(after, before);
  });
}
