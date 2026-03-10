// Email/password login with Google OAuth

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/utils/validators.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/features/auth/widgets/google_oauth_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  // ── Derived state ────────────────────────────────────────────────────────

  bool get _isLoading {
    return ref.watch(authProvider) is AuthAuthenticating;
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Actions ──────────────────────────────────────────────────────────────

  void _onLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  void _fillDemoCredentials() {
    _emailController.text = 'demo@skillexchange.com';
    _passwordController.text = 'Demo123!@#';
  }

  void _fillAdminCredentials() {
    _emailController.text = 'admin@skillexchange.com';
    _passwordController.text = 'Admin123!@#';
  }

  // ── Decoration helpers (mirrors AppTextField styling) ────────────────────

  static const _borderRadius = BorderRadius.all(Radius.circular(8.0));

  OutlineInputBorder _defaultBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: context.colors.input),
    );
  }

  OutlineInputBorder _focusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: context.colors.ring, width: 2),
    );
  }

  OutlineInputBorder _errorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: context.colors.destructive),
    );
  }

  OutlineInputBorder _focusedErrorBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: _borderRadius,
      borderSide: BorderSide(color: context.colors.destructive, width: 2),
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData prefixIconData,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: context.colors.mutedForeground,
      ),
      prefixIcon: Icon(prefixIconData, color: context.colors.mutedForeground),
      enabledBorder: _defaultBorder(context),
      focusedBorder: _focusedBorder(context),
      errorBorder: _errorBorder(context),
      focusedErrorBorder: _focusedErrorBorder(context),
      errorStyle: AppTextStyles.caption.copyWith(
        color: context.colors.destructive,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }

  Widget _buildLabeledFormField({
    required BuildContext context,
    required String label,
    required Widget field,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: context.colors.foreground,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        field,
      ],
    );
  }

  Widget _buildCredentialCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Tap to fill',
              style: AppTextStyles.caption.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // React to auth state changes: show errors, navigate on success.
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: context.colors.destructive,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (next is AuthAuthenticated) {
        context.go('/dashboard');
      }
    });

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
              // ── Logo / title ───────────────────────────────────────────
              Text(
                'Skill Exchange',
                style: AppTextStyles.h1.copyWith(
                  color: context.colors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Welcome back',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: context.colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Form ───────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email field
                    _buildLabeledFormField(
                      context: context,
                      label: 'Email',
                      field: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.foreground,
                        ),
                        decoration: _inputDecoration(
                          context: context,
                          hint: 'Enter your email',
                          prefixIconData: Icons.email_outlined,
                        ),
                        validator: Validators.email,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password field
                    _buildLabeledFormField(
                      context: context,
                      label: 'Password',
                      field: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.foreground,
                        ),
                        decoration: _inputDecoration(
                          context: context,
                          hint: 'Enter your password',
                          prefixIconData: Icons.lock_outline,
                        ),
                        validator: Validators.password,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Remember Me + Forgot Password
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: context.colors.primary,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'Remember Me',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.colors.foreground,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            context.go('/forgot-password');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.primary,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Login button
                    AppButton.primary(
                      label: 'Login',
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _onLogin,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Divider with "Or continue with"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: context.colors.border,
                            thickness: 1,
                          ),
                        ),
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
                        Expanded(
                          child: Divider(
                            color: context.colors.border,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Google OAuth button
                    const GoogleOAuthButton(),
                    const SizedBox(height: AppSpacing.xxl),

                    // Quick login cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildCredentialCard(
                            context: context,
                            title: 'Demo User',
                            icon: Icons.person_outline,
                            color: context.colors.primary,
                            onTap: _fillDemoCredentials,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _buildCredentialCard(
                            context: context,
                            title: 'Admin',
                            icon: Icons.admin_panel_settings_outlined,
                            color: context.colors.secondary,
                            onTap: _fillAdminCredentials,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Sign up row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.colors.mutedForeground,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/signup');
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.primary,
                            padding: const EdgeInsets.only(left: AppSpacing.xs),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign up',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: context.colors.primary,
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
