import 'package:flutter/material.dart';

/// Centralized service to manage call screen visibility state.
class CallOverlayService {
  static final CallOverlayService _instance = CallOverlayService._();
  factory CallOverlayService() => _instance;
  CallOverlayService._();

  /// Whether the full-screen call screen is currently showing.
  final ValueNotifier<bool> isCallScreenVisible = ValueNotifier<bool>(false);

  /// Track how many call screens are on the stack.
  int _callScreenCount = 0;

  void onCallScreenOpened() {
    _callScreenCount++;
    isCallScreenVisible.value = true;
  }

  void onCallScreenClosed() {
    _callScreenCount = (_callScreenCount - 1).clamp(0, 999);
    isCallScreenVisible.value = _callScreenCount > 0;
  }
}

final callOverlay = CallOverlayService();
