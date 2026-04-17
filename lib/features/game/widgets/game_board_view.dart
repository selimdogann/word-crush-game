import 'package:flutter/material.dart';
import '../../../data/models/board.dart';
import 'letter_tile.dart';

class GameBoardView extends StatelessWidget {
  const GameBoardView({super.key, required this.board});

  final Board board;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: board.size * board.size,
            padding: const EdgeInsets.all(6),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: board.size,
            ),
            itemBuilder: (context, index) {
              final row = index ~/ board.size;
              final col = index % board.size;
              final cell = board.cellAt(row, col);
              return LetterTile(cell: cell);
            },
          );
        },
      ),
    );
  }
}
