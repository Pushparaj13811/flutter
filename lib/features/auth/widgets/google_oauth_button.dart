// Google OAuth button widget
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';

class GoogleOAuthButton extends StatelessWidget {
  const GoogleOAuthButton({super.key, this.onPressed});

  /// Called when the button is tapped. Defaults to a no-op until the
  /// OAuth flow is wired up.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed ?? () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          backgroundColor: context.colors.card,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google "G" icon rendered with bold blue text to match the
            // brand colour without requiring an image asset.
            const Text(
              'G',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2563EB),
                height: 1,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.colors.foreground,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
