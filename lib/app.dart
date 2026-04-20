import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/inventory_repository.dart';
import 'data/repositories/stats_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/services/dictionary_service.dart';
import 'data/services/word_validator.dart';

class WordCrushApp extends StatelessWidget {
  const WordCrushApp({
    super.key,
    required this.userRepository,
    required this.statsRepository,
    required this.inventoryRepository,
    required this.dictionary,
  });

  final UserRepository userRepository;
  final StatsRepository statsRepository;
  final InventoryRepository inventoryRepository;
  final DictionaryService dictionary;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: userRepository),
        Provider<StatsRepository>.value(value: statsRepository),
        Provider<InventoryRepository>.value(value: inventoryRepository),
        Provider<DictionaryService>.value(value: dictionary),
        Provider<WordValidator>(
          create: (_) => WordValidator(dictionary),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: userRepository.hasUsername()
            ? AppRoutes.home
            : AppRoutes.username,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
