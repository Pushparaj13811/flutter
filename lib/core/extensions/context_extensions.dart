import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // Media
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  // Breakpoints
  bool get isCompact => screenWidth < 600;
  bool get isMedium => screenWidth >= 600 && screenWidth < 840;
  bool get isExpanded => screenWidth >= 840;

  // Navigation
  NavigatorState get navigator => Navigator.of(this);

  // Scaffold
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  void showSnackBar(String message, {bool isError = false}) {
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showErrorSnackBar(String message) => showSnackBar(message, isError: true);
}
