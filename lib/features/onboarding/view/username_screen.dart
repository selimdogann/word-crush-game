import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../viewmodel/username_viewmodel.dart';

class UsernameScreen extends StatelessWidget {
  const UsernameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => UsernameViewModel(ctx.read<UserRepository>()),
      child: const _UsernameView(),
    );
  }
}

class _UsernameView extends StatelessWidget {
  const _UsernameView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UsernameViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Icon(Icons.grid_view_rounded,
                  size: 84, color: AppColors.accent),
              const SizedBox(height: 16),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Turkce kelime avina hos geldin!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
              ),
              const Spacer(flex: 2),
              TextField(
                onChanged: vm.onChanged,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Kullanici adin',
                  errorText: vm.error,
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GradientButton(
                label: vm.loading ? 'Kaydediliyor...' : 'Oyuna Basla',
                icon: Icons.arrow_forward_rounded,
                enabled: vm.canSubmit,
                onPressed: () async {
                  final ok = await vm.submit();
                  if (ok && context.mounted) {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.home);
                  }
                },
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
