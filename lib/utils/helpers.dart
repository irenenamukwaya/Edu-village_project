import 'dart:math';
import 'package:eduvillage/utils/constants.dart';

/// Helper functions for EduVillage Application
// Utility helpers shared by screens and services.
class AppHelpers {
  /// Generate random integer between min and max (inclusive)
  static int randomInt(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  /// Shuffle list and return new list
  static List<T> shuffleList<T>(List<T> list) {
    final newList = [...list];
    newList.shuffle();
    return newList;
  }

  /// Get random item from list
  static T getRandomItem<T>(List<T> list) {
    return list[Random().nextInt(list.length)];
  }

  /// Get random items from list without repetition
  static List<T> getRandomItems<T>(List<T> list, int count) {
    if (count >= list.length) return [...list];
    final shuffled = shuffleList(list);
    return shuffled.take(count).toList();
  }

  /// Convert number to word
  static String numberToWord(int number) {
    const words = [
      'Zero',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
      'Twenty',
    ];

    if (number >= 0 && number < words.length) {
      return words[number];
    }
    return number.toString();
  }

  /// Get random arithmetic operation
  static ArithmeticOperation getRandomOperation() {
    final operations = ArithmeticOperation.values;
    return operations[Random().nextInt(operations.length)];
  }

  /// Get operation symbol
  static String getOperationSymbol(ArithmeticOperation operation) {
    switch (operation) {
      case ArithmeticOperation.addition:
        return '+';
      case ArithmeticOperation.subtraction:
        return '−';
      case ArithmeticOperation.multiplication:
        return '×';
      case ArithmeticOperation.division:
        return '÷';
    }
  }

  /// Generate counting visualization (emoji repetition)
  static String generateCountVisual(int count, String emoji) {
    return List.generate(count, (_) => emoji).join('');
  }

  /// Format coins display
  static String formatCoins(int coins) {
    if (coins >= 1000000) {
      return '${(coins / 1000000).toStringAsFixed(1)}M';
    } else if (coins >= 1000) {
      return '${(coins / 1000).toStringAsFixed(1)}K';
    }
    return coins.toString();
  }

  /// Get praise message based on correct answers
  static String getPraiseMessage(int correctCount, int totalQuestions) {
    final percentage = (correctCount / totalQuestions * 100).toInt();

    if (percentage == 100) {
      return 'Perfect! You are a superstar! 🌟';
    } else if (percentage >= 80) {
      return 'Excellent work! You did great! 🎉';
    } else if (percentage >= 60) {
      return 'Good job! Keep practicing! 👏';
    } else if (percentage >= 40) {
      return 'Nice effort! You can do better! 💪';
    } else {
      return 'Keep trying! You are improving! 🌈';
    }
  }

  /// Get emoji based on percentage
  static String getEmojiByPercentage(int percentage) {
    if (percentage >= 90) return '🤩';
    if (percentage >= 80) return '😊';
    if (percentage >= 70) return '❤️';
    if (percentage >= 60) return '👍';
    if (percentage >= 50) return '😌';
    return '💪';
  }
}
