import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  final AudioPlayer _movingPlayer = AudioPlayer();
  bool _isMovingSoundPlaying = false;

  Future<void> init() async {
    await _movingPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> startMovingSound() async {
    if (!_isMovingSoundPlaying) {
      try {
        await _movingPlayer.play(AssetSource('sounds/elevator_sound.m4a'));
        _isMovingSoundPlaying = true;
      } catch (e) {
        debugPrint('Audio Error: $e');
      }
    }
  }

  void stopMovingSound() {
    if (_isMovingSoundPlaying) {
      _movingPlayer.stop();
      _isMovingSoundPlaying = false;
    }
  }

  void dispose() => _movingPlayer.dispose();
}