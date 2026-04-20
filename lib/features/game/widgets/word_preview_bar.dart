import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/cell.dart';
import '../viewmodel/game_viewmodel.dart';

class WordPreviewBar extends StatelessWidget {
  const WordPreviewBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    final word = vm.currentWord;
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
        trailing: vm.currentPreviewScore >= 3 ? '+${vm.currentPreviewScore}' : null,
        color: AppColors.primary,
        power: vm.previewPower,
      );
    }

    switch (feedback.type) {
      case TurnFeedbackType.success:
        return _SuccessBox(feedback: feedback);
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
  const _PreviewBox({
    required this.label,
    this.trailing,
    required this.color,
    this.power = CellPower.none,
  });

  final String label;
  final String? trailing;
  final Color color;
  final CellPower power;

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
          if (power != CellPower.none)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                power.label,
                style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
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

class _SuccessBox extends StatelessWidget {
  const _SuccessBox({required this.feedback});
  final TurnFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.tileValid;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  feedback.word,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              if (feedback.power != CellPower.none)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    feedback.power.label,
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              Text(
                '+${feedback.earnedScore}',
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _detail(feedback),
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  String _detail(TurnFeedback f) {
    final parts = <String>['Kelime: ${f.baseScore}'];
    if (f.comboScore > 0) {
      parts.add('Combo (${f.subWords.join(", ")}): ${f.comboScore}');
    }
    if (f.powerScore > 0) parts.add('Guc: ${f.powerScore}');
    return parts.join(' · ');
  }
}
