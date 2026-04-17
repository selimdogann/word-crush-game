import 'package:flutter/material.dart';
import '../../data/models/difficulty.dart';
import '../../features/game/view/game_screen.dart';
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
  static const String game = '/game';
  static const String scoreboard = '/scoreboard';
  static const String market = '/market';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case username:
        return MaterialPageRoute(builder: (_) => const UsernameScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case newGame:
        return MaterialPageRoute(builder: (_) => const NewGameScreen());
      case scoreboard:
        return MaterialPageRoute(builder: (_) => const ScoreboardScreen());
      case market:
        return MaterialPageRoute(builder: (_) => const MarketScreen());
      case game:
        final diff = settings.arguments as Difficulty? ?? Difficulty.medium;
        return MaterialPageRoute(
          builder: (_) => GameScreen(difficulty: diff),
        );
    }
    return null;
  }
}
