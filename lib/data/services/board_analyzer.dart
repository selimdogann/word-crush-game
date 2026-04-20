import '../models/board.dart';
import 'dictionary_service.dart';

class BoardAnalyzer {
  const BoardAnalyzer(this._dict, {this.maxDepth = 7});

  final DictionaryService _dict;
  final int maxDepth;

  bool hasAnyValidWord(Board board) {
    final size = board.size;
    final visited = List<List<bool>>.generate(
      size,
      (_) => List<bool>.filled(size, false),
    );
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        if (board.grid[r][c].isEmpty) continue;
        if (_dfs(board, r, c, board.grid[r][c].letter, visited)) {
          return true;
        }
      }
    }
    return false;
  }

  bool _dfs(
    Board board,
    int r,
    int c,
    String current,
    List<List<bool>> visited,
  ) {
    visited[r][c] = true;
    var result = false;
    if (current.length >= 3 && _dict.contains(current)) {
      result = true;
    } else if (current.length < maxDepth && _dict.hasPrefix(current)) {
      for (var dr = -1; dr <= 1 && !result; dr++) {
        for (var dc = -1; dc <= 1 && !result; dc++) {
          if (dr == 0 && dc == 0) continue;
          final nr = r + dr;
          final nc = c + dc;
          if (!board.inBounds(nr, nc)) continue;
          if (visited[nr][nc]) continue;
          final cell = board.grid[nr][nc];
          if (cell.isEmpty) continue;
          if (_dfs(board, nr, nc, current + cell.letter, visited)) {
            result = true;
          }
        }
      }
    }
    visited[r][c] = false;
    return result;
  }
}
