import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newu_health/core/theme/app_theme.dart';
import 'package:newu_health/core/theme/theme_cubit.dart';
import 'package:newu_health/features/breathing/domain/entities/breathing_config.dart';
import 'package:newu_health/features/breathing/presentation/screens/setup_screen.dart';
import 'package:newu_health/features/breathing/presentation/screens/breathing_screen.dart';
import 'package:newu_health/features/breathing/presentation/screens/finish_screen.dart';

/// Root widget for the NewU app.
class NewUApp extends StatelessWidget {
  const NewUApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'NewU Breathing',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: '/',
            onGenerateRoute: _onGenerateRoute,
          );
        },
      ),
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
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
