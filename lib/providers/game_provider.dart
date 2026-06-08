import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eduvillage/utils/constants.dart';
import 'package:eduvillage/services/audio_service.dart';
import 'package:eduvillage/services/tts_service.dart';

/// Provider for managing game state
class GameProvider extends ChangeNotifier {
  static const String _musicVolumeKey = 'music_volume';
  static const String _musicMutedKey = 'music_muted';

  final AudioService _audioService = AudioService();
  final TTSService _ttsService = TTSService();

  GameStatus _gameStatus = GameStatus.idle;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _totalQuestions = AppConstants.totalQuestionsPerGame;
  String? _selectedAnswer;
  bool _isAnswered = false;
  String? _rewardMessage;
  int _coinsEarned = 0;
  double _musicVolume = 0.35;
  bool _isMusicMuted = false;

  // Getters
  GameStatus get gameStatus => _gameStatus;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get correctAnswers => _correctAnswers;
  int get totalQuestions => _totalQuestions;
  String? get selectedAnswer => _selectedAnswer;
  bool get isAnswered => _isAnswered;
  String? get rewardMessage => _rewardMessage;
  int get coinsEarned => _coinsEarned;
  double get musicVolume => _musicVolume;
  bool get isMusicMuted => _isMusicMuted;

  /// Initialize game provider
  Future<void> initializeGame() async {
    await _audioService.initialize();
    await _ttsService.initialize();
    await _loadMusicPreferences();
    await _audioService.playMainBackgroundMusic();
  }

  Future<void> _loadMusicPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _musicVolume = prefs.getDouble(_musicVolumeKey) ?? 0.35;
    _isMusicMuted = prefs.getBool(_musicMutedKey) ?? false;

    await _audioService.setMusicVolume(_musicVolume);
    await _audioService.setMusicEnabled(!_isMusicMuted);
  }

  Future<void> _saveMusicPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_musicVolumeKey, _musicVolume);
    await prefs.setBool(_musicMutedKey, _isMusicMuted);
  }

  /// Start game
  void startGame() {
    _gameStatus = GameStatus.inProgress;
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _rewardMessage = null;
    _coinsEarned = 0;
    notifyListeners();
  }

  /// Select answer
  Future<void> selectAnswer(String answer) async {
    _selectedAnswer = answer;
    _isAnswered = true;
    _gameStatus = GameStatus.answered;
    notifyListeners();
  }

  /// Check answer and move to next
  Future<bool> checkAnswerAndNext(
    String correctAnswer, {
    VoidCallback? onCorrect,
    VoidCallback? onWrong,
  }) async {
    final isCorrect =
        _selectedAnswer?.toLowerCase() == correctAnswer.toLowerCase();

    if (isCorrect) {
      _correctAnswers++;
      _coinsEarned += AppConstants.coinsPerCorrectAnswer;
      await _audioService.playCorrectSound();
      onCorrect?.call();
    } else {
      await _audioService.playWrongSound();
      onWrong?.call();
    }

    // Move to next question
    _currentQuestionIndex++;

    if (_currentQuestionIndex >= _totalQuestions) {
      _gameStatus = GameStatus.completed;
      _coinsEarned += AppConstants.coinsPerRoundCompletion;
    } else {
      _gameStatus = GameStatus.inProgress;
      _selectedAnswer = null;
      _isAnswered = false;
    }

    notifyListeners();
    return isCorrect;
  }

  /// Check counting answer
  Future<bool> checkCountingAnswer(
    int userAnswer,
    int correctAnswer, {
    VoidCallback? onCorrect,
    VoidCallback? onWrong,
  }) async {
    final isCorrect = userAnswer == correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
      _coinsEarned += AppConstants.coinsPerCorrectAnswer;
      await _audioService.playCorrectSound();
      onCorrect?.call();
    } else {
      await _audioService.playWrongSound();
      onWrong?.call();
    }

    // Move to next question
    _currentQuestionIndex++;

    if (_currentQuestionIndex >= _totalQuestions) {
      _gameStatus = GameStatus.completed;
      _coinsEarned += AppConstants.coinsPerRoundCompletion;
    } else {
      _gameStatus = GameStatus.inProgress;
      _selectedAnswer = null;
      _isAnswered = false;
    }

    notifyListeners();
    return isCorrect;
  }

  /// Speak text using TTS
  Future<void> speak(String text) async {
    await _ttsService.speak(text);
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await _ttsService.stop();
  }

  /// Play sound effect
  Future<void> playSound(String soundPath) async {
    await _audioService.playSound(soundPath);
  }

  /// Play correct sound
  Future<void> playCorrectSound() async {
    await _audioService.playCorrectSound();
  }

  /// Play wrong sound
  Future<void> playWrongSound() async {
    await _audioService.playWrongSound();
  }

  /// Play coin sound
  Future<void> playCoinSound() async {
    await _audioService.playCoinSound();
  }

  /// Start the default nursery rhyme playlist.
  Future<void> playMainBackgroundMusic() async {
    await _audioService.playMainBackgroundMusic();
  }

  /// Start the counting playlist.
  Future<void> playCountingBackgroundMusic() async {
    await _audioService.playCountingBackgroundMusic();
  }

  /// Stop background music playback.
  Future<void> stopBackgroundMusic() async {
    await _audioService.stopBackgroundMusic();
  }

  /// Set music volume without affecting text-to-speech pronunciation.
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);

    if (_musicVolume > 0 && _isMusicMuted) {
      _isMusicMuted = false;
      await _audioService.setMusicEnabled(true);
    }

    await _audioService.setMusicVolume(_musicVolume);
    await _saveMusicPreferences();
    notifyListeners();
  }

  /// Mute or unmute only background music.
  Future<void> setMusicMuted(bool muted) async {
    _isMusicMuted = muted;
    await _audioService.setMusicEnabled(!muted);
    await _saveMusicPreferences();
    notifyListeners();
  }

  /// Reset game
  void resetGame() {
    _gameStatus = GameStatus.idle;
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _rewardMessage = null;
    _coinsEarned = 0;
    notifyListeners();
  }

  /// Dispose resources
  @override
  void dispose() {
    _audioService.dispose();
    _ttsService.dispose();
    super.dispose();
  }
}
