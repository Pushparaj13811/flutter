import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors.dart';

/// Theme extension that provides all semantic colors for the app.
///
/// Access via `context.colors.primary`, `context.colors.foreground`, etc.
/// This ensures colors adapt automatically to light/dark theme.
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

  // ── Light theme instance ────────────────────────────────────────────────

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

  // ── Dark theme instance ─────────────────────────────────────────────────

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
    success: AppColors.success, // Status colors stay the same
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

  // ── ThemeExtension overrides ────────────────────────────────────────────

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
      destructiveForeground:
          destructiveForeground ?? this.destructiveForeground,
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
      primaryForeground:
          Color.lerp(primaryForeground, other.primaryForeground, t)!,
      primarySubtle: Color.lerp(primarySubtle, other.primarySubtle, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryHover: Color.lerp(secondaryHover, other.secondaryHover, t)!,
      secondaryForeground:
          Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      secondarySubtle: Color.lerp(secondarySubtle, other.secondarySubtle, t)!,
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      popover: Color.lerp(popover, other.popover, t)!,
      popoverForeground:
          Color.lerp(popoverForeground, other.popoverForeground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceForeground:
          Color.lerp(surfaceForeground, other.surfaceForeground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground:
          Color.lerp(mutedForeground, other.mutedForeground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentForeground:
          Color.lerp(accentForeground, other.accentForeground, t)!,
      accentSubtle: Color.lerp(accentSubtle, other.accentSubtle, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      highlightForeground:
          Color.lerp(highlightForeground, other.highlightForeground, t)!,
      highlightSubtle: Color.lerp(highlightSubtle, other.highlightSubtle, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveForeground:
          Color.lerp(destructiveForeground, other.destructiveForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      ring: Color.lerp(ring, other.ring, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      beginnerBg: Color.lerp(beginnerBg, other.beginnerBg, t)!,
      beginnerText: Color.lerp(beginnerText, other.beginnerText, t)!,
      intermediateBg: Color.lerp(intermediateBg, other.intermediateBg, t)!,
      intermediateText:
          Color.lerp(intermediateText, other.intermediateText, t)!,
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

/// Convenience extension to access app colors from BuildContext.
///
/// Usage: `context.colors.primary`, `context.colors.foreground`, etc.
extension AppColorsContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
