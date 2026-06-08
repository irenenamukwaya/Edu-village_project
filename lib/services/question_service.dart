import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:eduvillage/models/activity_model.dart';
import 'package:eduvillage/models/object_model.dart';
import 'package:eduvillage/models/word_model.dart';
import 'package:eduvillage/utils/helpers.dart';

/// Service for loading and managing game questions
// Loads question assets and converts them into models.
class QuestionService {
  static const String _objectAssetPrefix = 'assets/images/objects/';
  static const String _nestedObjectAssetPrefix =
      'assets/images/objects/objects/';

  /// Load activity questions from JSON
  static Future<List<ActivityQuestion>> loadActivityQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/activities.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      final questions = jsonData
          .map((q) => ActivityQuestion.fromJson(q as Map<String, dynamic>))
          .toList();

      return questions;
    } catch (e) {
      print('Error loading activity questions: $e');
      return _getMockActivityQuestions();
    }
  }

  /// Load object questions from JSON
  static Future<List<ObjectQuestion>> loadObjectQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/objects.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      final questions = jsonData
          .map(
            (q) => _normalizeObjectQuestion(
              ObjectQuestion.fromJson(q as Map<String, dynamic>),
            ),
          )
          .toList();

      return questions;
    } catch (e) {
      print('Error loading object questions: $e');
      return _getMockObjectQuestions();
    }
  }

  /// Load word questions from JSON
  static Future<List<WordQuestion>> loadWordQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/words.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      final questions = jsonData
          .map((q) => WordQuestion.fromJson(q as Map<String, dynamic>))
          .toList();

      return questions;
    } catch (e) {
      print('Error loading word questions: $e');
      return _getMockWordQuestions();
    }
  }

  /// Get random questions for a game
  static List<T> getRandomQuestions<T>(List<T> allQuestions, int count) {
    if (allQuestions.isEmpty) return [];
    if (allQuestions.length <= count) return allQuestions;

    return AppHelpers.getRandomItems(allQuestions, count);
  }

  /// Shuffle options in a question
  static List<String> shuffleOptions(List<String> options) {
    return AppHelpers.shuffleList(options);
  }

  /// Get mock activity questions (fallback)
  static List<ActivityQuestion> _getMockActivityQuestions() {
    return [
      ActivityQuestion(
        id: '1',
        imagePath: 'assets/images/activities/sweeping.png',
        correctAnswer: 'Sweeping',
        options: ['Playing', 'Sweeping', 'Sleeping', 'Eating'],
        description: 'A person is sweeping the floor',
      ),
      ActivityQuestion(
        id: '2',
        imagePath: 'assets/images/activities/reading.png',
        correctAnswer: 'Reading',
        options: ['Writing', 'Reading', 'Drawing', 'Singing'],
        description: 'A person is reading a book',
      ),
      ActivityQuestion(
        id: '3',
        imagePath: 'assets/images/activities/writing.png',
        correctAnswer: 'Writing',
        options: ['Reading', 'Writing', 'Painting', 'Cooking'],
        description: 'A person is writing on paper',
      ),
      ActivityQuestion(
        id: '4',
        imagePath: 'assets/images/activities/sleeping.png',
        correctAnswer: 'Sleeping',
        options: ['Eating', 'Sleeping', 'Running', 'Jumping'],
        description: 'A person is sleeping in bed',
      ),
      ActivityQuestion(
        id: '5',
        imagePath: 'assets/images/activities/eating.png',
        correctAnswer: 'Eating',
        options: ['Sleeping', 'Eating', 'Drinking', 'Cooking'],
        description: 'A person is eating food',
      ),
    ];
  }

  /// Get mock object questions (fallback)
  static List<ObjectQuestion> _getMockObjectQuestions() {
    return [
      ObjectQuestion(
        id: '1',
        imagePath: 'assets/images/objects/objects/bell.png',
        correctAnswer: 'Bell',
        options: ['Bell', 'Book', 'Cup', 'Chair'],
        pronunciation: 'Bell',
      ),
      ObjectQuestion(
        id: '2',
        imagePath: 'assets/images/objects/objects/bird.png',
        correctAnswer: 'Bird',
        options: ['Bird', 'Duck', 'Goat', 'Rabbit'],
        pronunciation: 'Bird',
      ),
      ObjectQuestion(
        id: '3',
        imagePath: 'assets/images/objects/objects/book.png',
        correctAnswer: 'Book',
        options: ['Pen', 'Book', 'Pencil', 'Blackboard'],
        pronunciation: 'Book',
      ),
      ObjectQuestion(
        id: '4',
        imagePath: 'assets/images/objects/objects/broom.png',
        correctAnswer: 'Broom',
        options: ['Broom', 'Bench', 'Bell', 'Table'],
        pronunciation: 'Broom',
      ),
      ObjectQuestion(
        id: '5',
        imagePath: 'assets/images/objects/objects/cat.png',
        correctAnswer: 'Cat',
        options: ['Cat', 'Dog', 'Cow', 'Pig'],
        pronunciation: 'Cat',
      ),
    ];
  }

  static ObjectQuestion _normalizeObjectQuestion(ObjectQuestion question) {
    final normalizedImagePath = _normalizeObjectImagePath(question.imagePath);

    if (normalizedImagePath == question.imagePath) {
      return question;
    }

    return ObjectQuestion(
      id: question.id,
      imagePath: normalizedImagePath,
      correctAnswer: question.correctAnswer,
      options: question.options,
      pronunciation: question.pronunciation,
    );
  }

  static String _normalizeObjectImagePath(String imagePath) {
    if (!imagePath.startsWith(_objectAssetPrefix) ||
        imagePath.startsWith(_nestedObjectAssetPrefix)) {
      return imagePath;
    }

    final fileName = imagePath.substring(_objectAssetPrefix.length);
    return '$_nestedObjectAssetPrefix$fileName';
  }

  /// Get mock word questions (fallback)
  static List<WordQuestion> _getMockWordQuestions() {
    return [
      WordQuestion(
        id: '1',
        word: 'Ball',
        pronunciation: 'ball',
        sentence: 'The ball is round.',
        sentencePronunciation: 'The ball is round',
        imagePath: 'assets/images/objects/ball.png',
      ),
      WordQuestion(
        id: '2',
        word: 'Book',
        pronunciation: 'book',
        sentence: 'The book is for reading.',
        sentencePronunciation: 'The book is for reading',
        imagePath: 'assets/images/objects/book.jfif',
      ),
      WordQuestion(
        id: '3',
        word: 'Broom',
        pronunciation: 'broom',
        sentence: 'The broom helps us clean.',
        sentencePronunciation: 'The broom helps us clean',
        imagePath: 'assets/images/objects/broom.jfif',
      ),
      WordQuestion(
        id: '4',
        word: 'Water',
        pronunciation: 'water',
        sentence: 'Water is used for bathing.',
        sentencePronunciation: 'Water is used for bathing',
        imagePath: 'assets/images/objects/water.jfif',
      ),
      WordQuestion(
        id: '5',
        word: 'Food',
        pronunciation: 'food',
        sentence: 'Food gives us energy.',
        sentencePronunciation: 'Food gives us energy',
        imagePath: 'assets/images/objects/food.jfif',
      ),
    ];
  }
}
