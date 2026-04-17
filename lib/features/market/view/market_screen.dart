import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market')),
      body: const Center(
        child: Text('Market (Faz 6)',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
      ),
    );
  }
}
