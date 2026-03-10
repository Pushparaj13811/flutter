import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.enabled = true,
  });

  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const borderRadius = BorderRadius.all(Radius.circular(AppRadius.input));

    final defaultBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.input),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.ring, width: 2),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.destructive),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.destructive, width: 2),
    );

    final disabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.input),
    );

    final field = TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      enabled: enabled,
      onChanged: onChanged,
      style: AppTextStyles.bodyMedium.copyWith(
        color: colors.foreground,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colors.mutedForeground,
        ),
        errorText: errorText,
        errorStyle: AppTextStyles.caption.copyWith(
          color: colors.destructive,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: !enabled,
        fillColor: enabled ? null : colors.muted,
        enabledBorder: defaultBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
        disabledBorder: disabledBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label!,
          style: AppTextStyles.labelMedium.copyWith(
            color: colors.foreground,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        field,
      ],
    );
  }
}
