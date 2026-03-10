// New user registration with password strength

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
import 'package:skill_exchange/features/auth/widgets/google_oauth_button.dart';
import 'package:skill_exchange/features/auth/widgets/password_strength_indicator.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const routeName = '/signup';

  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Tracks the live password text so PasswordStrengthIndicator can react.
  String _passwordText = '';
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Sign-up action ────────────────────────────────────────────────────────

  Future<void> _onSignup() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service to continue.'),
        ),
      );
      return;
    }

    await ref.read(authProvider.notifier).signup(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // React to auth state changes: errors and successful authentication.
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: context.colors.destructive,
          ),
        );
      } else if (next is AuthAuthenticated) {
        // Navigate away on successful signup.  Using pushNamedAndRemoveUntil so
        // the user cannot press Back to return to the signup flow.
        context.go('/dashboard');
      }
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthAuthenticating;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Title ───────────────────────────────────────────────────
              Text(
                'Skill Exchange',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(color: context.colors.foreground),
              ),
              const SizedBox(height: AppSpacing.sm),

              // ── Subtitle ────────────────────────────────────────────────
              Text(
                'Create your account',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Form ────────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Full Name
                    _FormField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      validator: (v) => Validators.required(v, 'Name'),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Email
                    _FormField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password
                    _FormField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Create a password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: Validators.password,
                      onChanged: (value) =>
                          setState(() => _passwordText = value),
                    ),

                    // Password strength indicator sits between password and
                    // confirm-password without an extra SizedBox above it
                    // (the indicator widget owns its own top spacing).
                    PasswordStrengthIndicator(password: _passwordText),
                    const SizedBox(height: AppSpacing.lg),

                    // Confirm Password
                    _FormField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) =>
                          Validators.confirmPassword(v, _passwordController.text),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Terms checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          activeColor: context.colors.primary,
                          onChanged: isLoading
                              ? null
                              : (value) => setState(
                                    () => _agreedToTerms = value ?? false,
                                  ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: isLoading
                                ? null
                                : () => setState(
                                      () => _agreedToTerms = !_agreedToTerms,
                                    ),
                            child: Text(
                              'I agree to the Terms of Service',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: context.colors.foreground,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Sign Up button
                    AppButton.primary(
                      label: 'Sign Up',
                      isLoading: isLoading,
                      onPressed: _agreedToTerms ? _onSignup : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // "Or continue with" divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text(
                            'Or continue with',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.colors.mutedForeground,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Google OAuth
                    const GoogleOAuthButton(),
                    const SizedBox(height: AppSpacing.xl),

                    // Navigate to login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.colors.mutedForeground,
                          ),
                        ),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => context.go('/'),
                          child: Text(
                            'Login',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private helper widget ─────────────────────────────────────────────────────
//
// Wraps AppTextField in a FormField so the Form can validate it.  Using a
// separate stateless widget keeps the build method clean.

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      validator: (_) => validator(controller.text),
      builder: (field) {
        return AppTextField(
          controller: controller,
          label: label,
          hint: hint,
          prefixIcon: Icon(
            prefixIcon,
            size: 20,
            color: context.colors.mutedForeground,
          ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          errorText: field.errorText,
          onChanged: (value) {
            field.didChange(value);
            onChanged?.call(value);
          },
        );
      },
    );
  }
}
