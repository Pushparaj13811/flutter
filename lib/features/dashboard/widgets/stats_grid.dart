import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.stats,
    this.onStatTap,
  });

  final UserStatsModel stats;
  final VoidCallback? onStatTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(
        icon: Icons.people_outline,
        value: stats.connectionsCount.toString(),
        label: 'Connections',
      ),
      _StatItem(
        icon: Icons.calendar_today,
        value: stats.sessionsCompleted.toString(),
        label: 'Sessions',
      ),
      _StatItem(
        icon: Icons.rate_review_outlined,
        value: stats.reviewsReceived.toString(),
        label: 'Reviews',
      ),
      _StatItem(
        icon: Icons.star_outline,
        value: stats.averageRating.toStringAsFixed(1),
        label: 'Rating',
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
          .map(
            (item) => _StatCard(
              item: item,
              onTap: onStatTap,
            ),
          )
          .toList(),
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.item,
    this.onTap,
  });

  final _StatItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item.icon,
            size: 24,
            color: context.colors.primary,
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
          ),
        ],
      ),
    );
  }
}
