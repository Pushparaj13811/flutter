import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();

  static String get fontFamily => GoogleFonts.urbanist().fontFamily!;

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
  }) {
    return GoogleFonts.urbanist(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }

  // Headings
  static final TextStyle h1 = _base(fontSize: 30, fontWeight: FontWeight.w700, height: 1.2);
  static final TextStyle h2 = _base(fontSize: 24, fontWeight: FontWeight.w600, height: 1.25);
  static final TextStyle h3 = _base(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  static final TextStyle h4 = _base(fontSize: 18, fontWeight: FontWeight.w600, height: 1.35);

  // Body
  static final TextStyle bodyLarge = _base(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static final TextStyle bodyMedium = _base(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static final TextStyle bodySmall = _base(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);

  // Labels
  static final TextStyle labelLarge = _base(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4);
  static final TextStyle labelMedium = _base(fontSize: 12, fontWeight: FontWeight.w500, height: 1.4);
  static final TextStyle labelSmall = _base(fontSize: 11, fontWeight: FontWeight.w500, height: 1.4);

  // Caption
  static final TextStyle caption = _base(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
}
