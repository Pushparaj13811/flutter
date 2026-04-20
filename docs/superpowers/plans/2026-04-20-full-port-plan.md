# Full Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align the Flutter Skill Exchange app with the React frontend and Node.js backend for full feature parity — design tokens, API endpoints, models, providers, real-time messaging, and all feature screens.

**Architecture:** Clean architecture with domain/data/features layers. Riverpod for state, Dio for HTTP, go_router for navigation, Freezed for models, fpdart Either for error handling. Socket.IO for real-time messaging.

**Tech Stack:** Flutter 3.x, Riverpod 2.x, Dio 5.x, go_router 14.x, Freezed 2.x, fpdart 1.x, socket_io_client 3.x

---

## Sub-Project 1: Design Token Alignment

### Task 1: Fix app_colors.dart to match React theme

**Files:**
- Modify: `lib/core/theme/app_colors.dart`

- [ ] **Step 1: Replace all light mode colors**

```dart
import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // ── LIGHT MODE ──

  static const Color primary = Color(0xFF059669);
  static const Color primaryHover = Color(0xFF047857);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color primarySubtle = Color(0xFFD1FAE5);
  static const Color primaryMuted = Color(0xFF6EE7B7);

  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryHover = Color(0xFF7C3AED);
  static const Color secondaryForeground = Color(0xFFFFFFFF);
  static const Color secondarySubtle = Color(0xFFEDE9FE);

  static const Color background = Color(0xFFFAFAFA);
  static const Color foreground = Color(0xFF111827);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF111827);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF111827);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color surfaceForeground = Color(0xFF111827);

  static const Color accent = Color(0xFFF3F4F6);
  static const Color accentForeground = Color(0xFF111827);
  static const Color accentSubtle = Color(0xFFE5E7EB);

  static const Color highlight = Color(0xFFF59E0B);
  static const Color highlightForeground = Color(0xFFFFFFFF);
  static const Color highlightSubtle = Color(0xFFFEF3C7);

  static const Color muted = Color(0xFFF5F5F5);
  static const Color mutedForeground = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color input = Color(0x00000000); // transparent
  static const Color ring = Color(0xFF10B981);
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFEAB308);
  static const Color info = Color(0xFF059669);

  // Skill levels
  static const Color beginnerBg = Color(0xFFDCFCE7);
  static const Color beginnerText = Color(0xFF166534);
  static const Color intermediateBg = Color(0xFFDBEAFE);
  static const Color intermediateText = Color(0xFF1E40AF);
  static const Color advancedBg = Color(0xFFF3E8FF);
  static const Color advancedText = Color(0xFF6B21A8);
  static const Color expertBg = Color(0xFFFFEDD5);
  static const Color expertText = Color(0xFF9A3412);

  // Star rating
  static const Color starFilled = Color(0xFFFACC15);
  static const Color starEmpty = Color(0xFFD1D5DB);

  // Compatibility scores
  static const Color scoreExcellent = Color(0xFF16A34A);
  static const Color scoreGreat = Color(0xFF059669);
  static const Color scoreGood = Color(0xFFEAB308);
  static const Color scoreFair = Color(0xFF6B7280);

  // ── DARK MODE ──

  static const Color darkPrimary = Color(0xFF10B981);
  static const Color darkPrimaryHover = Color(0xFF059669);
  static const Color darkPrimaryForeground = Color(0xFFFFFFFF);
  static const Color darkPrimarySubtle = Color(0xFF064E3B);
  static const Color darkPrimaryMuted = Color(0xFF065F46);

  static const Color darkSecondary = Color(0xFF8B5CF6);
  static const Color darkSecondaryHover = Color(0xFF7C3AED);
  static const Color darkSecondaryForeground = Color(0xFFFFFFFF);
  static const Color darkSecondarySubtle = Color(0xFF2E1065);

  static const Color darkBackground = Color(0xFF0F0F0F);
  static const Color darkForeground = Color(0xFFF9FAFB);
  static const Color darkCard = Color(0xFF1A1A1A);
  static const Color darkCardForeground = Color(0xFFF9FAFB);
  static const Color darkPopover = Color(0xFF1A1A1A);
  static const Color darkPopoverForeground = Color(0xFFF9FAFB);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkSurfaceForeground = Color(0xFFF9FAFB);

  static const Color darkAccent = Color(0xFF1F1F1F);
  static const Color darkAccentForeground = Color(0xFFF9FAFB);
  static const Color darkAccentSubtle = Color(0xFFFEF3C7);

  static const Color darkHighlight = Color(0xFFFBBF24);
  static const Color darkHighlightForeground = Color(0xFF0A0F0D);
  static const Color darkHighlightSubtle = Color(0xFF78350F);

  static const Color darkMuted = Color(0xFF141414);
  static const Color darkMutedForeground = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkInput = Color(0xFF1A1A1A);
  static const Color darkRing = Color(0xFF34D399);
  static const Color darkDestructive = Color(0xFFF87171);
  static const Color darkDestructiveForeground = Color(0xFF0A0F0D);
}
```

