import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages ringtone and dial tone for video calls.
///
/// - **Outgoing call (dialing)**: plays a repeating "ring-back" tone
/// - **Incoming call (ringing)**: plays a repeating ringtone
class CallSoundService {
  AudioPlayer? _player;

  // Free, royalty-free tones hosted publicly
  // Outgoing: classic phone ring-back tone
  static const _dialToneUrl =
      'https://www.soundjay.com/phone/phone-calling-1.mp3';
  // Incoming: classic ringtone
  static const _ringToneUrl =
      'https://www.soundjay.com/phone/phone-ring-6.mp3';

  Future<void> playDialTone() async {
    await stop();
    try {
      _player = AudioPlayer();
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.setVolume(0.5);
      await _player!.play(UrlSource(_dialToneUrl));
    } catch (e) {
      debugPrint('CallSoundService.playDialTone error: $e');
    }
  }

  Future<void> playRingtone() async {
    await stop();
    try {
      _player = AudioPlayer();
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.setVolume(0.8);
      await _player!.play(UrlSource(_ringToneUrl));
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
