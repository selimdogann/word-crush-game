import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/difficulty.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/repositories/stats_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/services/board_analyzer.dart';
import '../../../data/services/dictionary_service.dart';
import '../../../data/services/word_validator.dart';
import '../viewmodel/game_viewmodel.dart';
import '../widgets/game_board_view.dart';
import '../widgets/joker_bar.dart';
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
        statsRepo: ctx.read<StatsRepository>(),
        userRepo: ctx.read<UserRepository>(),
        inventoryRepo: ctx.read<InventoryRepository>(),
        analyzer: BoardAnalyzer(ctx.read<DictionaryService>()),
      ),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  Future<bool> _confirmExit(BuildContext context, GameViewModel vm) async {
    if (vm.isGameOver || vm.score == 0 && vm.totalWords == 0) return true;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Oyundan cik',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Oyunu simdi biraktirirsan mevcut skor kaydedilecek. Emin misin?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Vazgec'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('Cik'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await vm.abandonGame();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final allow = await _confirmExit(context, vm);
        if (allow && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
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
              _HudRow(
                score: vm.score,
                moves: vm.remainingMoves,
                multiplier: vm.scoreMultiplier,
              ),
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
              const JokerBar(),
              if (vm.jokerMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _JokerToast(
                    message: vm.jokerMessage!,
                    onClose: vm.clearJokerMessage,
                  ),
                ),
              const SizedBox(height: 12),
              if (vm.isGameOver)
                _GameOverBanner(
                  score: vm.score,
                  longestWord: vm.longestWord,
                  totalWords: vm.totalWords,
                  durationSeconds: vm.durationSeconds,
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _HudRow extends StatelessWidget {
  const _HudRow({
    required this.score,
    required this.moves,
    required this.multiplier,
  });
  final int score;
  final int moves;
  final int multiplier;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _HudChip(
          icon: Icons.star_rounded,
          label: multiplier > 1 ? 'Puan (x$multiplier)' : 'Puan',
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

class _JokerToast extends StatelessWidget {
  const _JokerToast({required this.message, required this.onClose});
  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on_rounded,
              color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close,
                color: AppColors.textSecondary, size: 18),
          ),
        ],
      ),
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
  const _GameOverBanner({
    required this.score,
    required this.longestWord,
    required this.totalWords,
    required this.durationSeconds,
  });
  final int score;
  final String longestWord;
  final int totalWords;
  final int durationSeconds;

  String _fmtDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final coinReward = (score / 10).floor();
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 20),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.emoji_events_rounded,
                color: AppColors.accent, size: 40),
            const SizedBox(height: 6),
            const Text(
              'Oyun bitti!',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SummaryStat(label: 'Puan', value: '$score'),
                _SummaryStat(label: 'Kelime', value: '$totalWords'),
                _SummaryStat(
                    label: 'Sure', value: _fmtDuration(durationSeconds)),
              ],
            ),
            if (longestWord.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text('En uzun kelime: $longestWord',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ],
            if (coinReward > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on_rounded,
                        color: AppColors.accent, size: 18),
                    const SizedBox(width: 4),
                    Text('+$coinReward coin',
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ana Ekrana Don'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
