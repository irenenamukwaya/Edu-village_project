import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:eduvillage/utils/constants.dart';

/// Service for managing audio and sound effects
// Controls background music and sound effects.
class AudioService {
  static const List<String> _mainBackgroundTracks = [
    'sounds/audio/old_macdonald.mp3',
    'sounds/audio/five_currant_buns.mp3',
    'sounds/audio/humpty_dumpty.mp3',
    'sounds/audio/this_old_man.mp3',
    'sounds/audio/london_bridge.mp3',
  ];

  static const List<String> _countingBackgroundTracks = [
    'sounds/audio/counting_cocomelon.mp3',
  ];

  late final AudioPlayer _effectsPlayer;
  late final AudioPlayer _backgroundPlayer;
  bool _effectsEnabled = AppConstants.soundEnabled;
  bool _musicEnabled = true;
  double _musicVolume = 0.35;
  List<String> _activeBackgroundTracks = const [];
  int _currentBackgroundTrackIndex = 0;
  StreamSubscription<void>? _backgroundTrackSubscription;

  AudioService() {
    _effectsPlayer = AudioPlayer();
    _backgroundPlayer = AudioPlayer();
  }

  /// Initialize the service
  Future<void> initialize() async {
    await _effectsPlayer.setReleaseMode(ReleaseMode.release);
    await _effectsPlayer.setVolume(AppConstants.soundVolume);

    await _backgroundPlayer.setReleaseMode(ReleaseMode.release);
    await _backgroundPlayer.setVolume(_musicVolume);

    _backgroundTrackSubscription ??= _backgroundPlayer.onPlayerComplete.listen((
      _,
    ) {
      _playNextBackgroundTrack();
    });
  }

  /// Play sound effect
  Future<void> playSound(String soundPath) async {
    if (!_effectsEnabled) return;

    try {
      await _effectsPlayer.play(AssetSource(soundPath));
    } catch (e) {
      // Silently fail if sound cannot be played
      print('Error playing sound: $e');
    }
  }

  /// Play the default nursery rhyme background playlist.
  Future<void> playMainBackgroundMusic() async {
    await playBackgroundPlaylist(_mainBackgroundTracks);
  }

  /// Play the counting background playlist.
  Future<void> playCountingBackgroundMusic() async {
    await playBackgroundPlaylist(_countingBackgroundTracks);
  }

  /// Play a background music playlist and loop through the tracks.
  Future<void> playBackgroundPlaylist(List<String> tracks) async {
    if (!_musicEnabled || tracks.isEmpty) return;

    final isSamePlaylist =
        _activeBackgroundTracks.length == tracks.length &&
        _activeBackgroundTracks.asMap().entries.every(
          (entry) => entry.value == tracks[entry.key],
        );

    if (isSamePlaylist && _backgroundPlayer.state == PlayerState.playing) {
      return;
    }

    _activeBackgroundTracks = List<String>.from(tracks);
    _currentBackgroundTrackIndex = 0;
    await _playBackgroundTrack();
  }

  Future<void> _playNextBackgroundTrack() async {
    if (_activeBackgroundTracks.isEmpty || !_musicEnabled) return;

    _currentBackgroundTrackIndex =
        (_currentBackgroundTrackIndex + 1) % _activeBackgroundTracks.length;
    await _playBackgroundTrack();
  }

  Future<void> _playBackgroundTrack() async {
    if (_activeBackgroundTracks.isEmpty || !_musicEnabled) return;

    try {
      await _backgroundPlayer.stop();
      await _backgroundPlayer.play(
        AssetSource(_activeBackgroundTracks[_currentBackgroundTrackIndex]),
      );
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  /// Play correct answer sound
  Future<void> playCorrectSound() async {
    await _playEffectWithFallback('sounds/correct.mp3');
  }

  /// Play wrong answer sound
  Future<void> playWrongSound() async {
    await _playEffectWithFallback('sounds/wrong.mp3');
  }

  /// Play coin collected sound
  Future<void> playCoinSound() async {
    await _playEffectWithFallback('sounds/coin.mp3');
  }

  Future<void> _playEffectWithFallback(String soundPath) async {
    if (!_effectsEnabled) return;

    try {
      await _effectsPlayer.play(AssetSource(soundPath));
    } catch (_) {
      // Keep game feedback audible even when dedicated effect assets are missing.
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Toggle sound on/off
  void toggleSound() {
    _effectsEnabled = !_effectsEnabled;
  }

  /// Set effects enabled state
  void setSoundEnabled(bool enabled) {
    _effectsEnabled = enabled;
  }

  /// Check if effects are enabled
  bool isSoundEnabled() {
    return _effectsEnabled;
  }

  /// Set background music enabled state.
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    if (_musicEnabled) {
      await _playBackgroundTrack();
    } else {
      await _backgroundPlayer.stop();
    }
  }

  /// Set background music volume.
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await _backgroundPlayer.setVolume(_musicVolume);
  }

  double getMusicVolume() {
    return _musicVolume;
  }

  bool isMusicEnabled() {
    return _musicEnabled;
  }

  /// Stop current audio
  Future<void> stop() async {
    await _effectsPlayer.stop();
  }

  /// Stop background music without clearing the selected playlist.
  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  /// Release resources
  Future<void> dispose() async {
    await _backgroundTrackSubscription?.cancel();
    await _effectsPlayer.dispose();
    await _backgroundPlayer.dispose();
  }
}
