import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x14000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> cardDark = [
    BoxShadow(color: Color(0x66000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x4D000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> glow = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 20, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> glowDark = [
    BoxShadow(color: Color(0x80000000), blurRadius: 20, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> sm = card;
  static const List<BoxShadow> md = card;
  static const List<BoxShadow> lg = glow;
}
