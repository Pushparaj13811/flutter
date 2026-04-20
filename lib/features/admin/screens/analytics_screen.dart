import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/analytics_stat_card.dart';
import 'package:skill_exchange/features/admin/widgets/skill_popularity_bar.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(analyticsProvider),
          ),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => _buildLoading(),
        error: (e, _) => Center(
          child: ErrorMessage(
            message: 'Could not load analytics.',
            onRetry: () => ref.invalidate(analyticsProvider),
          ),
        ),
        data: (analytics) {
          final overview = analytics.overview;
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(analyticsProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                // Overview stat cards
                Text('Overview', style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.6,
                  children: [
                    AnalyticsStatCard(
                      label: 'Total Users',
                      value: '${overview.totalUsers}',
                      changeValue: '+${overview.newUsersThisWeek} this week',
                      icon: Icons.people,
                    ),
                    AnalyticsStatCard(
                      label: 'Active Users',
                      value: '${overview.activeUsers}',
                      icon: Icons.person_outline,
                    ),
                    AnalyticsStatCard(
                      label: 'Total Sessions',
                      value: '${overview.totalSessions}',
                      changeValue: '+${overview.sessionsThisWeek} this week',
                      icon: Icons.video_call_outlined,
                    ),
                    AnalyticsStatCard(
                      label: 'Completion Rate',
                      value: '${(overview.completionRate * 100).toStringAsFixed(0)}%',
                      icon: Icons.check_circle_outline,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // Popular skills
                Text('Popular Skills', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.xs),
                _SkillLegend(),
                const SizedBox(height: AppSpacing.md),
                if (analytics.popularSkills.isNotEmpty) ...[
                  ...() {
                    final maxCount = analytics.popularSkills
                        .map((s) => s.teachCount + s.learnCount)
                        .reduce((a, b) => a > b ? a : b);
                    return analytics.popularSkills.map(
                      (skill) => SkillPopularityBar(
                        skill: skill,
                        maxCount: maxCount,
                      ),
                    );
                  }(),
                ],
                const SizedBox(height: AppSpacing.sectionGap),

                // Weekly activity
                Text('Weekly Activity', style: AppTextStyles.h4),
                const SizedBox(height: AppSpacing.md),
                if (analytics.weeklyActivity.isNotEmpty)
                  _WeeklyActivityChart(activity: analytics.weeklyActivity),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: const [
        SkeletonCard(height: 160),
        SizedBox(height: AppSpacing.lg),
        SkeletonCard(height: 200),
        SizedBox(height: AppSpacing.lg),
        SkeletonCard(height: 180),
      ],
    );
  }
}

class _SkillLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Teach',
          style: AppTextStyles.caption
              .copyWith(color: colors.mutedForeground),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Learn',
          style: AppTextStyles.caption
              .copyWith(color: colors.mutedForeground),
        ),
      ],
    );
  }
}

class _WeeklyActivityChart extends StatelessWidget {
  const _WeeklyActivityChart({required this.activity});

  final List activity;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Find max value for scaling
    int maxVal = 1;
    for (final w in activity) {
      if (w.sessions > maxVal) maxVal = w.sessions;
      if (w.connections > maxVal) maxVal = w.connections;
    }

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: activity.map<Widget>((w) {
          final sessionHeight = (w.sessions / maxVal) * 120;
          final connHeight = (w.connections / maxVal) * 120;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 14,
                        height: sessionHeight.clamp(4.0, 120.0),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Container(
                        width: 14,
                        height: connHeight.clamp(4.0, 120.0),
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    w.week,
                    style: AppTextStyles.caption.copyWith(
                      color: colors.mutedForeground,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
