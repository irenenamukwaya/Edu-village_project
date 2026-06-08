import 'package:eduvillage/utils/constants.dart';

/// Model for Math Game Numbers (Learning Mode)
// Parses number learning and math question data from JSON.
class NumberLearning {
  final int number;
  final String word;
  final String imagePath;

  NumberLearning({
    required this.number,
    required this.word,
    required this.imagePath,
  });

  factory NumberLearning.fromJson(Map<String, dynamic> json) {
    return NumberLearning(
      number: json['number'] as int? ?? 0,
      word: json['word'] as String? ?? '',
      imagePath: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'number': number, 'word': word, 'image': imagePath};
  }
}

/// Model for Counting Game Questions
class CountingQuestion {
  final String id;
  final int count;
  final String object;
  final String objectEmoji;
  final List<int> options;

  CountingQuestion({
    required this.id,
    required this.count,
    required this.object,
    required this.objectEmoji,
    required this.options,
  });

  factory CountingQuestion.fromJson(Map<String, dynamic> json) {
    return CountingQuestion(
      id: json['id'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      object: json['object'] as String? ?? '',
      objectEmoji: json['emoji'] as String? ?? '🟢',
      options: List<int>.from(json['options'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'count': count,
      'object': object,
      'emoji': objectEmoji,
      'options': options,
    };
  }

  bool isCorrect(int answer) {
    return answer == count;
  }
}

/// Model for Arithmetic Questions
class ArithmeticQuestion {
  final String id;
  final int firstNumber;
  final int secondNumber;
  final ArithmeticOperation operation;
  final List<int> options;

  ArithmeticQuestion({
    required this.id,
    required this.firstNumber,
    required this.secondNumber,
    required this.operation,
    required this.options,
  });

  /// Calculate correct answer
  int getCorrectAnswer() {
    switch (operation) {
      case ArithmeticOperation.addition:
        return firstNumber + secondNumber;
      case ArithmeticOperation.subtraction:
        return firstNumber - secondNumber;
      case ArithmeticOperation.multiplication:
        return firstNumber * secondNumber;
      case ArithmeticOperation.division:
        return (firstNumber / secondNumber).toInt();
    }
  }

  /// Check if answer is correct
  bool isCorrect(int answer) {
    return answer == getCorrectAnswer();
  }

  /// Get operation text
  String getOperationText() {
    switch (operation) {
      case ArithmeticOperation.addition:
        return 'addition';
      case ArithmeticOperation.subtraction:
        return 'subtraction';
      case ArithmeticOperation.multiplication:
        return 'multiplication';
      case ArithmeticOperation.division:
        return 'division';
    }
  }

  factory ArithmeticQuestion.fromJson(Map<String, dynamic> json) {
    return ArithmeticQuestion(
      id: json['id'] as String? ?? '',
      firstNumber: json['first'] as int? ?? 0,
      secondNumber: json['second'] as int? ?? 0,
      operation: ArithmeticOperation.values.byName(
        json['operation'] as String? ?? 'addition',
      ),
      options: List<int>.from(json['options'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first': firstNumber,
      'second': secondNumber,
      'operation': operation.name,
      'options': options,
    };
  }
}
