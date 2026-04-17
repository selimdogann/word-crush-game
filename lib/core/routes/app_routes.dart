import 'package:flutter/material.dart';
import '../../features/onboarding/view/username_screen.dart';
import '../../features/home/view/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String username = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        username: (_) => const UsernameScreen(),
        home: (_) => const HomeScreen(),
      };
}
