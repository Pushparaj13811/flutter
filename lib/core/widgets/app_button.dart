// AppButton with variants (primary, secondary, outline, text, destructive, icon)

import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';

enum _AppButtonVariant { primary, secondary, outline, text, destructive, icon }

class AppButton extends StatelessWidget {
  // ── Shared fields ──────────────────────────────────────────────────────────

  final _AppButtonVariant _variant;
  final String? _label;
  final VoidCallback? _onPressed;
  final bool _isLoading;
  final IconData? _icon;
  final String? _tooltip;

  // ── Private canonical constructor ──────────────────────────────────────────

  const AppButton._({
    super.key,
    required _AppButtonVariant variant,
    String? label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? tooltip,
  })  : _variant = variant,
        _label = label,
        _onPressed = onPressed,
        _isLoading = isLoading,
        _icon = icon,
        _tooltip = tooltip;

  // ── Named constructors ─────────────────────────────────────────────────────

  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AppButton._(
      key: key,
      variant: _AppButtonVariant.primary,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AppButton._(
      key: key,
      variant: _AppButtonVariant.secondary,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AppButton.outline({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AppButton._(
      key: key,
      variant: _AppButtonVariant.outline,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
  }) {
    return AppButton._(
      key: key,
      variant: _AppButtonVariant.text,
      label: label,
      onPressed: onPressed,
    );
  }

  factory AppButton.destructive({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AppButton._(
      key: key,
      variant: _AppButtonVariant.destructive,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }

  factory AppButton.icon({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return AppButton._(
      key: key,
      variant: _AppButtonVariant.icon,
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(AppRadius.button));

  Widget _buildLoadingIndicator(Color color) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildLabelRow({
    required String label,
    required Color foreground,
    IconData? icon,
  }) {
    if (_isLoading) {
      return _buildLoadingIndicator(foreground);
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(color: foreground),
          ),
        ],
      );
    }
    return Text(
      label,
      style: AppTextStyles.labelLarge.copyWith(color: foreground),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    switch (_variant) {
      case _AppButtonVariant.primary:
        return _buildPrimary(context);
      case _AppButtonVariant.secondary:
        return _buildSecondary(context);
      case _AppButtonVariant.outline:
        return _buildOutline(context);
      case _AppButtonVariant.text:
        return _buildText(context);
      case _AppButtonVariant.destructive:
        return _buildDestructive(context);
      case _AppButtonVariant.icon:
        return _buildIcon();
    }
  }

  // ── Variant builders ───────────────────────────────────────────────────────

  Widget _buildPrimary(BuildContext context) {
    final colors = context.colors;
    final bool enabled = !_isLoading && _onPressed != null;
    return ElevatedButton(
      onPressed: enabled ? _onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        disabledBackgroundColor: colors.primary.withAlpha(153),
        foregroundColor: colors.primaryForeground,
        disabledForegroundColor: colors.primaryForeground.withAlpha(153),
        textStyle: AppTextStyles.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
        elevation: 0,
      ),
      child: _buildLabelRow(
        label: _label!,
        foreground: colors.primaryForeground,
        icon: _icon,
      ),
    );
  }

  Widget _buildSecondary(BuildContext context) {
    final colors = context.colors;
    final bool enabled = !_isLoading && _onPressed != null;
    return ElevatedButton(
      onPressed: enabled ? _onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.secondary,
        disabledBackgroundColor: colors.secondary.withAlpha(153),
        foregroundColor: colors.secondaryForeground,
        disabledForegroundColor: colors.secondaryForeground.withAlpha(153),
        textStyle: AppTextStyles.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
        elevation: 0,
      ),
      child: _buildLabelRow(
        label: _label!,
        foreground: colors.secondaryForeground,
      ),
    );
  }

  Widget _buildOutline(BuildContext context) {
    final colors = context.colors;
    final bool enabled = !_isLoading && _onPressed != null;
    return OutlinedButton(
      onPressed: enabled ? _onPressed : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.primary,
        disabledForegroundColor: colors.primary.withAlpha(102),
        textStyle: AppTextStyles.labelLarge,
        side: BorderSide(color: colors.border),
        shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
      ),
      child: _buildLabelRow(
        label: _label!,
        foreground: enabled ? colors.primary : colors.primary.withAlpha(102),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    final colors = context.colors;
    return TextButton(
      onPressed: _onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: colors.primary,
        textStyle: AppTextStyles.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
      ),
      child: Text(
        _label!,
        style: AppTextStyles.labelLarge.copyWith(color: colors.primary),
      ),
    );
  }

  Widget _buildDestructive(BuildContext context) {
    final colors = context.colors;
    final bool enabled = !_isLoading && _onPressed != null;
    return ElevatedButton(
      onPressed: enabled ? _onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.destructive,
        disabledBackgroundColor: colors.destructive.withAlpha(153),
        foregroundColor: colors.destructiveForeground,
        disabledForegroundColor: colors.destructiveForeground.withAlpha(153),
        textStyle: AppTextStyles.labelLarge,
        shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
        elevation: 0,
      ),
      child: _buildLabelRow(
        label: _label!,
        foreground: colors.destructiveForeground,
      ),
    );
  }

  Widget _buildIcon() {
    return IconButton(
      onPressed: _onPressed,
      icon: Icon(_icon),
      tooltip: _tooltip ?? _icon?.toString(),
    );
  }
}
