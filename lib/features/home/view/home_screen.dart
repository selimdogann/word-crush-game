import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Ana Ekran (Faz 2)',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
        ),
      ),
    );
  }
}
