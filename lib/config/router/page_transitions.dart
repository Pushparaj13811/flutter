import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Fade transition for shell tab switches (200ms).
CustomTransitionPage<void> fadeTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

/// Slide-up + fade transition for detail screens (300ms).
CustomTransitionPage<void> slideUpTransitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: offsetTween.animate(animation),
          child: child,
        ),
      );
    },
  );
}
