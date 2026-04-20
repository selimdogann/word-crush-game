import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/difficulty.dart';
import '../../../data/services/word_validator.dart';
import '../viewmodel/game_viewmodel.dart';
import '../widgets/game_board_view.dart';
import '../widgets/word_preview_bar.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => GameViewModel(
        difficulty: difficulty,
        validator: ctx.read<WordValidator>(),
      ),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${vm.difficulty.label} - ${vm.board.size}x${vm.board.size}'),
        actions: [
          IconButton(
            tooltip: 'Gridi karistir',
            icon: const Icon(Icons.shuffle_rounded),
            onPressed: vm.reshuffleBoard,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _HudRow(score: vm.score, moves: vm.remainingMoves),
              const SizedBox(height: 12),
              const WordPreviewBar(),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const GameBoardView(),
              ),
              const SizedBox(height: 12),
              if (vm.isGameOver)
                _GameOverBanner(score: vm.score, longestWord: vm.longestWord),
            ],
          ),
        ),
      ),
    );
  }
}

class _HudRow extends StatelessWidget {
  const _HudRow({required this.score, required this.moves});
  final int score;
  final int moves;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HudChip(
          icon: Icons.star_rounded,
          label: 'Puan',
          value: '$score',
          color: AppColors.accent,
        ),
        _HudChip(
          icon: Icons.swap_horiz_rounded,
          label: 'Hamle',
          value: '$moves',
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              Text(value,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _GameOverBanner extends StatelessWidget {
  const _GameOverBanner({required this.score, required this.longestWord});
  final int score;
  final String longestWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Hamleler bitti!',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text('Skor: $score',
              style: const TextStyle(color: AppColors.accent, fontSize: 16)),
          if (longestWord.isNotEmpty)
            Text('En uzun kelime: $longestWord',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ana Ekrana Don'),
          ),
        ],
      ),
    );
  }
}
