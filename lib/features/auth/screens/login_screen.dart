// Email/password login with Google OAuth — modern gradient design

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/core/theme/app_colors.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_gradients.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/utils/validators.dart';
import 'package:skill_exchange/data/seed/seed_data.dart';
import 'package:skill_exchange/features/auth/providers/auth_provider.dart';
import 'package:skill_exchange/features/auth/widgets/google_oauth_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

enum _AuthAction { none, login, google }

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isSeeding = false;
  _AuthAction _currentAction = _AuthAction.none;

  bool get _isLoginLoading => _currentAction == _AuthAction.login;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _runSeed() async {
    setState(() => _isSeeding = true);
    try {
      await SeedData.seed();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seed data created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seed failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  void _onLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _currentAction = _AuthAction.login);
    ref.read(authProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }


  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthError) {
        setState(() => _currentAction = _AuthAction.none);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: context.colors.destructive,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (next is AuthAuthenticated) {
        setState(() => _currentAction = _AuthAction.none);
        context.go('/dashboard');
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero gradient section ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + AppSpacing.xxl,
                bottom: AppSpacing.xxxl,
              ),
              decoration: BoxDecoration(
                gradient: AppGradients.heroFor(Theme.of(context).brightness),
              ),
              child: Column(
                children: [
                  // App icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primary,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Gradient text title
                  ShaderMask(
                    shaderCallback: (bounds) => AppGradients.text.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'Skill Exchange',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Welcome back',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // ── Card-style form section ───────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: context.colors.card,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email field
                      _buildLabel('Email'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.foreground,
                        ),
                        decoration: _inputDecoration(
                          context: context,
                          hint: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                        ),
                        validator: Validators.email,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Password field
                      _buildLabel('Password'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.colors.foreground,
                        ),
                        decoration: _inputDecoration(
                          context: context,
                          hint: 'Enter your password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: context.colors.mutedForeground,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        validator: Validators.password,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Remember Me + Forgot Password
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                setState(() => _rememberMe = value ?? false);
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Remember me',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: context.colors.foreground,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.go('/forgot-password'),
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Login button with gradient
                      _GradientButton(
                        label: 'Log In',
                        isLoading: _isLoginLoading,
                        onPressed: _currentAction != _AuthAction.none ? null : _onLogin,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: context.colors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Text(
                              'Or continue with',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: context.colors.mutedForeground,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: context.colors.border)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Google button
                      GoogleOAuthButton(
                        onPressed: _currentAction != _AuthAction.none
                            ? null
                            : () {
                                setState(() => _currentAction = _AuthAction.google);
                                ref.read(authProvider.notifier).signInWithGoogle();
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Sign up link ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.colors.mutedForeground,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/signup'),
                  child: Text(
                    'Sign up',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Seed data button (dev only)
            if (kDebugMode)
              TextButton.icon(
                onPressed: _isSeeding ? null : _runSeed,
                icon: _isSeeding
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.dataset_outlined, size: 18),
                label: Text(_isSeeding ? 'Seeding...' : 'Seed Test Data'),
              ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelMedium.copyWith(
        color: context.colors.foreground,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    const borderRadius = BorderRadius.all(Radius.circular(AppRadius.input));
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: context.colors.mutedForeground,
      ),
      prefixIcon: Icon(prefixIcon, size: 20, color: context.colors.mutedForeground),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: context.colors.input),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: context.colors.ring, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: context.colors.destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: context.colors.destructive, width: 2),
      ),
      errorStyle: AppTextStyles.caption.copyWith(color: context.colors.destructive),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
    );
  }
}

// ── Gradient Button ──────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    this.isLoading = false,
    this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = !isLoading && onPressed != null;
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          gradient: enabled ? AppGradients.primary : null,
          color: enabled ? null : AppColors.primary.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}

