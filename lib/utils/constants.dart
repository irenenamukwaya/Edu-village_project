import 'package:flutter/material.dart';

/// Constants for EduVillage Application
class AppConstants {
  // App Names
  static const String appName = 'Edu-Reach';
  static const String appSlogan = 'Learning Through Play';

  // Coin Settings
  static const int coinsPerCorrectAnswer = 5;
  static const int coinsPerRoundCompletion = 20;
  static const int mathChallengeUnlockCost = 60;

  // Game Settings
  static const int totalQuestionsPerGame = 10;
  static const Duration questionDisplayDuration = Duration(seconds: 2);
  static const Duration answerFeedbackDuration = Duration(seconds: 1);

  // Math Game Modes
  static const int maxNumberForCounting = 20;
  static const int maxAdditionSubtractionValue = 10;
  static const int maxMultiplicationValue = 5;
  static const int maxDivisionValue = 5;

  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF555555),
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF333333),
  );

  static const TextStyle buttonStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  // Sound Settings
  static const bool soundEnabled = true;
  static const double soundVolume = 1.0;

  // Animation Durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration buttonPressAnimation = Duration(milliseconds: 150);
  static const Duration correctAnswerAnimation = Duration(milliseconds: 500);
}

/// Game Types Enum
enum GameType { activity, object, word, math }

/// Math Game Mode Enum
enum MathGameMode { numberLearning, counting, arithmetic }

/// Arithmetic Operation Enum
enum ArithmeticOperation { addition, subtraction, multiplication, division }

/// Game Status Enum
enum GameStatus { idle, inProgress, answered, completed }
