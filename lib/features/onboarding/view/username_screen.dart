import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UsernameScreen extends StatelessWidget {
  const UsernameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Kullanici Adi Ekrani (Faz 2)',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
        ),
      ),
    );
  }
}
