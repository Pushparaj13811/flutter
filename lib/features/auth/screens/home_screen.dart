import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/core/theme/app_colors.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroSection(context),
              _buildHowItWorksSection(),
              _buildWhySection(),
              _buildStatsSection(),
              _buildTestimonialsSection(),
              _buildBottomCTA(context),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Learn Anything.\nTeach Anything.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -1.5,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Exchange skills with people worldwide.\nNo fees, just learning.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => context.go('/signup'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Get Started Free'),
                  SizedBox(width: AppSpacing.xs),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => context.go('/login'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.foreground,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTrustBadge(Icons.check_circle_outline, '100% Free'),
              const SizedBox(width: AppSpacing.lg),
              _buildTrustBadge(Icons.people_outline, '10,000+ Members'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorksSection() {
    const steps = [
      (Icons.person_add_outlined, 'Create Profile', 'Sign up and list what you want to learn and what you can teach.'),
      (Icons.search_rounded, 'Find Match', 'Get matched with compatible learning partners based on your skills.'),
      (Icons.school_outlined, 'Start Learning', 'Schedule sessions and start exchanging knowledge.'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      color: AppColors.muted,
      child: Column(
        children: [
          const Text(
            'How It Works',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...steps.indexed.map((entry) {
            final (index, step) = entry;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < steps.length - 1 ? AppSpacing.lg : 0,
              ),
              child: _buildStepCard(
                step.$1,
                step.$2,
                step.$3,
                index + 1,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStepCard(
    IconData icon,
    String title,
    String description,
    int stepNumber,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step $stepNumber: $title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhySection() {
    const benefits = [
      (Icons.monetization_on_outlined, 'Completely Free', 'No subscriptions, no hidden fees. Just pure skill exchange between passionate learners.'),
      (Icons.language_rounded, 'Global Reach', 'Connect with people from around the world. Learn languages, cultures, and skills together.'),
      (Icons.handshake_outlined, 'Fair Exchange', 'Everyone teaches, everyone learns. Build meaningful connections while growing your skills.'),
      (Icons.schedule_rounded, 'Flexible Schedule', 'Learn at your own pace. Schedule sessions that work for you and your learning partner.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          const Text(
            'Why Skill Exchange?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Learning shouldn\'t cost money.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...benefits.indexed.map((entry) {
            final (index, b) = entry;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < benefits.length - 1 ? AppSpacing.md : 0,
              ),
              child: _buildBenefitCard(b.$1, b.$2, b.$3),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(IconData icon, String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    const stats = [
      ('10K+', 'Members'),
      ('500+', 'Skills'),
      ('50K+', 'Exchanges'),
      ('4.9/5', 'Rating'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      color: AppColors.muted,
      child: Row(
        children: stats.map((stat) {
          return Expanded(
            child: Column(
              children: [
                Text(
                  stat.$1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.$2,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    const testimonials = [
      ('Sarah Chen', 'Graphic Designer', 'I learned Python while teaching design. Best decision ever. The community is amazing!'),
      ('Marcus Johnson', 'Software Developer', 'Finally found a way to learn Spanish without paying for expensive classes. Love it!'),
      ('Emily Rodriguez', 'Marketing Manager', 'The matching system is incredible. Found the perfect learning partner in my first week.'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          const Text(
            'What People Say',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...testimonials.indexed.map((entry) {
            final (index, t) = entry;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < testimonials.length - 1 ? AppSpacing.md : 0,
              ),
              child: _buildTestimonialCard(t.$1, t.$2, t.$3),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(String name, String role, String quote) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            quote,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.foreground,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary,
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: AppColors.primaryForeground,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      color: AppColors.primary,
      child: Column(
        children: [
          const Text(
            'Ready to Start Learning?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Join thousands of learners exchanging skills today.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.primaryForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => context.go('/signup'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryForeground,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Create Free Account'),
                  SizedBox(width: AppSpacing.xs),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
