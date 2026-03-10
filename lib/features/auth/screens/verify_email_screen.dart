// Token-based email verification
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/loading_spinner.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';

enum _VerifyState { loading, success, error }

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  static const routeName = '/verify-email';

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  _VerifyState _verifyState = _VerifyState.loading;
  String _errorMessage = 'Verification failed. The link may have expired.';
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    // Schedule token extraction + verification after the first frame so
    // ModalRoute.of(context) is available.
    WidgetsBinding.instance.addPostFrameCallback((_) => _verifyEmail());
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    final args = ModalRoute.of(context)?.settings.arguments;

    String? token;
    if (args is String) {
      token = args;
    } else if (args is Map<String, dynamic>) {
      token = args['token'] as String?;
    }

    if (token == null || token.isEmpty) {
      setState(() {
        _verifyState = _VerifyState.error;
        _errorMessage = 'No verification token was provided.';
      });
      return;
    }

    setState(() => _verifyState = _VerifyState.loading);

    final success = await ref.read(authProvider.notifier).verifyEmail(token);

    if (!mounted) return;

    if (success) {
      setState(() => _verifyState = _VerifyState.success);
      _redirectTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          context.go('/');
        }
      });
    } else {
      setState(() {
        _verifyState = _VerifyState.error;
        _errorMessage = 'Verification failed. The link may have expired.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: switch (_verifyState) {
              _VerifyState.loading => _buildLoading(context),
              _VerifyState.success => _buildSuccess(context),
              _VerifyState.error => _buildError(context),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoadingSpinner(size: 48),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Verifying your email...',
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colors.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          color: context.colors.success,
          size: 64,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Email Verified!',
          style: AppTextStyles.h2.copyWith(color: context.colors.foreground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Your email address has been verified successfully.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colors.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Redirecting to login...',
          style: AppTextStyles.bodySmall.copyWith(
            color: context.colors.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          color: context.colors.destructive,
          size: 64,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Verification Failed',
          style: AppTextStyles.h2.copyWith(color: context.colors.foreground),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _errorMessage,
          style: AppTextStyles.bodyMedium.copyWith(
            color: context.colors.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.primary(
          label: 'Back to Login',
          onPressed: () =>
              context.go('/'),
        ),
      ],
    );
  }
}
