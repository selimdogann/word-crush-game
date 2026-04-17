import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Oyun')),
      body: const Center(
        child: Text('Yeni Oyun (Faz 3)',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
      ),
    );
  }
}
