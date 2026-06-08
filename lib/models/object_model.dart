/// Model for Object Recognition Game Questions
class ObjectQuestion {
  final String id;
  final String imagePath;
  final String correctAnswer;
  final List<String> options;
  final String pronunciation;

  ObjectQuestion({
    required this.id,
    required this.imagePath,
    required this.correctAnswer,
    required this.options,
    required this.pronunciation,
  });

  /// Factory constructor to create from JSON
  factory ObjectQuestion.fromJson(Map<String, dynamic> json) {
    return ObjectQuestion(
      id: json['id'] as String? ?? '',
      imagePath: json['image'] as String? ?? '',
      correctAnswer: json['answer'] as String? ?? '',
      options: List<String>.from(json['options'] as List? ?? []),
      pronunciation: json['pronunciation'] as String? ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imagePath,
      'answer': correctAnswer,
      'options': options,
      'pronunciation': pronunciation,
    };
  }

  /// Check if answer is correct
  bool isCorrect(String answer) {
    return answer.toLowerCase() == correctAnswer.toLowerCase();
  }
}
