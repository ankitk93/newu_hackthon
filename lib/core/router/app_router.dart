import 'package:flutter/material.dart';

import '../../features/breathing/domain/entities/breathing_config.dart';
import '../../features/breathing/presentation/screens/breathing_screen.dart';
import '../../features/breathing/presentation/screens/finish_screen.dart';
import '../../features/breathing/presentation/screens/setup_screen.dart';

class AppRouter {

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SetupScreen(),
        );
      case '/breathing':
        final config = settings.arguments as BreathingConfig;
        return MaterialPageRoute(
          builder: (_) => BreathingScreen(config: config),
        );
      case '/finish':
        final config = settings.arguments as BreathingConfig;
        return MaterialPageRoute(
          builder: (_) => FinishScreen(config: config),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SetupScreen(),
        );
    }
  }
}