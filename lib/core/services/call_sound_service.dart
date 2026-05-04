import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages ringtone and dial tone for video calls using local MP3 assets.
class CallSoundService {
  AudioPlayer? _player;
  StreamSubscription? _stateSubscription;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playDialTone() async {
    await stop();
    try {
      _player = AudioPlayer();
      _stateSubscription = _player!.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
      });
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.setVolume(0.7);
      await _player!.play(AssetSource('audio/dial_tone.mp3'));
      _isPlaying = true;
      debugPrint('CallSoundService: dial tone started');
    } catch (e) {
      debugPrint('CallSoundService.playDialTone error: $e');
      _isPlaying = false;
    }
  }

  Future<void> playRingtone() async {
    await stop();
    try {
      _player = AudioPlayer();
      _stateSubscription = _player!.onPlayerStateChanged.listen((state) {
        _isPlaying = state == PlayerState.playing;
      });
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.setVolume(1.0);
      await _player!.play(AssetSource('audio/ringtone.mp3'));
      _isPlaying = true;
      debugPrint('CallSoundService: ringtone started');
    } catch (e) {
      debugPrint('CallSoundService.playRingtone error: $e');
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _isPlaying = false;
    final player = _player;
    _player = null;
    if (player == null) return;
    try {
      await player.stop();
      await player.dispose();
    } catch (e) {
      debugPrint('CallSoundService.stop error: $e');
    }
  }
}

final callSoundServiceProvider = Provider<CallSoundService>((ref) {
  final service = CallSoundService();
  ref.onDispose(() => service.stop());
  return service;
});
