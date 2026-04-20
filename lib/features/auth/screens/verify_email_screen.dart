import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_gradients.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/data/sources/firebase/firebase_auth_service.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _autoCheckTimer;
  bool _canResend = true;
  int _resendCooldown = 0;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // Auto-check verification status every 3 seconds
    _autoCheckTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkVerification(silent: true),
    );
  }

  @override
  void dispose() {
    _autoCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerification({bool silent = false}) async {
    if (_isChecking) return;
    if (!silent && mounted) setState(() => _isChecking = true);

    try {
      await fb.FirebaseAuth.instance.currentUser?.reload();
      final isVerified =
          fb.FirebaseAuth.instance.currentUser?.emailVerified ?? false;

      if (isVerified && mounted) {
        _autoCheckTimer?.cancel();
        final uid = fb.FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'isVerified': true});

        final user =
            await ref.read(firebaseAuthServiceProvider).getCurrentUser();
        if (user != null) {
          ref.read(authProvider.notifier).refreshUser(user);
        }
      } else if (!silent && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Not verified yet. Please open the link in your email.'),
            backgroundColor: context.colors.highlight,
          ),
        );
      }
    } catch (_) {}

    if (mounted) setState(() => _isChecking = false);
  }

  Future<void> _resendEmail() async {
    if (!_canResend) return;
    try {
      await fb.FirebaseAuth.instance.currentUser?.sendEmailVerification();
      setState(() {
        _canResend = false;
        _resendCooldown = 60;
      });
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _resendCooldown--;
          if (_resendCooldown <= 0) {
            _canResend = true;
            timer.cancel();
          }
        });
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent! Check your inbox.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    _autoCheckTimer?.cancel();
    ref.read(authProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final email = fb.FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.xxl,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // Animated email icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppGradients.heroFor(Theme.of(context).brightness),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text(
                'Check Your Email',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.mutedForeground,
                  ),
                  children: [
                    const TextSpan(text: 'We\'ve sent a verification link to\n'),
                    TextSpan(
                      text: email,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.foreground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Steps
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to verify:',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: colors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildStep(colors, '1', 'Open your email app'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStep(colors, '2',
                        'Find the email from "noreply@${_getProjectDomain()}"'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStep(colors, '3',
                        'Click the verification link in the email'),
                    const SizedBox(height: AppSpacing.sm),
                    _buildStep(colors, '4',
                        'Come back here — this page updates automatically'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Auto-checking indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Waiting for verification...',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Check now button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isChecking
                      ? null
                      : () => _checkVerification(silent: false),
                  icon: _isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.refresh, size: 20),
                  label: Text(
                      _isChecking ? 'Checking...' : 'Check Verification Status'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Resend button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _canResend ? _resendEmail : null,
                  icon: const Icon(Icons.send_outlined, size: 18),
                  label: Text(
                    _canResend
                        ? 'Resend Verification Email'
                        : 'Resend in ${_resendCooldown}s',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Didn't get email help text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Didn\'t receive the email?',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '• Check your spam/junk folder\n• Make sure the email address is correct\n• Try resending after 60 seconds',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colors.mutedForeground,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Logout / switch account
              TextButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout, size: 18, color: colors.mutedForeground),
                label: Text(
                  'Sign out & use a different account',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(AppColorsExtension colors, String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.labelSmall.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.foreground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getProjectDomain() {
    // Firebase sends from noreply@PROJECT_ID.firebaseapp.com
    return 'skill-share-aa449.firebaseapp.com';
  }
}
