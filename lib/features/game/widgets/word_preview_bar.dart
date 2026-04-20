import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodel/game_viewmodel.dart';

class WordPreviewBar extends StatelessWidget {
  const WordPreviewBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    final word = vm.currentWord;
    final score = vm.currentPreviewScore;
    final feedback = vm.feedback;

    if (word.isEmpty && feedback.type == TurnFeedbackType.none) {
      return Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          'Harfleri surukleyip kelime olustur',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    if (word.isNotEmpty) {
      return _PreviewBox(
        label: word,
        trailing: score >= 3 ? '+$score' : null,
        color: AppColors.primary,
      );
    }

    switch (feedback.type) {
      case TurnFeedbackType.success:
        return _PreviewBox(
          label: feedback.word,
          trailing: feedback.message,
          color: AppColors.tileValid,
        );
      case TurnFeedbackType.invalid:
        return _PreviewBox(
          label: feedback.word,
          trailing: feedback.message,
          color: AppColors.tileInvalid,
        );
      case TurnFeedbackType.short:
        return _PreviewBox(
          label: feedback.word.isEmpty ? '?' : feedback.word,
          trailing: feedback.message,
          color: AppColors.textSecondary,
        );
      case TurnFeedbackType.none:
        return const SizedBox(height: 52);
    }
  }
}

class _PreviewBox extends StatelessWidget {
  const _PreviewBox({required this.label, this.trailing, required this.color});
  final String label;
  final String? trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
