import 'package:flutter_test/flutter_test.dart';
import 'package:word_crush_game/data/models/board.dart';
import 'package:word_crush_game/data/models/cell.dart';
import 'package:word_crush_game/data/models/difficulty.dart';
import 'package:word_crush_game/data/services/board_analyzer.dart';
import 'package:word_crush_game/data/services/dictionary_service.dart';

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
  TestWidgetsFlutterBinding.ensureInitialized();
  late DictionaryService dict;

  setUpAll(() async {
    dict = await DictionaryService.load();
  });

  test('Bitisik harflerle kelime olusuyorsa true doner', () {
    final board = _board([
      ['K', 'A', 'L'],
      ['X', 'E', 'M'],
      ['Y', 'Z', 'T'],
    ]);
    final analyzer = BoardAnalyzer(dict, maxDepth: 5);
    expect(analyzer.hasAnyValidWord(board), true);
  });

  test('Tek harfli ayrik gridde kelime bulunmaz', () {
    final board = _board([
      ['Z'],
    ]);
    final analyzer = BoardAnalyzer(dict, maxDepth: 5);
    expect(analyzer.hasAnyValidWord(board), false);
  });
}
