import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_exchange/config/router/app_router.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/admin_stats_grid.dart';
import 'package:skill_exchange/features/admin/widgets/report_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(platformStatsProvider);
              ref.invalidate(reportedContentProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(platformStatsProvider);
          ref.invalidate(reportedContentProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            // Platform stats
            const Text('Platform Overview', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.md),
            const AdminStatsGrid(),
            const SizedBox(height: AppSpacing.sectionGap),

            // Quick links
            const Text('Quick Links', style: AppTextStyles.h4),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _QuickLinkCard(
                    icon: Icons.people_outline,
                    label: 'User\nManagement',
                    color: context.colors.primary,
                    onTap: () => context.go(RouteNames.adminUsers),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _QuickLinkCard(
                    icon: Icons.shield_outlined,
                    label: 'Content\nModeration',
                    color: context.colors.secondary,
                    onTap: () => context.go(RouteNames.adminModeration),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _QuickLinkCard(
                    icon: Icons.groups_outlined,
                    label: 'Community\nMgmt',
                    color: context.colors.primary,
                    onTap: () => context.go(RouteNames.adminCommunity),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _QuickLinkCard(
                    icon: Icons.bar_chart,
                    label: 'Analytics',
                    color: context.colors.secondary,
                    onTap: () => context.go(RouteNames.adminAnalytics),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _QuickLinkCard(
                    icon: Icons.category_outlined,
                    label: 'Skills\nMgmt',
                    color: context.colors.primary,
                    onTap: () => context.go(RouteNames.adminSkills),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _QuickLinkCard(
                    icon: Icons.campaign_outlined,
                    label: 'Announce-\nments',
                    color: context.colors.secondary,
                    onTap: () => context.go(RouteNames.adminAnnouncements),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _QuickLinkCard(
              icon: Icons.history,
              label: 'Activity Logs',
              color: context.colors.primary,
              onTap: () => context.go(RouteNames.adminLogs),
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // Recent reports
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Reports', style: AppTextStyles.h4),
                TextButton(
                  onPressed: () => context.go(RouteNames.adminModeration),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _RecentReportsSection(ref: ref),
          ],
        ),
      ),
    );
  }
}

// ── Quick Link Card ───────────────────────────────────────────────────────

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: context.colors.foreground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Recent Reports Section ────────────────────────────────────────────────

class _RecentReportsSection extends StatelessWidget {
  const _RecentReportsSection({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportedContentProvider);

    return reportsAsync.when(
      loading: () => const Column(
        children: [
          SkeletonCard(height: 120),
          SizedBox(height: AppSpacing.md),
          SkeletonCard(height: 120),
        ],
      ),
      error: (e, _) => ErrorMessage(
        message: 'Could not load reports.',
        onRetry: () => ref.invalidate(reportedContentProvider),
      ),
      data: (reports) {
        if (reports.isEmpty) {
          return AppCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: context.colors.success,
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'No pending reports',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          );
        }

        // Show only the 3 most recent reports
        final recentReports = reports.take(3).toList();

        return Column(
          children: recentReports
              .map(
                (report) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppSpacing.listItemGap),
                  child: ReportCard(
                    report: report,
                    onResolve: () async {
                      await ref
                          .read(adminNotifierProvider.notifier)
                          .resolveReport(report.id, 'resolved');
                    },
                    onDismiss: () async {
                      await ref
                          .read(adminNotifierProvider.notifier)
                          .resolveReport(report.id, 'dismissed');
                    },
                    onDeleteContent: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Content'),
                          content: const Text(
                            'Are you sure you want to delete this reported content? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              style: TextButton.styleFrom(
                                foregroundColor: context.colors.destructive,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await ref
                            .read(adminNotifierProvider.notifier)
                            .deleteContent(report.id);
                      }
                    },
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
