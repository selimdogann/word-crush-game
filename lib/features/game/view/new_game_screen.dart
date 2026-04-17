import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/difficulty.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Oyun')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(
                'Zorluk Sec',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Grid boyutu ve hamle sayisi secimine gore degisir.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ...Difficulty.values.map(
                (d) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _DifficultyCard(
                    difficulty: d,
                    onTap: () => Navigator.of(context).pushReplacementNamed(
                      AppRoutes.game,
                      arguments: d,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({required this.difficulty, required this.onTap});

  final Difficulty difficulty;
  final VoidCallback onTap;

  Color get _color {
    switch (difficulty) {
      case Difficulty.easy:
        return const Color(0xFF00B894);
      case Difficulty.medium:
        return AppColors.accent;
      case Difficulty.hard:
        return const Color(0xFFE74C3C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${difficulty.gridSize}x${difficulty.gridSize}',
                    style: TextStyle(
                      color: _color,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      difficulty.label,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${difficulty.moveCount} hamle',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
