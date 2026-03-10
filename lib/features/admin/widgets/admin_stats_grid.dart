import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';

class AdminStatsGrid extends ConsumerWidget {
  const AdminStatsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(platformStatsProvider);

    return statsAsync.when(
      loading: () => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.4,
        children: const [
          SkeletonCard(height: 80),
          SkeletonCard(height: 80),
          SkeletonCard(height: 80),
          SkeletonCard(height: 80),
        ],
      ),
      error: (e, _) => ErrorMessage(
        message: 'Could not load platform stats.',
        onRetry: () => ref.invalidate(platformStatsProvider),
      ),
      data: (stats) {
        final items = [
          _AdminStatItem(
            icon: Icons.people_outline,
            value: stats.totalUsers.toString(),
            label: 'Total Users',
            color: context.colors.primary,
          ),
          _AdminStatItem(
            icon: Icons.calendar_today,
            value: stats.totalSessions.toString(),
            label: 'Active Sessions',
            color: context.colors.success,
          ),
          _AdminStatItem(
            icon: Icons.school_outlined,
            value: stats.totalPosts.toString(),
            label: 'Total Skills',
            color: context.colors.secondary,
          ),
          _AdminStatItem(
            icon: Icons.flag_outlined,
            value: stats.pendingReports.toString(),
            label: 'Reports Pending',
            color: stats.pendingReports > 0
                ? context.colors.destructive
                : context.colors.success,
          ),
        ];

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.4,
          children: items
              .map((item) => _AdminStatCard(item: item))
              .toList(),
        );
      },
    );
  }
}

class _AdminStatItem {
  const _AdminStatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
}

class _AdminStatCard extends StatelessWidget {
  const _AdminStatCard({required this.item});

  final _AdminStatItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 24,
            color: item.color,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.value,
            style: AppTextStyles.h3.copyWith(
              color: context.colors.foreground,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.label,
            style: AppTextStyles.caption.copyWith(
              color: context.colors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
