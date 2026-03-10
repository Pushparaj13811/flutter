import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_shadows.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final BorderRadius borderRadius =
        BorderRadius.circular(AppRadius.card);

    final Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      child: child,
    );

    if (onTap != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: borderRadius,
          boxShadow: AppShadows.sm,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: content,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: borderRadius,
        boxShadow: AppShadows.sm,
      ),
      child: content,
    );
  }
}
