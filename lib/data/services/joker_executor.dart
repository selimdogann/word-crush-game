import 'dart:math';
import '../models/board.dart';
import '../models/cell.dart';
import '../models/joker.dart';
import 'board_factory.dart';
import 'letter_generator.dart';

class JokerOutcome {
  final Board board;
  final String message;
  final bool consumesMove;
  final int pendingScoreMultiplier;

  const JokerOutcome({
    required this.board,
    required this.message,
    this.consumesMove = false,
    this.pendingScoreMultiplier = 1,
  });
}

class JokerExecutor {
  JokerExecutor({
    Random? random,
    BoardFactory? factory,
    LetterGenerator? generator,
  })  : _random = random ?? Random(),
        _factory = factory ?? BoardFactory(),
        _generator = generator ?? LetterGenerator();

  final Random _random;
  final BoardFactory _factory;
  final LetterGenerator _generator;

  JokerOutcome apply(Board board, Joker joker) {
    switch (joker) {
      case Joker.balik:
        return _fish(board);
      case Joker.tekerlek:
        return JokerOutcome(
          board: _factory.create(board.difficulty),
          message: 'Grid yenilendi',
        );
      case Joker.lolipopKirici:
        return _lollipop(board);
      case Joker.serbestDegistirme:
        return _swapLetter(board);
      case Joker.harfKaristirma:
        return _shuffle(board);
      case Joker.partiGuclendirici:
        return JokerOutcome(
          board: board,
          message: 'Sonraki oyun 2 kat puan',
          pendingScoreMultiplier: 2,
        );
    }
  }

  JokerOutcome _fish(Board board) {
    final cells = _nonEmptyCells(board);
    if (cells.isEmpty) {
      return JokerOutcome(board: board, message: 'Patlatacak harf yok');
    }
    cells.sort((a, b) => a.point.compareTo(b.point));
    final victims = cells.take(3).map((c) => c.id).toSet();
    final newBoard =
        board.withRemovedCells(victims).applyGravity(_generator.next);
    return JokerOutcome(
      board: newBoard,
      message: '${victims.length} dusuk harf patladi',
    );
  }

  JokerOutcome _lollipop(Board board) {
    final cells = _nonEmptyCells(board);
    if (cells.isEmpty) {
      return JokerOutcome(board: board, message: 'Patlatacak harf yok');
    }
    final victim = cells[_random.nextInt(cells.length)];
    final newBoard = board
        .withRemovedCells({victim.id}).applyGravity(_generator.next);
    return JokerOutcome(board: newBoard, message: '${victim.letter} patladi');
  }

  JokerOutcome _swapLetter(Board board) {
    final cells = _nonEmptyCells(board);
    if (cells.isEmpty) {
      return JokerOutcome(board: board, message: 'Degistirilecek harf yok');
    }
    final target = cells[_random.nextInt(cells.length)];
    final newLetter = _generator.next();
    final newGrid = List<List<Cell>>.generate(
      board.size,
      (r) => List<Cell>.generate(board.size, (c) {
        final current = board.grid[r][c];
        if (current.id == target.id) {
          return Cell(row: r, col: c, letter: newLetter);
        }
        return current;
      }),
    );
    return JokerOutcome(
      board: board.copyWithGrid(newGrid),
      message: '${target.letter} -> $newLetter',
    );
  }

  JokerOutcome _shuffle(Board board) {
    final positions = <List<int>>[];
    final letters = <String>[];
    for (var r = 0; r < board.size; r++) {
      for (var c = 0; c < board.size; c++) {
        final cell = board.grid[r][c];
        if (!cell.isEmpty) {
          positions.add([r, c]);
          letters.add(cell.letter);
        }
      }
    }
    if (letters.length < 2) {
      return JokerOutcome(board: board, message: 'Karistirilacak harf yok');
    }
    letters.shuffle(_random);
    final newGrid = List<List<Cell>>.generate(
      board.size,
      (r) => List<Cell>.generate(board.size, (c) {
        final current = board.grid[r][c];
        return current.isEmpty ? current : Cell(row: r, col: c, letter: '');
      }),
    );
    for (var i = 0; i < positions.length; i++) {
      final r = positions[i][0];
      final c = positions[i][1];
      newGrid[r][c] = Cell(row: r, col: c, letter: letters[i]);
    }
    return JokerOutcome(
      board: board.copyWithGrid(newGrid),
      message: 'Harfler karistirildi',
    );
  }

  List<Cell> _nonEmptyCells(Board board) {
    final list = <Cell>[];
    for (final row in board.grid) {
      for (final cell in row) {
        if (!cell.isEmpty) list.add(cell);
      }
    }
    return list;
  }
}
