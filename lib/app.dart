import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/user_repository.dart';

class WordCrushApp extends StatelessWidget {
  const WordCrushApp({super.key, required this.userRepository});

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: userRepository),
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
