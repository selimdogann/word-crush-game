import 'package:flutter/material.dart';
import '../../features/game/view/new_game_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/market/view/market_screen.dart';
import '../../features/onboarding/view/username_screen.dart';
import '../../features/scoreboard/view/scoreboard_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String username = '/username';
  static const String home = '/home';
  static const String newGame = '/new-game';
  static const String scoreboard = '/scoreboard';
  static const String market = '/market';

  static Map<String, WidgetBuilder> get routes => {
        username: (_) => const UsernameScreen(),
        home: (_) => const HomeScreen(),
        newGame: (_) => const NewGameScreen(),
        scoreboard: (_) => const ScoreboardScreen(),
        market: (_) => const MarketScreen(),
      };
}