- [ ] **Step 2: Verify it compiles**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter analyze lib/core/theme/app_colors.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_colors.dart
git commit -m "fix: align app_colors.dart with React theme tokens"
```

---

### Task 2: Update AppColorsExtension with new tokens

**Files:**
- Modify: `lib/core/theme/app_colors_extension.dart`

- [ ] **Step 1: Add new color fields and update light/dark instances**

```dart
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.primaryHover,
    required this.primaryForeground,
    required this.primarySubtle,
    required this.primaryMuted,
    required this.secondary,
    required this.secondaryHover,
    required this.secondaryForeground,
    required this.secondarySubtle,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.surface,
    required this.surfaceForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.accentSubtle,
    required this.highlight,
    required this.highlightForeground,
    required this.highlightSubtle,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.success,
    required this.warning,
    required this.info,
    required this.beginnerBg,
    required this.beginnerText,
    required this.intermediateBg,
    required this.intermediateText,
    required this.advancedBg,
    required this.advancedText,
    required this.expertBg,
    required this.expertText,
    required this.starFilled,
    required this.starEmpty,
    required this.scoreExcellent,
    required this.scoreGreat,
    required this.scoreGood,
    required this.scoreFair,
  });

  final Color primary;
  final Color primaryHover;
  final Color primaryForeground;
  final Color primarySubtle;
  final Color primaryMuted;
  final Color secondary;
  final Color secondaryHover;
  final Color secondaryForeground;
  final Color secondarySubtle;
  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color surface;
  final Color surfaceForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color accentSubtle;
  final Color highlight;
  final Color highlightForeground;
  final Color highlightSubtle;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;
  final Color success;
  final Color warning;
  final Color info;
  final Color beginnerBg;
  final Color beginnerText;
  final Color intermediateBg;
  final Color intermediateText;
  final Color advancedBg;
  final Color advancedText;
  final Color expertBg;
  final Color expertText;
  final Color starFilled;
  final Color starEmpty;
  final Color scoreExcellent;
  final Color scoreGreat;
  final Color scoreGood;
  final Color scoreFair;

  static const light = AppColorsExtension(
    primary: AppColors.primary,
    primaryHover: AppColors.primaryHover,
    primaryForeground: AppColors.primaryForeground,
    primarySubtle: AppColors.primarySubtle,
    primaryMuted: AppColors.primaryMuted,
    secondary: AppColors.secondary,
    secondaryHover: AppColors.secondaryHover,
    secondaryForeground: AppColors.secondaryForeground,
    secondarySubtle: AppColors.secondarySubtle,
    background: AppColors.background,
    foreground: AppColors.foreground,
    card: AppColors.card,
    cardForeground: AppColors.cardForeground,
    popover: AppColors.popover,
    popoverForeground: AppColors.popoverForeground,
    surface: AppColors.surface,
    surfaceForeground: AppColors.surfaceForeground,
    muted: AppColors.muted,
    mutedForeground: AppColors.mutedForeground,
    accent: AppColors.accent,
    accentForeground: AppColors.accentForeground,
    accentSubtle: AppColors.accentSubtle,
    highlight: AppColors.highlight,
    highlightForeground: AppColors.highlightForeground,
    highlightSubtle: AppColors.highlightSubtle,
    destructive: AppColors.destructive,
    destructiveForeground: AppColors.destructiveForeground,
    border: AppColors.border,
    input: AppColors.input,
    ring: AppColors.ring,
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.info,
    beginnerBg: AppColors.beginnerBg,
    beginnerText: AppColors.beginnerText,
    intermediateBg: AppColors.intermediateBg,
    intermediateText: AppColors.intermediateText,
    advancedBg: AppColors.advancedBg,
    advancedText: AppColors.advancedText,
    expertBg: AppColors.expertBg,
    expertText: AppColors.expertText,
    starFilled: AppColors.starFilled,
    starEmpty: AppColors.starEmpty,
    scoreExcellent: AppColors.scoreExcellent,
    scoreGreat: AppColors.scoreGreat,
    scoreGood: AppColors.scoreGood,
    scoreFair: AppColors.scoreFair,
  );

  static const dark = AppColorsExtension(
    primary: AppColors.darkPrimary,
    primaryHover: AppColors.darkPrimaryHover,
    primaryForeground: AppColors.darkPrimaryForeground,
    primarySubtle: AppColors.darkPrimarySubtle,
    primaryMuted: AppColors.darkPrimaryMuted,
    secondary: AppColors.darkSecondary,
    secondaryHover: AppColors.darkSecondaryHover,
    secondaryForeground: AppColors.darkSecondaryForeground,
    secondarySubtle: AppColors.darkSecondarySubtle,
    background: AppColors.darkBackground,
    foreground: AppColors.darkForeground,
    card: AppColors.darkCard,
    cardForeground: AppColors.darkCardForeground,
    popover: AppColors.darkPopover,
    popoverForeground: AppColors.darkPopoverForeground,
    surface: AppColors.darkSurface,
    surfaceForeground: AppColors.darkSurfaceForeground,
    muted: AppColors.darkMuted,
    mutedForeground: AppColors.darkMutedForeground,
    accent: AppColors.darkAccent,
    accentForeground: AppColors.darkAccentForeground,
    accentSubtle: AppColors.darkAccentSubtle,
    highlight: AppColors.darkHighlight,
    highlightForeground: AppColors.darkHighlightForeground,
    highlightSubtle: AppColors.darkHighlightSubtle,
    destructive: AppColors.darkDestructive,
    destructiveForeground: AppColors.darkDestructiveForeground,
    border: AppColors.darkBorder,
    input: AppColors.darkInput,
    ring: AppColors.darkRing,
    success: AppColors.success,
    warning: AppColors.warning,
    info: AppColors.darkPrimary,
    beginnerBg: AppColors.beginnerBg,
    beginnerText: AppColors.beginnerText,
    intermediateBg: AppColors.intermediateBg,
    intermediateText: AppColors.intermediateText,
    advancedBg: AppColors.advancedBg,
    advancedText: AppColors.advancedText,
    expertBg: AppColors.expertBg,
    expertText: AppColors.expertText,
    starFilled: AppColors.starFilled,
    starEmpty: AppColors.starEmpty,
    scoreExcellent: AppColors.scoreExcellent,
    scoreGreat: AppColors.scoreGreat,
    scoreGood: AppColors.scoreGood,
    scoreFair: AppColors.scoreFair,
  );

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? primaryHover,
    Color? primaryForeground,
    Color? primarySubtle,
    Color? primaryMuted,
    Color? secondary,
    Color? secondaryHover,
    Color? secondaryForeground,
    Color? secondarySubtle,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? surface,
    Color? surfaceForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? accentSubtle,
    Color? highlight,
    Color? highlightForeground,
    Color? highlightSubtle,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? success,
    Color? warning,
    Color? info,
    Color? beginnerBg,
    Color? beginnerText,
    Color? intermediateBg,
    Color? intermediateText,
    Color? advancedBg,
    Color? advancedText,
    Color? expertBg,
    Color? expertText,
    Color? starFilled,
    Color? starEmpty,
    Color? scoreExcellent,
    Color? scoreGreat,
    Color? scoreGood,
    Color? scoreFair,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      secondary: secondary ?? this.secondary,
      secondaryHover: secondaryHover ?? this.secondaryHover,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      secondarySubtle: secondarySubtle ?? this.secondarySubtle,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      surface: surface ?? this.surface,
      surfaceForeground: surfaceForeground ?? this.surfaceForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      accentSubtle: accentSubtle ?? this.accentSubtle,
      highlight: highlight ?? this.highlight,
      highlightForeground: highlightForeground ?? this.highlightForeground,
      highlightSubtle: highlightSubtle ?? this.highlightSubtle,
      destructive: destructive ?? this.destructive,
      destructiveForeground: destructiveForeground ?? this.destructiveForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      beginnerBg: beginnerBg ?? this.beginnerBg,
      beginnerText: beginnerText ?? this.beginnerText,
      intermediateBg: intermediateBg ?? this.intermediateBg,
      intermediateText: intermediateText ?? this.intermediateText,
      advancedBg: advancedBg ?? this.advancedBg,
      advancedText: advancedText ?? this.advancedText,
      expertBg: expertBg ?? this.expertBg,
      expertText: expertText ?? this.expertText,
      starFilled: starFilled ?? this.starFilled,
      starEmpty: starEmpty ?? this.starEmpty,
      scoreExcellent: scoreExcellent ?? this.scoreExcellent,
      scoreGreat: scoreGreat ?? this.scoreGreat,
      scoreGood: scoreGood ?? this.scoreGood,
      scoreFair: scoreFair ?? this.scoreFair,
    );
  }

  @override
  AppColorsExtension lerp(AppColorsExtension? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryForeground: Color.lerp(primaryForeground, other.primaryForeground, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryHover: Color.lerp(secondaryHover, other.secondaryHover, t)!,
      secondaryForeground: Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      secondarySubtle: Color.lerp(secondarySubtle, other.secondarySubtle, t)!,
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      popover: Color.lerp(popover, other.popover, t)!,
      popoverForeground: Color.lerp(popoverForeground, other.popoverForeground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceForeground: Color.lerp(surfaceForeground, other.surfaceForeground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentForeground: Color.lerp(accentForeground, other.accentForeground, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      highlightForeground: Color.lerp(highlightForeground, other.highlightForeground, t)!,
      highlightSubtle: Color.lerp(highlightSubtle, other.highlightSubtle, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveForeground: Color.lerp(destructiveForeground, other.destructiveForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      ring: Color.lerp(ring, other.ring, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      beginnerBg: Color.lerp(beginnerBg, other.beginnerBg, t)!,
      beginnerText: Color.lerp(beginnerText, other.beginnerText, t)!,
      intermediateBg: Color.lerp(intermediateBg, other.intermediateBg, t)!,
      intermediateText: Color.lerp(intermediateText, other.intermediateText, t)!,
      advancedBg: Color.lerp(advancedBg, other.advancedBg, t)!,
      advancedText: Color.lerp(advancedText, other.advancedText, t)!,
      expertBg: Color.lerp(expertBg, other.expertBg, t)!,
      expertText: Color.lerp(expertText, other.expertText, t)!,
      starFilled: Color.lerp(starFilled, other.starFilled, t)!,
      starEmpty: Color.lerp(starEmpty, other.starEmpty, t)!,
      scoreExcellent: Color.lerp(scoreExcellent, other.scoreExcellent, t)!,
      scoreGreat: Color.lerp(scoreGreat, other.scoreGreat, t)!,
      scoreGood: Color.lerp(scoreGood, other.scoreGood, t)!,
      scoreFair: Color.lerp(scoreFair, other.scoreFair, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
```

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/core/theme/app_colors_extension.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_colors_extension.dart
git commit -m "fix: add new semantic color tokens to AppColorsExtension"
```

---

### Task 3: Fix app_radius.dart to match React

**Files:**
- Modify: `lib/core/theme/app_radius.dart`

- [ ] **Step 1: Update radius values**

```dart
class AppRadius {
  const AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double full = 9999.0;

  // Specific component radii
  static const double button = 12.0;
  static const double card = 12.0;
  static const double input = 12.0;
  static const double chip = 9999.0;
  static const double avatar = 9999.0;
  static const double sheet = 16.0;
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/theme/app_radius.dart
git commit -m "fix: align border radius values with React theme"
```

---

### Task 4: Update app_shadows.dart to match React CSS shadows

**Files:**
- Modify: `lib/core/theme/app_shadows.dart`

- [ ] **Step 1: Replace shadow definitions**

```dart
import 'package:flutter/material.dart';

class AppShadows {
  const AppShadows._();

  /// Matches React `.shadow-card` (light mode)
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A000000), // rgba(0,0,0,0.04)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Matches React `.shadow-card` (dark mode)
  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x66000000), // rgba(0,0,0,0.4)
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x4D000000), // rgba(0,0,0,0.3)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Matches React `.shadow-glow` (light mode)
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x1F000000), // rgba(0,0,0,0.12)
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  /// Matches React `.shadow-glow` (dark mode)
  static const List<BoxShadow> glowDark = [
    BoxShadow(
      color: Color(0x80000000), // rgba(0,0,0,0.5)
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];

  // Keep legacy names for backward compatibility
  static const List<BoxShadow> sm = card;
  static const List<BoxShadow> md = card;
  static const List<BoxShadow> lg = glow;
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/theme/app_shadows.dart
git commit -m "fix: align shadow definitions with React CSS"
```

---

### Task 5: Add AppGradients class

**Files:**
- Create: `lib/core/theme/app_gradients.dart`

- [ ] **Step 1: Create gradients file**

```dart
import 'package:flutter/material.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF047857)],
  );

  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  );

  static const LinearGradient hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0F0D), Color(0xFF0D2818), Color(0xFF1A0A2E)],
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient card = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );

  static const LinearGradient surfaceLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5F5F5), Color(0xFFFAFAFA)],
  );

  static const LinearGradient surfaceDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF141414), Color(0xFF0F0F0F)],
  );

  /// Use with ShaderMask for gradient text effect (emerald → violet)
  static const LinearGradient text = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF8B5CF6)],
  );
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/core/theme/app_gradients.dart
git commit -m "feat: add AppGradients matching React gradient utilities"
```

---

### Task 6: Update app_text_styles.dart with Urbanist font

**Files:**
- Modify: `lib/core/theme/app_text_styles.dart`
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add google_fonts dependency to pubspec.yaml**

Add under `dependencies:` section:

```yaml
  google_fonts: ^6.2.1
```

- [ ] **Step 2: Update app_text_styles.dart to use Urbanist**

```dart
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
```

- [ ] **Step 3: Run flutter pub get**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && flutter pub get`
Expected: Dependencies resolved successfully

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml lib/core/theme/app_text_styles.dart
git commit -m "feat: switch to Urbanist font via google_fonts"
```

---

### Task 7: Update app_theme.dart with corrected colors

**Files:**
- Modify: `lib/core/theme/app_theme.dart`

- [ ] **Step 1: Update ThemeData to use corrected AppColors**

The existing `app_theme.dart` references `AppColors.primary`, `AppColors.darkPrimary`, etc. Since we changed those values in Task 1, the theme file picks up the new colors automatically. However we need to update the `inputDecorationTheme` since `input` is now transparent — use `border` color for input borders instead.

In `lightTheme()`, change:
```dart
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.border),
          ),
```

In `darkTheme()`, change:
```dart
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.input),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
```

Also update the `filled` property in both themes to `true` for dark mode input with `fillColor: AppColors.darkInput`.

- [ ] **Step 2: Verify full app compiles**

Run: `flutter analyze lib/`
Expected: No errors (warnings are OK)

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_theme.dart
git commit -m "fix: update theme to use corrected input border colors"
```

---

## Sub-Project 2: API Endpoint Alignment

### Task 8: Fix api_endpoints.dart to match backend routes

**Files:**
- Modify: `lib/core/constants/api_endpoints.dart`

- [ ] **Step 1: Replace entire file with corrected endpoints**

```dart
class ApiEndpoints {
  ApiEndpoints._();
}

class Auth {
  const Auth._();

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String changePassword = '/auth/change-password';
  static const String changeEmail = '/auth/change-email';
  static const String google = '/auth/google';
  // Kept for backward compat — auth_remote_source uses this
  static const String signup = '/auth/register';
  static const String me = '/users/me';
}

class Users {
  const Users._();

  static const String me = '/users/me';
}

class Profiles {
  const Profiles._();

  static const String me = '/profiles/me';
  static const String list = '/profiles';
  static const String avatar = '/profiles/me/avatar';
  static const String cover = '/profiles/me/cover';
  static const String preferences = '/profiles/me/preferences';

  static String byId(String id) => '/profiles/$id';
  static String byUsername(String username) => '/profiles/by-username/$username';
  static String userPosts(String id) => '/profiles/$id/posts';
}

class Skills {
  const Skills._();

  static const String list = '/skills';
  static const String categories = '/skills/categories';
  static const String search = '/skills/search';
  static const String popular = '/skills/popular';

  static String byId(String id) => '/skills/$id';
}

class Matching {
  const Matching._();

  static const String suggestions = '/matching/suggestions';
}

class Connections {
  const Connections._();

  static const String list = '/connections';
  static const String request = '/connections/request';
  static const String pending = '/connections/pending';
  static const String sent = '/connections/sent';

  static String accept(String id) => '/connections/$id/accept';
  static String reject(String id) => '/connections/$id/reject';
  static String remove(String id) => '/connections/$id';
}

class Sessions {
  const Sessions._();

  static const String list = '/sessions';
  static const String book = '/sessions/book';
  static const String request = '/sessions/request';

  static String byId(String id) => '/sessions/$id';
  static String cancel(String id) => '/sessions/$id/cancel';
  static String complete(String id) => '/sessions/$id/complete';
  static String reschedule(String id) => '/sessions/$id/reschedule';
  static String availableSlots(String userId) => '/sessions/available-slots/$userId';
}

class Messages {
  const Messages._();

  static const String threads = '/messages/threads';
  static const String send = '/messages/send';
  static const String unreadCount = '/messages/unread-count';

  static String threadById(String threadId) => '/messages/threads/$threadId';
  static String markRead(String threadId) => '/messages/threads/$threadId/read';
}

class Reviews {
  const Reviews._();

  static const String create = '/reviews';

  static String forUser(String userId) => '/reviews/user/$userId';
  static String byUser(String userId) => '/reviews/by/$userId';
}

class Notifications {
  const Notifications._();

  static const String list = '/notifications';
  static const String unreadCount = '/notifications/unread-count';
  static const String readAll = '/notifications/read-all';

  static String markRead(String id) => '/notifications/$id/read';
  static String delete(String id) => '/notifications/$id';
}

class Search {
  const Search._();

  static const String users = '/search/users';
}

class Community {
  const Community._();

  static const String posts = '/community/posts';
  static const String circles = '/community/circles';
  static const String leaderboard = '/community/leaderboard';
  static const String uploadMedia = '/community/posts/upload-media';
  static const String uploadVideo = '/community/posts/upload-video';

  static String postById(String id) => '/community/posts/$id';
  static String likePost(String id) => '/community/posts/$id/like';
  static String hasLiked(String id) => '/community/posts/$id/liked';
  static String postReplies(String id) => '/community/posts/$id/replies';
  static String circleById(String id) => '/community/circles/$id';
  static String joinCircle(String id) => '/community/circles/$id/join';
  static String leaveCircle(String id) => '/community/circles/$id/leave';
  static String circleMembership(String id) => '/community/circles/$id/membership';
  static String circlePosts(String id) => '/community/circles/$id/posts';
}

class Reports {
  const Reports._();

  static const String create = '/reports';
}

class PublicApi {
  const PublicApi._();

  static const String stats = '/public/stats';
  static const String testimonials = '/public/testimonials';
}

class Admin {
  const Admin._();

  static const String stats = '/admin/stats';
  static const String users = '/admin/users';
  static const String circles = '/admin/circles';
  static const String posts = '/admin/posts';
  static const String sessions = '/admin/sessions';
  static const String connections = '/admin/connections';
  static const String reviews = '/admin/reviews';
  static const String reports = '/admin/reports';

  static String userById(String id) => '/admin/users/$id';
  static String userRole(String id) => '/admin/users/$id/role';
  static String banUser(String id) => '/admin/users/$id/ban';
  static String unbanUser(String id) => '/admin/users/$id/unban';
  static String verifySkill(String userId, int skillIndex) =>
      '/admin/users/$userId/verify-skill/$skillIndex';
  static String circleById(String id) => '/admin/circles/$id';
  static String deletePost(String id) => '/admin/posts/$id';
  static String moderatePost(String id) => '/admin/posts/$id/moderate';
  static String cancelSession(String id) => '/admin/sessions/$id/cancel';
  static String deleteConnection(String id) => '/admin/connections/$id';
  static String deleteReview(String id) => '/admin/reviews/$id';
  static String reviewStatus(String id) => '/admin/reviews/$id/status';
  static String reportById(String id) => '/admin/reports/$id';
}

class Uploads {
  const Uploads._();

  static const String avatar = '/profiles/me/avatar';
  static const String cover = '/profiles/me/cover';
}
```

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/core/constants/api_endpoints.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/core/constants/api_endpoints.dart
git commit -m "fix: align all API endpoints with actual backend routes"
```

---

### Task 9: Fix auth_remote_source.dart endpoint references

**Files:**
- Modify: `lib/data/sources/remote/auth_remote_source.dart`

- [ ] **Step 1: Update endpoint references and add missing methods**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/auth_dto.dart';
import 'package:skill_exchange/data/models/user_model.dart';

class AuthRemoteSource {
  final Dio _dio;

  AuthRemoteSource(this._dio);

  Future<AuthTokensModel> login(LoginDto dto) async {
    final response = await _dio.post(Auth.login, data: dto.toJson());
    return AuthTokensModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<AuthTokensModel> signup(SignupDto dto) async {
    final response = await _dio.post(Auth.register, data: dto.toJson());
    return AuthTokensModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> logout() async {
    await _dio.post(Auth.logout);
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(Users.me);
    return UserModel.fromJson(
      response.data['data']['user'] as Map<String, dynamic>,
    );
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post(Auth.forgotPassword, data: {'email': email});
  }

  Future<void> resetPassword(String token, String newPassword) async {
    await _dio.post(
      Auth.resetPassword,
      data: {'token': token, 'password': newPassword},
    );
  }

  Future<void> verifyEmail(String token) async {
    await _dio.post(Auth.verifyEmail, data: {'token': token});
  }

  Future<void> changePassword(ChangePasswordDto dto) async {
    await _dio.post(Auth.changePassword, data: dto.toJson());
  }

  Future<void> changeEmail(String password, String newEmail) async {
    await _dio.patch(Auth.changeEmail, data: {
      'password': password,
      'newEmail': newEmail,
    });
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/sources/remote/auth_remote_source.dart
git commit -m "fix: align auth remote source with backend routes"
```

---

### Task 10: Fix connection_remote_source.dart

**Files:**
- Modify: `lib/data/sources/remote/connection_remote_source.dart`

- [ ] **Step 1: Update to use correct accept/reject endpoints**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/connection_model.dart';

class ConnectionRemoteSource {
  final Dio _dio;

  ConnectionRemoteSource(this._dio);

  Future<Map<String, dynamic>> getConnections() async {
    final response = await _dio.get(Connections.list);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<ConnectionModel>> getPendingRequests() async {
    final response = await _dio.get(Connections.pending);
    final data = response.data['data']['pending'] as List;
    return data
        .map((e) => ConnectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ConnectionModel>> getSentRequests() async {
    final response = await _dio.get(Connections.sent);
    final data = response.data['data']['sent'] as List;
    return data
        .map((e) => ConnectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ConnectionModel> sendRequest(
    String toUserId,
    String? message,
  ) async {
    final body = <String, dynamic>{'toUserId': toUserId};
    if (message != null && message.isNotEmpty) {
      body['message'] = message;
    }
    final response = await _dio.post(Connections.request, data: body);
    return ConnectionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<ConnectionModel> acceptRequest(String id) async {
    final response = await _dio.post(Connections.accept(id));
    return ConnectionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<ConnectionModel> rejectRequest(String id) async {
    final response = await _dio.post(Connections.reject(id));
    return ConnectionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> removeConnection(String id) async {
    await _dio.delete(Connections.remove(id));
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/sources/remote/connection_remote_source.dart
git commit -m "fix: align connection remote source with backend routes"
```

---

### Task 11: Fix session_remote_source.dart

**Files:**
- Modify: `lib/data/sources/remote/session_remote_source.dart`

- [ ] **Step 1: Update endpoints and HTTP methods**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/data/models/session_model.dart';

class SessionRemoteSource {
  final Dio _dio;

  SessionRemoteSource(this._dio);

  /// Returns {upcoming: [...], past: [...]}
  Future<Map<String, dynamic>> getSessions() async {
    final response = await _dio.get(Sessions.list);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<SessionModel> getSession(String id) async {
    final response = await _dio.get(Sessions.byId(id));
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> bookSession(CreateSessionDto dto) async {
    final response = await _dio.post(Sessions.book, data: dto.toJson());
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> cancelSession(String id, {String? reason}) async {
    final body = <String, dynamic>{};
    if (reason != null) body['reason'] = reason;
    final response = await _dio.post(Sessions.cancel(id), data: body);
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> completeSession(String id, {String? notes}) async {
    final body = <String, dynamic>{};
    if (notes != null) body['notes'] = notes;
    final response = await _dio.post(Sessions.complete(id), data: body);
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<SessionModel> rescheduleSession(
    String id,
    RescheduleSessionDto dto,
  ) async {
    final response = await _dio.put(
      Sessions.reschedule(id),
      data: dto.toJson(),
    );
    return SessionModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/sources/remote/session_remote_source.dart
git commit -m "fix: align session remote source with backend routes"
```

---

### Task 12: Fix messaging_remote_source.dart

**Files:**
- Modify: `lib/data/sources/remote/messaging_remote_source.dart`

- [ ] **Step 1: Update to use correct thread-based endpoints**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';

class MessagingRemoteSource {
  final Dio _dio;

  MessagingRemoteSource(this._dio);

  Future<List<ConversationModel>> getThreads() async {
    final response = await _dio.get(Messages.threads);
    final data = response.data['data'] as List;
    return data
        .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getMessages(
    String threadId, {
    int page = 1,
  }) async {
    final response = await _dio.get(
      Messages.threadById(threadId),
      queryParameters: {'page': page},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<MessageModel> sendMessage(
    String receiverId,
    String content,
  ) async {
    final response = await _dio.post(
      Messages.send,
      data: {'receiverId': receiverId, 'content': content},
    );
    return MessageModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> markThreadRead(String threadId) async {
    await _dio.post(Messages.markRead(threadId));
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(Messages.unreadCount);
    return response.data['data']['count'] as int;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/sources/remote/messaging_remote_source.dart
git commit -m "fix: align messaging remote source with backend thread-based API"
```

---

### Task 13: Update profile_remote_source.dart with missing endpoints

**Files:**
- Modify: `lib/data/sources/remote/profile_remote_source.dart`

- [ ] **Step 1: Add cover image, preferences, username lookup, user posts**

```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

class ProfileRemoteSource {
  final Dio _dio;

  ProfileRemoteSource(this._dio);

  Future<UserProfileModel> getCurrentProfile() async {
    final response = await _dio.get(Profiles.me);
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> getProfile(String id) async {
    final response = await _dio.get(Profiles.byId(id));
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> getProfileByUsername(String username) async {
    final response = await _dio.get(Profiles.byUsername(username));
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<UserProfileModel> updateProfile(UpdateProfileDto dto) async {
    final response = await _dio.patch(Profiles.me, data: dto.toJson());
    return UserProfileModel.fromJson(
      response.data['data']['profile'] as Map<String, dynamic>,
    );
  }

  Future<String> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(Profiles.avatar, data: formData);
    return response.data['data']['url'] as String;
  }

  Future<String> uploadCoverImage(File file) async {
    final formData = FormData.fromMap({
      'coverImage': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(Profiles.cover, data: formData);
    return response.data['data']['url'] as String;
  }

  Future<void> removeCoverImage() async {
    await _dio.delete(Profiles.cover);
  }

  Future<Map<String, dynamic>> getPreferences() async {
    final response = await _dio.get(Profiles.preferences);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updatePreferences(Map<String, dynamic> data) async {
    final response = await _dio.patch(Profiles.preferences, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<dynamic>> getUserPosts(String userId) async {
    final response = await _dio.get(Profiles.userPosts(userId));
    return response.data['data'] as List<dynamic>;
  }

  Future<List<SkillModel>> getAllSkills() async {
    final response = await _dio.get(Skills.list);
    final data = response.data['data'] as List;
    return data
        .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> getSkillCategories() async {
    final response = await _dio.get(Skills.categories);
    final data = response.data['data'] as List;
    return data.cast<String>();
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/sources/remote/profile_remote_source.dart
git commit -m "feat: add cover image, preferences, username lookup to profile remote source"
```

---

### Task 14: Update community_remote_source.dart with all endpoints

**Files:**
- Modify: `lib/data/sources/remote/community_remote_source.dart`

- [ ] **Step 1: Read current file and add all missing community endpoints**

Check the current file first, then replace with full implementation covering:
- Posts CRUD, media upload, likes, replies
- Circles CRUD, join/leave, membership check, circle posts
- Leaderboard

```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class CommunityRemoteSource {
  final Dio _dio;

  CommunityRemoteSource(this._dio);

  // ── Posts ──

  Future<Map<String, dynamic>> getPosts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Community.posts, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    final response = await _dio.post(Community.posts, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    await _dio.put(Community.postById(postId), data: data);
  }

  Future<void> deletePost(String postId) async {
    await _dio.delete(Community.postById(postId));
  }

  Future<List<Map<String, dynamic>>> uploadPostMedia(List<File> files) async {
    final formData = FormData();
    for (final file in files) {
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(file.path),
      ));
    }
    final response = await _dio.post(
      Community.uploadMedia,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return (response.data['data']['media'] as List)
        .cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> uploadPostVideo(File file) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(file.path),
    });
    final response = await _dio.post(
      Community.uploadVideo,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Likes ──

  Future<void> likePost(String postId) async {
    await _dio.post(Community.likePost(postId));
  }

  Future<void> unlikePost(String postId) async {
    await _dio.delete(Community.likePost(postId));
  }

  Future<bool> hasUserLikedPost(String postId) async {
    final response = await _dio.get(Community.hasLiked(postId));
    return response.data['data']['liked'] as bool;
  }

  // ── Replies ──

  Future<List<dynamic>> getPostReplies(String postId) async {
    final response = await _dio.get(Community.postReplies(postId));
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createReply(String postId, String content) async {
    final response = await _dio.post(
      Community.postReplies(postId),
      data: {'content': content},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Circles ──

  Future<List<dynamic>> getCircles() async {
    final response = await _dio.get(Community.circles);
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> createCircle(Map<String, dynamic> data) async {
    final response = await _dio.post(Community.circles, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateCircle(String circleId, Map<String, dynamic> data) async {
    await _dio.put(Community.circleById(circleId), data: data);
  }

  Future<void> deleteCircle(String circleId) async {
    await _dio.delete(Community.circleById(circleId));
  }

  Future<void> joinCircle(String circleId) async {
    await _dio.post(Community.joinCircle(circleId));
  }

  Future<void> leaveCircle(String circleId) async {
    await _dio.post(Community.leaveCircle(circleId));
  }

  Future<bool> isCircleMember(String circleId) async {
    final response = await _dio.get(Community.circleMembership(circleId));
    return response.data['data']['isMember'] as bool;
  }

  Future<Map<String, dynamic>> getCirclePosts(
    String circleId, {
    Map<String, dynamic>? params,
  }) async {
    final response = await _dio.get(
      Community.circlePosts(circleId),
      queryParameters: params,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createCirclePost(
    String circleId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      Community.circlePosts(circleId),
      data: data,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Leaderboard ──

  Future<List<dynamic>> getLeaderboard({int limit = 10}) async {
    final response = await _dio.get(
      Community.leaderboard,
      queryParameters: {'limit': limit},
    );
    return response.data['data'] as List<dynamic>;
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/sources/remote/community_remote_source.dart
git commit -m "feat: add all community endpoints (posts, circles, likes, replies, leaderboard)"
```

---

### Task 15: Add admin_remote_source.dart with all admin endpoints

**Files:**
- Modify: `lib/data/sources/remote/admin_remote_source.dart`

- [ ] **Step 1: Read current file and replace with full admin API**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class AdminRemoteSource {
  final Dio _dio;

  AdminRemoteSource(this._dio);

  // ── Stats ──
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(Admin.stats);
    return response.data['data'] as Map<String, dynamic>;
  }

  // ── Users ──
  Future<Map<String, dynamic>> getUsers({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.users, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await _dio.get(Admin.userById(id));
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateUserRole(String id, String role) async {
    await _dio.patch(Admin.userRole(id), data: {'role': role});
  }

  Future<void> banUser(String id) async {
    await _dio.patch(Admin.banUser(id));
  }

  Future<void> unbanUser(String id) async {
    await _dio.patch(Admin.unbanUser(id));
  }

  Future<void> deleteUser(String id) async {
    await _dio.delete(Admin.userById(id));
  }

  Future<void> verifySkill(String userId, int skillIndex) async {
    await _dio.patch(Admin.verifySkill(userId, skillIndex));
  }

  // ── Posts ──
  Future<Map<String, dynamic>> getPosts({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.posts, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deletePost(String id) async {
    await _dio.delete(Admin.deletePost(id));
  }

  Future<void> moderatePost(String id, Map<String, dynamic> data) async {
    await _dio.patch(Admin.moderatePost(id), data: data);
  }

  // ── Circles ──
  Future<List<dynamic>> getCircles() async {
    final response = await _dio.get(Admin.circles);
    return response.data['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getCircleById(String id) async {
    final response = await _dio.get(Admin.circleById(id));
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> createCircle(Map<String, dynamic> data) async {
    final response = await _dio.post(Admin.circles, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateCircle(String id, Map<String, dynamic> data) async {
    await _dio.put(Admin.circleById(id), data: data);
  }

  Future<void> deleteCircle(String id) async {
    await _dio.delete(Admin.circleById(id));
  }

  // ── Sessions ──
  Future<Map<String, dynamic>> getSessions({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.sessions, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> cancelSession(String id) async {
    await _dio.patch(Admin.cancelSession(id));
  }

  // ── Connections ──
  Future<Map<String, dynamic>> getConnections({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.connections, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteConnection(String id) async {
    await _dio.delete(Admin.deleteConnection(id));
  }

  // ── Reviews ──
  Future<Map<String, dynamic>> getReviews({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.reviews, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> deleteReview(String id) async {
    await _dio.delete(Admin.deleteReview(id));
  }

  Future<void> updateReviewStatus(String id, String status) async {
    await _dio.patch(Admin.reviewStatus(id), data: {'status': status});
  }

  // ── Reports ──
  Future<Map<String, dynamic>> getReports({Map<String, dynamic>? params}) async {
    final response = await _dio.get(Admin.reports, queryParameters: params);
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getReportById(String id) async {
    final response = await _dio.get(Admin.reportById(id));
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    await _dio.patch(Admin.reportById(id), data: data);
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/sources/remote/admin_remote_source.dart
git commit -m "feat: add all admin API endpoints to remote source"
```

---

### Task 16: Add review and notification remote sources with correct endpoints

**Files:**
- Modify: `lib/data/sources/remote/review_remote_source.dart`
- Modify: `lib/data/sources/remote/notification_remote_source.dart`

- [ ] **Step 1: Read current review_remote_source.dart and update**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/create_review_dto.dart';
import 'package:skill_exchange/data/models/review_model.dart';

class ReviewRemoteSource {
  final Dio _dio;

  ReviewRemoteSource(this._dio);

  Future<List<ReviewModel>> getReviewsForUser(String userId) async {
    final response = await _dio.get(Reviews.forUser(userId));
    final data = response.data['data'] as List;
    return data
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ReviewModel>> getReviewsByUser(String userId) async {
    final response = await _dio.get(Reviews.byUser(userId));
    final data = response.data['data'] as List;
    return data
        .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReviewModel> createReview(CreateReviewDto dto) async {
    final response = await _dio.post(Reviews.create, data: dto.toJson());
    return ReviewModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
```

- [ ] **Step 2: Read current notification_remote_source.dart and update**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/notification_model.dart';

class NotificationRemoteSource {
  final Dio _dio;

  NotificationRemoteSource(this._dio);

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get(Notifications.list);
    final data = response.data['data']['notifications'] as List;
    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(Notifications.unreadCount);
    return response.data['data']['count'] as int;
  }

  Future<void> markAsRead(String id) async {
    await _dio.post(Notifications.markRead(id));
  }

  Future<void> markAllAsRead() async {
    await _dio.post(Notifications.readAll);
  }

  Future<void> deleteNotification(String id) async {
    await _dio.delete(Notifications.delete(id));
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/data/sources/remote/review_remote_source.dart lib/data/sources/remote/notification_remote_source.dart
git commit -m "fix: align review and notification remote sources with backend"
```

---

### Task 17: Add report and search remote sources

**Files:**
- Create: `lib/data/sources/remote/report_remote_source.dart`
- Modify: `lib/data/sources/remote/search_remote_source.dart`

- [ ] **Step 1: Create report remote source**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class ReportRemoteSource {
  final Dio _dio;

  ReportRemoteSource(this._dio);

  Future<Map<String, dynamic>> submitReport(Map<String, dynamic> data) async {
    final response = await _dio.post(Reports.create, data: data);
    return response.data['data'] as Map<String, dynamic>;
  }
}
```

- [ ] **Step 2: Read and update search_remote_source.dart**

```dart
import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';

class SearchRemoteSource {
  final Dio _dio;

  SearchRemoteSource(this._dio);

  Future<Map<String, dynamic>> searchUsers({
    String? query,
    String? skillCategory,
    String? skillName,
    String? location,
    double? minRating,
    double? maxRating,
    String? learningStyle,
    int page = 1,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (query != null) params['query'] = query;
    if (skillCategory != null) params['skillCategory'] = skillCategory;
    if (skillName != null) params['skillName'] = skillName;
    if (location != null) params['location'] = location;
    if (minRating != null) params['minRating'] = minRating;
    if (maxRating != null) params['maxRating'] = maxRating;
    if (learningStyle != null) params['learningStyle'] = learningStyle;

    final response = await _dio.get(
      Search.users,
      queryParameters: params,
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/data/sources/remote/report_remote_source.dart lib/data/sources/remote/search_remote_source.dart
git commit -m "feat: add report remote source and align search with backend query params"
```

---

## Sub-Project 3: Data Model Updates

### Task 18: Update UserModel with missing fields

**Files:**
- Modify: `lib/data/models/user_model.dart`
- Modify: `lib/domain/entities/user.dart`

- [ ] **Step 1: Add isVerified, isActive, lastLogin to UserModel**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') String? mongoId,
    String? id,
    required String email,
    required String name,
    String? avatar,
    @Default('user') String role,
    @Default(false) bool isVerified,
    @Default(true) bool isActive,
    String? lastLogin,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

- [ ] **Step 2: Update User entity**

```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String role;
  final bool isVerified;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.role = 'user',
    this.isVerified = false,
    this.isActive = true,
  });

  bool get isAdmin => role == 'admin';
}
```

- [ ] **Step 3: Update _toEntity in auth_repository_impl.dart**

In `lib/data/repositories/auth_repository_impl.dart`, update:

```dart
  User _toEntity(dynamic model) {
    return User(
      id: (model.mongoId ?? model.id ?? '') as String,
      email: model.email as String,
      name: model.name as String,
      avatar: model.avatar as String?,
      role: model.role as String,
      isVerified: (model.isVerified ?? false) as bool,
      isActive: (model.isActive ?? true) as bool,
    );
  }
```

- [ ] **Step 4: Run code generation**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && dart run build_runner build --delete-conflicting-outputs`
Expected: Code generation completes successfully

- [ ] **Step 5: Commit**

```bash
git add lib/data/models/user_model.dart lib/data/models/user_model.freezed.dart lib/data/models/user_model.g.dart lib/domain/entities/user.dart lib/data/repositories/auth_repository_impl.dart
git commit -m "feat: add isVerified, isActive, lastLogin to User model"
```

---

### Task 19: Update UserProfileModel with missing fields

**Files:**
- Modify: `lib/data/models/user_profile_model.dart`

- [ ] **Step 1: Add userId, coverImage, privacyPreferences, notificationPreferences**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/skill_model.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String id,
    String? userId,
    required String username,
    required String email,
    required String fullName,
    String? avatar,
    String? coverImage,
    String? bio,
    String? location,
    String? timezone,
    @Default([]) List<String> languages,
    @Default([]) List<SkillModel> skillsToTeach,
    @Default([]) List<SkillModel> skillsToLearn,
    @Default([]) List<String> interests,
    required AvailabilityModel availability,
    @Default('visual') String preferredLearningStyle,
    required String joinedAt,
    required String lastActive,
    required UserStatsModel stats,
    PrivacyPreferencesModel? privacyPreferences,
    NotificationPreferencesModel? notificationPreferences,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

@freezed
class AvailabilityModel with _$AvailabilityModel {
  const factory AvailabilityModel({
    @Default(false) bool monday,
    @Default(false) bool tuesday,
    @Default(false) bool wednesday,
    @Default(false) bool thursday,
    @Default(false) bool friday,
    @Default(false) bool saturday,
    @Default(false) bool sunday,
  }) = _AvailabilityModel;

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityModelFromJson(json);
}

@freezed
class UserStatsModel with _$UserStatsModel {
  const factory UserStatsModel({
    @Default(0) int connectionsCount,
    @Default(0) int sessionsCompleted,
    @Default(0) int reviewsReceived,
    @Default(0.0) double averageRating,
  }) = _UserStatsModel;

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);
}

@freezed
class PrivacyPreferencesModel with _$PrivacyPreferencesModel {
  const factory PrivacyPreferencesModel({
    @Default('public') String profileVisibility,
    @Default(false) bool showEmail,
    @Default(true) bool showLocation,
    @Default(true) bool showOnlineStatus,
    @Default('everyone') String allowMessages,
  }) = _PrivacyPreferencesModel;

  factory PrivacyPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPreferencesModelFromJson(json);
}

@freezed
class NotificationPreferencesModel with _$NotificationPreferencesModel {
  const factory NotificationPreferencesModel({
    @Default(true) bool emailNotifications,
    @Default(true) bool pushNotifications,
    @Default(true) bool connectionRequests,
    @Default(true) bool sessionReminders,
    @Default(true) bool newMessages,
    @Default(true) bool reviewsReceived,
    @Default(false) bool marketingEmails,
  }) = _NotificationPreferencesModel;

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);
}
```

- [ ] **Step 2: Run code generation**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: Code generation completes successfully

- [ ] **Step 3: Commit**

```bash
git add lib/data/models/user_profile_model.dart lib/data/models/user_profile_model.freezed.dart lib/data/models/user_profile_model.g.dart
git commit -m "feat: add coverImage, privacy/notification preferences to UserProfileModel"
```

---

## Sub-Project 4: DI + Repository Wiring

### Task 20: Wire all remote sources and repositories in providers.dart

**Files:**
- Modify: `lib/config/di/providers.dart`

- [ ] **Step 1: Add all feature providers**

```dart
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skill_exchange/config/env/env_config.dart';
import 'package:skill_exchange/core/network/auth_interceptor.dart';
import 'package:skill_exchange/core/network/error_interceptor.dart';
import 'package:skill_exchange/core/network/mock_interceptor.dart';
import 'package:skill_exchange/data/repositories/auth_repository_impl.dart';
import 'package:skill_exchange/data/repositories/profile_repository_impl.dart';
import 'package:skill_exchange/data/repositories/connection_repository_impl.dart';
import 'package:skill_exchange/data/repositories/session_repository_impl.dart';
import 'package:skill_exchange/data/repositories/messaging_repository_impl.dart';
import 'package:skill_exchange/data/repositories/review_repository_impl.dart';
import 'package:skill_exchange/data/repositories/notification_repository_impl.dart';
import 'package:skill_exchange/data/repositories/matching_repository_impl.dart';
import 'package:skill_exchange/data/repositories/search_repository_impl.dart';
import 'package:skill_exchange/data/repositories/community_repository_impl.dart';
import 'package:skill_exchange/data/repositories/admin_repository_impl.dart';
import 'package:skill_exchange/data/sources/local/preferences_source.dart';
import 'package:skill_exchange/data/sources/local/secure_storage_source.dart';
import 'package:skill_exchange/data/sources/remote/auth_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/profile_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/connection_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/session_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/messaging_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/review_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/notification_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/matching_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/search_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/community_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/admin_remote_source.dart';
import 'package:skill_exchange/data/sources/remote/report_remote_source.dart';
import 'package:skill_exchange/domain/repositories/auth_repository.dart';
import 'package:skill_exchange/domain/repositories/profile_repository.dart';
import 'package:skill_exchange/domain/repositories/connection_repository.dart';
import 'package:skill_exchange/domain/repositories/session_repository.dart';
import 'package:skill_exchange/domain/repositories/messaging_repository.dart';
import 'package:skill_exchange/domain/repositories/review_repository.dart';
import 'package:skill_exchange/domain/repositories/notification_repository.dart';
import 'package:skill_exchange/domain/repositories/matching_repository.dart';
import 'package:skill_exchange/domain/repositories/search_repository.dart';
import 'package:skill_exchange/domain/repositories/community_repository.dart';
import 'package:skill_exchange/domain/repositories/admin_repository.dart';

// ── Local Storage ─────────────────────────────────────────────────────────

final secureStorageSourceProvider = Provider<SecureStorageSource>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return SecureStorageSource(storage);
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with a real instance.',
  );
});

final preferencesSourceProvider = Provider<PreferencesSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesSource(prefs);
});

// ── Networking ────────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: EnvConfig.apiTimeoutSeconds),
      receiveTimeout: const Duration(seconds: EnvConfig.apiTimeoutSeconds),
      sendTimeout: const Duration(seconds: EnvConfig.apiTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final authInterceptor = AuthInterceptor(
    storage: ref.read(secureStorageSourceProvider),
    dio: dio,
  );

  if (EnvConfig.enableMockData) {
    dio.interceptors.add(MockInterceptor());
  }

  dio.interceptors.addAll([
    if (!EnvConfig.enableMockData) authInterceptor,
    if (!EnvConfig.enableMockData) ErrorInterceptor(),
    if (kDebugMode)
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => developer.log(obj.toString(), name: 'Dio'),
      ),
  ]);

  return dio;
});

// ── Remote Sources ────────────────────────────────────────────────────────

final authRemoteSourceProvider = Provider<AuthRemoteSource>((ref) {
  return AuthRemoteSource(ref.watch(dioProvider));
});

final profileRemoteSourceProvider = Provider<ProfileRemoteSource>((ref) {
  return ProfileRemoteSource(ref.watch(dioProvider));
});

final connectionRemoteSourceProvider = Provider<ConnectionRemoteSource>((ref) {
  return ConnectionRemoteSource(ref.watch(dioProvider));
});

final sessionRemoteSourceProvider = Provider<SessionRemoteSource>((ref) {
  return SessionRemoteSource(ref.watch(dioProvider));
});

final messagingRemoteSourceProvider = Provider<MessagingRemoteSource>((ref) {
  return MessagingRemoteSource(ref.watch(dioProvider));
});

final reviewRemoteSourceProvider = Provider<ReviewRemoteSource>((ref) {
  return ReviewRemoteSource(ref.watch(dioProvider));
});

final notificationRemoteSourceProvider = Provider<NotificationRemoteSource>((ref) {
  return NotificationRemoteSource(ref.watch(dioProvider));
});

final matchingRemoteSourceProvider = Provider<MatchingRemoteSource>((ref) {
  return MatchingRemoteSource(ref.watch(dioProvider));
});

final searchRemoteSourceProvider = Provider<SearchRemoteSource>((ref) {
  return SearchRemoteSource(ref.watch(dioProvider));
});

final communityRemoteSourceProvider = Provider<CommunityRemoteSource>((ref) {
  return CommunityRemoteSource(ref.watch(dioProvider));
});

final adminRemoteSourceProvider = Provider<AdminRemoteSource>((ref) {
  return AdminRemoteSource(ref.watch(dioProvider));
});

final reportRemoteSourceProvider = Provider<ReportRemoteSource>((ref) {
  return ReportRemoteSource(ref.watch(dioProvider));
});

// ── Repositories ──────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteSourceProvider),
    ref.watch(secureStorageSourceProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteSourceProvider));
});

final connectionRepositoryProvider = Provider<ConnectionRepository>((ref) {
  return ConnectionRepositoryImpl(ref.watch(connectionRemoteSourceProvider));
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl(ref.watch(sessionRemoteSourceProvider));
});

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(ref.watch(messagingRemoteSourceProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteSourceProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(notificationRemoteSourceProvider));
});

final matchingRepositoryProvider = Provider<MatchingRepository>((ref) {
  return MatchingRepositoryImpl(ref.watch(matchingRemoteSourceProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.watch(searchRemoteSourceProvider));
});

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl(ref.watch(communityRemoteSourceProvider));
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(adminRemoteSourceProvider));
});
```

- [ ] **Step 2: Verify it compiles (fix any missing imports)**

Run: `flutter analyze lib/config/di/providers.dart`
Expected: No errors (some repository impls may need constructor updates — fix in next tasks)

- [ ] **Step 3: Commit**

```bash
git add lib/config/di/providers.dart
git commit -m "feat: wire all remote sources and repositories in DI container"
```

---

## Sub-Project 5: Socket.IO Integration

### Task 21: Replace web_socket_channel with socket_io_client

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/core/network/socket_service.dart`

- [ ] **Step 1: Update pubspec.yaml**

Remove `web_socket_channel` and add `socket_io_client`:

```yaml
  # Replace web_socket_channel with socket_io_client
  socket_io_client: ^3.0.2
```

- [ ] **Step 2: Run flutter pub get**

Run: `flutter pub get`

- [ ] **Step 3: Create SocketService**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:skill_exchange/config/env/env_config.dart';

class SocketService {
  io.Socket? _socket;

  io.Socket? get socket => _socket;
  bool get isConnected => _socket?.connected ?? false;

  void connect(String token) {
    _socket = io.io(
      EnvConfig.wsUrl.replaceFirst('ws://', 'http://').replaceFirst('wss://', 'https://'),
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .build(),
    );
    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void emit(String event, dynamic data, {Function? ack}) {
    _socket?.emitWithAck(event, data, ack: ack);
  }

  void sendMessage(String receiverId, String content, {Function? callback}) {
    emit('send_message', {'receiverId': receiverId, 'content': content}, ack: callback);
  }

  void markRead(String threadId, {Function? callback}) {
    emit('mark_read', {'threadId': threadId}, ack: callback);
  }

  void sendTyping(String receiverId, bool isTyping) {
    _socket?.emit('typing', {'receiverId': receiverId, 'isTyping': isTyping});
  }
}

final socketServiceProvider = Provider<SocketService>((ref) {
  return SocketService();
});
```

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml lib/core/network/socket_service.dart
git commit -m "feat: add Socket.IO client service for real-time messaging"
```

---

## Sub-Project 6: Verify Full App Compiles

### Task 22: Run code generation and fix compilation errors

**Files:**
- All modified files

- [ ] **Step 1: Run full code generation**

Run: `cd /Users/hompushparajmehta/Pushparaj/github/Learning/kruti/flutter/skill_exchange && dart run build_runner build --delete-conflicting-outputs`
Expected: Code generation completes

- [ ] **Step 2: Run flutter analyze**

Run: `flutter analyze lib/`
Expected: Fix any errors found. Warnings are acceptable.

- [ ] **Step 3: Fix any compilation errors found**

Common issues to fix:
- Old endpoint references (e.g., `Connections.respond` → split into `Connections.accept` + `Connections.reject`)
- Changed `const` TextStyles to `final` (google_fonts returns non-const)
- Missing repository constructor params after DI changes
- Import path changes for renamed endpoint classes

- [ ] **Step 4: Commit all fixes**

```bash
git add -A
git commit -m "fix: resolve all compilation errors after full port alignment"
```

---

## Sub-Project 7: Mock Interceptor Update

### Task 23: Update MockInterceptor to match new endpoint paths

**Files:**
- Modify: `lib/core/network/mock_interceptor.dart`

- [ ] **Step 1: Update all mock endpoint path matching**

The MockInterceptor matches request paths to return fake data. After changing endpoint paths in Task 8, the mock interceptor needs the same path updates:

- `/auth/signup` → `/auth/register`
- `/auth/me` → `/users/me`
- `/connections/:id/respond` → `/connections/:id/accept` + `/connections/:id/reject`
- `/sessions/upcoming` → `/sessions` (return both upcoming + past)
- `/sessions` (POST for create) → `/sessions/book`
- `/messages/conversations` → `/messages/threads`
- `/messages/conversations/:id` → `/messages/threads/:id`
- `/messages` (POST for send) → `/messages/send`
- Add `/messages/unread-count`
- Add `/profiles/me/cover`, `/profiles/me/preferences`, `/profiles/by-username/:username`
- Add `/community/posts/:id/liked`, `/community/posts/:id/replies`
- Add `/community/circles/:id/membership`, `/community/circles/:id/posts`
- Add `/public/stats`, `/public/testimonials`
- Add `/reports` POST
- Add all `/admin/*` routes

Read the current mock interceptor, identify every path match, and update them to use the new paths. This is a large file — update each path match carefully.

- [ ] **Step 2: Verify mock mode still works**

Run: `flutter run --dart-define=ENABLE_MOCK_DATA=true` (or the default)
Expected: App launches and shows mock data on all screens

- [ ] **Step 3: Commit**

```bash
git add lib/core/network/mock_interceptor.dart
git commit -m "fix: update mock interceptor paths to match corrected API endpoints"
```

---

## Summary of All Tasks

| # | Sub-Project | Task | Files |
|---|-------------|------|-------|
| 1 | Design Tokens | Fix app_colors.dart | app_colors.dart |
| 2 | Design Tokens | Update AppColorsExtension | app_colors_extension.dart |
| 3 | Design Tokens | Fix app_radius.dart | app_radius.dart |
| 4 | Design Tokens | Update app_shadows.dart | app_shadows.dart |
| 5 | Design Tokens | Add AppGradients | app_gradients.dart (new) |
| 6 | Design Tokens | Urbanist font | app_text_styles.dart, pubspec.yaml |
| 7 | Design Tokens | Update app_theme.dart | app_theme.dart |
| 8 | API Endpoints | Fix api_endpoints.dart | api_endpoints.dart |
| 9 | API Endpoints | Fix auth_remote_source | auth_remote_source.dart |
| 10 | API Endpoints | Fix connection_remote_source | connection_remote_source.dart |
| 11 | API Endpoints | Fix session_remote_source | session_remote_source.dart |
| 12 | API Endpoints | Fix messaging_remote_source | messaging_remote_source.dart |
| 13 | API Endpoints | Update profile_remote_source | profile_remote_source.dart |
| 14 | API Endpoints | Update community_remote_source | community_remote_source.dart |
| 15 | API Endpoints | Update admin_remote_source | admin_remote_source.dart |
| 16 | API Endpoints | Fix review + notification sources | review/notification_remote_source.dart |
| 17 | API Endpoints | Add report + search sources | report/search_remote_source.dart |
| 18 | Models | Update UserModel | user_model.dart, user.dart |
| 19 | Models | Update UserProfileModel | user_profile_model.dart |
| 20 | DI Wiring | Wire all providers | providers.dart |
| 21 | Socket.IO | Add socket_io_client | pubspec.yaml, socket_service.dart (new) |
| 22 | Compilation | Fix all errors | various |
| 23 | Mock Update | Update MockInterceptor | mock_interceptor.dart |
