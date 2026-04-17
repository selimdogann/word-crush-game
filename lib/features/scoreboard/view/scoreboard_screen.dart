import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skor Tablosu')),
      body: const Center(
        child: Text('Skor Tablosu (Faz 6)',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
      ),
    );
  }
}
