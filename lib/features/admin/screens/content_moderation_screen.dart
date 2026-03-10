import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/data/models/user_report_model.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/report_card.dart';

// ── Filter State ──────────────────────────────────────────────────────────

enum ReportStatusFilter { all, pending, resolved, dismissed }

final reportStatusFilterProvider =
    StateProvider<ReportStatusFilter>((_) => ReportStatusFilter.all);

// ── Screen ────────────────────────────────────────────────────────────────

class ContentModerationScreen extends ConsumerWidget {
  const ContentModerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusFilter = ref.watch(reportStatusFilterProvider);
    final reportsAsync = ref.watch(reportedContentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Moderation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(reportedContentProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.md,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ReportStatusFilter.values.map((filter) {
                  final isSelected = statusFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(_filterLabel(filter)),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .read(reportStatusFilterProvider.notifier)
                            .state = filter;
                      },
                      selectedColor:
                          context.colors.primary.withValues(alpha: 0.1),
                      checkmarkColor: context.colors.primary,
                      labelStyle: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.mutedForeground,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? context.colors.primary
                            : context.colors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Reports list
          Expanded(
            child: reportsAsync.when(
              loading: () => _buildLoadingSkeleton(),
              error: (e, _) => Center(
                child: ErrorMessage(
                  message: 'Could not load reports.',
                  onRetry: () => ref.invalidate(reportedContentProvider),
                ),
              ),
              data: (reports) {
                final filtered = _applyFilter(reports, statusFilter);

                if (filtered.isEmpty) {
                  return _buildEmptyState(statusFilter);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(reportedContentProvider);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.listItemGap),
                    itemBuilder: (context, index) {
                      final report = filtered[index];
                      return ReportCard(
                        report: report,
                        onResolve: () => _handleResolve(ref, report),
                        onDismiss: () => _handleDismiss(ref, report),
                        onDeleteContent: () =>
                            _handleDeleteContent(context, ref, report),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _filterLabel(ReportStatusFilter filter) {
    return switch (filter) {
      ReportStatusFilter.all => 'All',
      ReportStatusFilter.pending => 'Pending',
      ReportStatusFilter.resolved => 'Resolved',
      ReportStatusFilter.dismissed => 'Dismissed',
    };
  }

  List<UserReportModel> _applyFilter(
    List<UserReportModel> reports,
    ReportStatusFilter filter,
  ) {
    if (filter == ReportStatusFilter.all) return reports;
    final statusString = switch (filter) {
      ReportStatusFilter.pending => 'pending',
      ReportStatusFilter.resolved => 'resolved',
      ReportStatusFilter.dismissed => 'dismissed',
      ReportStatusFilter.all => '',
    };
    return reports.where((r) => r.status == statusString).toList();
  }

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      itemCount: 4,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard(height: 160),
    );
  }

  Widget _buildEmptyState(ReportStatusFilter filter) {
    final message = switch (filter) {
      ReportStatusFilter.all => 'No reports found.',
      ReportStatusFilter.pending => 'No pending reports. All clear!',
      ReportStatusFilter.resolved => 'No resolved reports.',
      ReportStatusFilter.dismissed => 'No dismissed reports.',
    };

    final icon = switch (filter) {
      ReportStatusFilter.all => Icons.inbox_outlined,
      ReportStatusFilter.pending => Icons.check_circle_outline,
      ReportStatusFilter.resolved => Icons.task_alt,
      ReportStatusFilter.dismissed => Icons.cancel_outlined,
    };

    return Center(
      child: EmptyState(
        icon: icon,
        title: message,
      ),
    );
  }

  Future<void> _handleResolve(WidgetRef ref, UserReportModel report) async {
    await ref
        .read(adminNotifierProvider.notifier)
        .resolveReport(report.id, 'resolved');
  }

  Future<void> _handleDismiss(WidgetRef ref, UserReportModel report) async {
    await ref
        .read(adminNotifierProvider.notifier)
        .resolveReport(report.id, 'dismissed');
  }

  Future<void> _handleDeleteContent(
    BuildContext context,
    WidgetRef ref,
    UserReportModel report,
  ) async {
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
  }
}
