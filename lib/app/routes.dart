import 'package:flutter/material.dart';
import 'package:eduvillage/screens/splash/splash_screen.dart';
import 'package:eduvillage/screens/home/home_screen.dart';
import 'package:eduvillage/screens/activity_game/activity_game_screen.dart';
import 'package:eduvillage/screens/object_game/object_game_screen.dart';
import 'package:eduvillage/screens/word_game/word_game_screen.dart';
import 'package:eduvillage/screens/math_game/math_game_screen.dart';

/// App Routes Configuration
// Maps named routes to the corresponding screen widgets.
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String activityGame = '/activity-game';
  static const String objectGame = '/object-game';
  static const String wordGame = '/word-game';
  static const String mathGame = '/math-game';

  /// Generate routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case activityGame:
        return MaterialPageRoute(builder: (_) => const ActivityGameScreen());
      case objectGame:
        return MaterialPageRoute(builder: (_) => const ObjectGameScreen());
      case wordGame:
        return MaterialPageRoute(builder: (_) => const WordGameScreen());
      case mathGame:
        return MaterialPageRoute(builder: (_) => const MathGameScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }

  /// Initial route
  static const String initialRoute = splash;
}
