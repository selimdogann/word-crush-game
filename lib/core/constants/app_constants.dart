class AppConstants {
  AppConstants._();

  static const String appName = 'Word Crush';

  static const String prefUsername = 'pref_username';
  static const String prefCoins = 'pref_coins';
  static const String prefStats = 'pref_stats';
  static const String prefGameHistory = 'pref_game_history';
  static const String prefInventory = 'pref_inventory';

  static const int minWordLength = 3;
  static const int initialCoins = 500;

  static const Map<String, int> gridSizes = {
    'easy': 10,
    'medium': 8,
    'hard': 6,
  };

  static const Map<String, int> moveCounts = {
    'easy': 25,
    'medium': 20,
    'hard': 15,
  };

  static const Map<String, String> difficultyLabels = {
    'easy': 'Kolay',
    'medium': 'Orta',
    'hard': 'Zor',
  };
}
