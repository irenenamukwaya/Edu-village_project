/// Model for Activity Game Questions
// Parses activity questions from JSON data.
class ActivityQuestion {
  final String id;
  final String imagePath;
  final String correctAnswer;
  final List<String> options;
  final String description;

  ActivityQuestion({
    required this.id,
    required this.imagePath,
    required this.correctAnswer,
    required this.options,
    required this.description,
  });

  /// Factory constructor to create from JSON
  factory ActivityQuestion.fromJson(Map<String, dynamic> json) {
    return ActivityQuestion(
      id: json['id'] as String? ?? '',
      imagePath: json['image'] as String? ?? '',
      correctAnswer: json['answer'] as String? ?? '',
      options: List<String>.from(json['options'] as List? ?? []),
      description: json['description'] as String? ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imagePath,
      'answer': correctAnswer,
      'options': options,
      'description': description,
    };
  }

  /// Check if answer is correct
  bool isCorrect(String answer) {
    return answer.toLowerCase() == correctAnswer.toLowerCase();
  }
}
