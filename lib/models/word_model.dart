/// Model for Word Pronunciation Game Questions
// Parses word pronunciation questions from JSON data.
class WordQuestion {
  final String id;
  final String word;
  final String pronunciation;
  final String sentence;
  final String sentencePronunciation;
  final String imagePath;

  WordQuestion({
    required this.id,
    required this.word,
    required this.pronunciation,
    required this.sentence,
    required this.sentencePronunciation,
    required this.imagePath,
  });

  /// Factory constructor to create from JSON
  factory WordQuestion.fromJson(Map<String, dynamic> json) {
    return WordQuestion(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      pronunciation: json['pronunciation'] as String? ?? '',
      sentence: json['sentence'] as String? ?? '',
      sentencePronunciation: json['sentencePronunciation'] as String? ?? '',
      imagePath: json['image'] as String? ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'pronunciation': pronunciation,
      'sentence': sentence,
      'sentencePronunciation': sentencePronunciation,
      'image': imagePath,
    };
  }
}
