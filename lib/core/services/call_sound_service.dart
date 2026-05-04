import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages ringtone and dial tone for video calls using local assets.
class CallSoundService {
  AudioPlayer? _player;

  Future<void> playDialTone() async {
    await stop();
    try {
      _player = AudioPlayer();
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.setVolume(0.6);
      await _player!.play(AssetSource('audio/dial_tone.wav'));
    } catch (e) {
      debugPrint('CallSoundService.playDialTone error: $e');
    }
  }

  Future<void> playRingtone() async {
    await stop();
    try {
      _player = AudioPlayer();
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.setVolume(0.9);
      await _player!.play(AssetSource('audio/ringtone.wav'));
    } catch (e) {
      debugPrint('CallSoundService.playRingtone error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player?.stop();
      await _player?.dispose();
      _player = null;
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
