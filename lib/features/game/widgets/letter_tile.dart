import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/cell.dart';

class LetterTile extends StatelessWidget {
  const LetterTile({
    super.key,
    required this.cell,
    this.selected = false,
  });

  final Cell cell;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.tileSelected : AppColors.cardTile;
    final fg = AppColors.textOnTile;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              cell.letter,
              style: TextStyle(
                color: fg,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 2,
            child: Text(
              '${cell.point}',
              style: TextStyle(
                color: fg.withValues(alpha: 0.55),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
