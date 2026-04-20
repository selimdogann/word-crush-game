import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'data/repositories/inventory_repository.dart';
import 'data/repositories/stats_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/services/dictionary_service.dart';
import 'data/services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final prefs = await PreferencesService.getInstance();
  final userRepo = UserRepository(prefs);
  final statsRepo = StatsRepository(prefs);
  final inventoryRepo = InventoryRepository(prefs);
  final dictionary = await DictionaryService.load();

  runApp(WordCrushApp(
    userRepository: userRepo,
    statsRepository: statsRepo,
    inventoryRepository: inventoryRepo,
    dictionary: dictionary,
  ));
}
