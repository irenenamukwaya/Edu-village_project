import 'package:flutter_tts/flutter_tts.dart';

/// Service for Text-to-Speech functionality
// Configures text-to-speech for pronunciation playback.
class TTSService {
  late FlutterTts _flutterTts;
  bool _isInitialized = false;

  TTSService() {
    _flutterTts = FlutterTts();
  }

  /// Initialize TTS
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Set language to English
      await _flutterTts.setLanguage("en-US");

      // Set pitch and speech rate
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      _isInitialized = true;
    } catch (e) {
      print('Error initializing TTS: $e');
    }
  }

  /// Speak text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('Error stopping TTS: $e');
    }
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    try {
      await _flutterTts.setLanguage(language);
    } catch (e) {
      print('Error setting language: $e');
    }
  }

  /// Set pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      print('Error setting pitch: $e');
    }
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      print('Error setting speech rate: $e');
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print('Error disposing TTS: $e');
    }
  }
}
