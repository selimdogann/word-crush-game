import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => HomeViewModel(ctx.read<UserRepository>()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(username: vm.username, coins: vm.coins),
              const Spacer(),
              const _Logo(),
              const SizedBox(height: 40),
              GradientButton(
                label: 'Yeni Oyun',
                icon: Icons.play_arrow_rounded,
                onPressed: () async {
                  await Navigator.of(context).pushNamed(AppRoutes.newGame);
                  if (context.mounted) context.read<HomeViewModel>().refresh();
                },
              ),
              const SizedBox(height: 14),
              GradientButton(
                label: 'Skor Tablosu',
                icon: Icons.leaderboard_rounded,
                colors: const [Color(0xFF00B894), Color(0xFF00856A)],
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.scoreboard),
              ),
              const SizedBox(height: 14),
              GradientButton(
                label: 'Market',
                icon: Icons.storefront_rounded,
                colors: const [Color(0xFFFF7675), Color(0xFFD63031)],
                onPressed: () async {
                  await Navigator.of(context).pushNamed(AppRoutes.market);
                  if (context.mounted) context.read<HomeViewModel>().refresh();
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.username, required this.coins});
  final String username;
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Merhaba',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
              Text(username,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.monetization_on_rounded,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 6),
              Text('$coins',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Icon(Icons.grid_view_rounded,
              color: Colors.white, size: 64),
        ),
        const SizedBox(height: 14),
        Text('Word Crush',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
      ],
    );
  }
}
