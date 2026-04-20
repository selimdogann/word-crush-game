import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/joker.dart';
import '../../../data/repositories/inventory_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../viewmodel/market_viewmodel.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => MarketViewModel(
        userRepo: ctx.read<UserRepository>(),
        inventoryRepo: ctx.read<InventoryRepository>(),
      ),
      child: const _MarketView(),
    );
  }
}

class _MarketView extends StatelessWidget {
  const _MarketView();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MarketViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on_rounded,
                    color: AppColors.accent, size: 22),
                const SizedBox(width: 4),
                Text('${vm.coins}',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (vm.lastMessage != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(vm.lastMessage!,
                            style: const TextStyle(
                                color: AppColors.textPrimary))),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.textSecondary),
                      onPressed: vm.clearMessage,
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: Joker.values.length,
                itemBuilder: (context, index) {
                  final joker = Joker.values[index];
                  final owned = vm.inventory.countOf(joker);
                  return _JokerCard(
                    joker: joker,
                    owned: owned,
                    canAfford: vm.coins >= joker.price,
                    onBuy: () => vm.buy(joker),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JokerCard extends StatelessWidget {
  const _JokerCard({
    required this.joker,
    required this.owned,
    required this.canAfford,
    required this.onBuy,
  });

  final Joker joker;
  final int owned;
  final bool canAfford;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(joker.icon,
                style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        joker.label,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (owned > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.tileValid.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Stok: $owned',
                            style: const TextStyle(
                                color: AppColors.tileValid,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  joker.description,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded,
                        color: AppColors.accent, size: 16),
                    const SizedBox(width: 4),
                    Text('${joker.price}',
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: canAfford ? onBuy : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Satin Al'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
