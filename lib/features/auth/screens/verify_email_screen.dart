import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
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
  Timer? _timer;
  bool _canResend = true;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    // Auto-check verification every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _checkVerification());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerification() async {
    await fb.FirebaseAuth.instance.currentUser?.reload();
    final isVerified = fb.FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    if (isVerified && mounted) {
      final uid = fb.FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({'isVerified': true});
      // Force auth state refresh
      final user = await ref.read(firebaseAuthServiceProvider).getCurrentUser();
      if (user != null) {
        ref.read(authProvider.notifier).refreshUser(user);
      }
    }
  }

  Future<void> _resendEmail() async {
    if (!_canResend) return;
    try {
      await fb.FirebaseAuth.instance.currentUser?.sendEmailVerification();
      setState(() {
        _canResend = false;
        _resendCooldown = 60;
      });
      // Countdown timer
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) { timer.cancel(); return; }
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
          const SnackBar(content: Text('Verification email sent!')),
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
    _timer?.cancel();
    ref.read(authProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final email = fb.FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mark_email_unread_outlined, size: 40, color: colors.primary),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Verify Your Email', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              Text(
                'We sent a verification link to',
                style: AppTextStyles.bodyMedium.copyWith(color: colors.mutedForeground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                email,
                style: AppTextStyles.labelLarge.copyWith(color: colors.foreground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Click the link in your email to verify your account. This page will update automatically.',
                style: AppTextStyles.bodySmall.copyWith(color: colors.mutedForeground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Resend button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _canResend ? _resendEmail : null,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                  ),
                  child: Text(_canResend ? 'Resend Verification Email' : 'Resend in ${_resendCooldown}s'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Check manually button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await _checkVerification();
                    if (mounted && !(fb.FirebaseAuth.instance.currentUser?.emailVerified ?? false)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email not yet verified. Please check your inbox.')),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                  ),
                  child: const Text("I've Verified My Email"),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Logout
              TextButton(
                onPressed: _logout,
                child: Text('Use a different account', style: TextStyle(color: colors.mutedForeground)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
