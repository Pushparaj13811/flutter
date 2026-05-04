import 'package:flutter/material.dart';

/// Centralized service to manage call screen visibility and navigation.
class CallOverlayService {
  static final CallOverlayService _instance = CallOverlayService._();
  factory CallOverlayService() => _instance;
  CallOverlayService._();

  /// Whether the full-screen call screen is currently showing.
  final ValueNotifier<bool> isCallScreenVisible = ValueNotifier<bool>(false);

  /// A context from inside the app widget tree for navigation.
  BuildContext? _navContext;

  /// Track how many call screens are on the stack.
  int _callScreenCount = 0;

  /// Set the navigation context (called from the app builder).
  void setContext(BuildContext context) {
    _navContext = context;
  }

  void onCallScreenOpened() {
    _callScreenCount++;
    isCallScreenVisible.value = true;
  }

  void onCallScreenClosed() {
    _callScreenCount = (_callScreenCount - 1).clamp(0, 999);
    isCallScreenVisible.value = _callScreenCount > 0;
  }

  /// Navigate to call screen.
  void openCallScreen(Widget screen) {
    if (isCallScreenVisible.value) return; // Already showing
    final ctx = _navContext;
    if (ctx == null) return;
    try {
      Navigator.of(ctx, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => screen),
      );
    } catch (_) {
      // Context may be stale
    }
  }
}

final callOverlay = CallOverlayService();
