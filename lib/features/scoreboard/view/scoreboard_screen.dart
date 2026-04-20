import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/stats_repository.dart';
import '../viewmodel/scoreboard_viewmodel.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ScoreboardViewModel(ctx.read<StatsRepository>()),
      child: const _ScoreboardView(),
    );
  }
}

class _ScoreboardView extends StatelessWidget {
  const _ScoreboardView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScoreboardViewModel>();
    final s = vm.stats;
    return Scaffold(
      appBar: AppBar(title: const Text('Skor Tablosu')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            _HighlightCard(
              title: 'En Yuksek Skor',
              value: '${s.highScore}',
              icon: Icons.emoji_events_rounded,
              color: AppColors.accent,
            ),
            const SizedBox(height: 12),
            _StatTile(
              label: 'Toplam Oyun',
              value: '${s.totalGames}',
              icon: Icons.sports_esports_rounded,
            ),
            _StatTile(
              label: 'Ortalama Skor',
              value: s.averageScore.toStringAsFixed(1),
              icon: Icons.analytics_rounded,
            ),
            _StatTile(
              label: 'Toplam Bulunan Kelime',
              value: '${s.totalWords}',
              icon: Icons.abc_rounded,
            ),
            _StatTile(
              label: 'En Uzun Kelime',
              value: s.longestWord.isEmpty ? '-' : s.longestWord,
              icon: Icons.straighten_rounded,
            ),
            _StatTile(
              label: 'Toplam Oyun Suresi',
              value: _formatDuration(s.totalDurationSeconds),
              icon: Icons.timer_rounded,
            ),
            if (s.totalGames == 0)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text(
                  'Henuz oyun oynanmamis. Yeni oyuna basla!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '0 dk';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    if (hours > 0) return '$hours sa $minutes dk';
    if (minutes > 0) return '$minutes dk $seconds sn';
    return '$seconds sn';
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.25), AppColors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 28,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14)),
          ),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
