// Password reset email request
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/core/utils/validators.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const routeName = '/forgot-password';

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _emailError;
  Timer? _redirectTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _redirectTimer?.cancel();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final email = _emailController.text.trim();
    final emailError = Validators.email(email);
    if (emailError != null) {
      setState(() => _emailError = emailError);
      return;
    }
    setState(() {
      _isLoading = true;
      _emailError = null;
    });

    final success =
        await ref.read(authProvider.notifier).forgotPassword(email);

    if (!mounted) return;

    if (success) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
      _redirectTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          context.go('/');
        }
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: _emailSent ? _buildSuccessCard(context) : _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Forgot Password',
            style: AppTextStyles.h2.copyWith(color: context.colors.foreground),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "Enter your email and we'll send you a reset link",
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20,
              color: context.colors.mutedForeground,
            ),
            errorText: _emailError,
            onChanged: (_) {
              if (_emailError != null) {
                setState(() => _emailError = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(
            label: 'Send Reset Link',
            isLoading: _isLoading,
            onPressed: _isLoading ? null : _onSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Forgot Password',
          style: AppTextStyles.h2.copyWith(color: context.colors.foreground),
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: context.colors.success.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.success.withAlpha(60)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.mark_email_read_outlined,
                color: context.colors.success,
                size: 56,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Check your email',
                style: AppTextStyles.h3.copyWith(color: context.colors.foreground),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We sent a password reset link to ${_emailController.text.trim()}',
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
          ),
        ),
      ],
    );
  }
}
