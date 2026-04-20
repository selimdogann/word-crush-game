import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/game_viewmodel.dart';
import 'letter_tile.dart';

class GameBoardView extends StatelessWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    final board = vm.board;

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final side = constraints.maxWidth;
          final tileSize = side / board.size;

          void handleAt(Offset local, {required bool isStart}) {
            final row = (local.dy / tileSize).floor();
            final col = (local.dx / tileSize).floor();
            if (!board.inBounds(row, col)) return;
            final cell = board.cellAt(row, col);
            if (cell.isEmpty) return;
            if (isStart) {
              vm.startSelection(cell);
            } else {
              vm.extendSelection(cell);
            }
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanStart: (d) => handleAt(d.localPosition, isStart: true),
            onPanUpdate: (d) => handleAt(d.localPosition, isStart: false),
            onPanEnd: (_) => vm.commitSelection(),
            onPanCancel: vm.cancelSelection,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: board.size * board.size,
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: board.size,
              ),
              itemBuilder: (context, index) {
                final r = index ~/ board.size;
                final c = index % board.size;
                final cell = board.cellAt(r, c);
                final idx = vm.indexOfSelected(cell);
                return LetterTile(
                  cell: cell,
                  selected: idx >= 0,
                  selectionIndex: idx >= 0 ? idx : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
