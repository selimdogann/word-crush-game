import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/joker.dart';
import '../viewmodel/game_viewmodel.dart';

class JokerBar extends StatelessWidget {
  const JokerBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    final owned = Joker.values
        .where((j) => vm.inventory.countOf(j) > 0)
        .toList(growable: false);

    if (owned.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: const [
            Icon(Icons.backpack_outlined,
                color: AppColors.textSecondary, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Envanterin bos. Marketten joker satin alabilirsin.',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: owned.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final joker = owned[index];
          final count = vm.inventory.countOf(joker);
          final disabled = vm.isGameOver;
          return _JokerChip(
            joker: joker,
            count: count,
            onTap: disabled ? null : () => vm.useJoker(joker),
          );
        },
      ),
    );
  }
}

class _JokerChip extends StatelessWidget {
  const _JokerChip({
    required this.joker,
    required this.count,
    required this.onTap,
  });

  final Joker joker;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Text(joker.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 6),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    joker.label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Text('x$count',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
