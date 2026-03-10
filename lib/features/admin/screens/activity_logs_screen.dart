import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/activity_log_tile.dart';

class ActivityLogsScreen extends ConsumerStatefulWidget {
  const ActivityLogsScreen({super.key});

  @override
  ConsumerState<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends ConsumerState<ActivityLogsScreen> {
  String? _actionFilter;

  static const _actionTypes = [
    'ban_user',
    'unban_user',
    'resolve_report',
    'hide_post',
    'pin_post',
    'delete_post',
    'feature_circle',
    'update_circle',
    'create_skill',
    'delete_skill',
    'create_announcement',
    'delete_announcement',
  ];

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(activityLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(activityLogsProvider),
          ),
        ],
      ),
      body: logsAsync.when(
        loading: () => _buildLoading(),
        error: (e, _) => Center(
          child: ErrorMessage(
            message: 'Could not load activity logs.',
            onRetry: () => ref.invalidate(activityLogsProvider),
          ),
        ),
        data: (logs) {
          var filtered = logs;
          if (_actionFilter != null) {
            filtered =
                filtered.where((l) => l.action == _actionFilter).toList();
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(activityLogsProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                // Filter dropdown
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _actionFilter,
                        decoration: const InputDecoration(
                          labelText: 'Filter by action',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All actions'),
                          ),
                          ..._actionTypes.map(
                            (a) => DropdownMenuItem(
                              value: a,
                              child: Text(
                                a.replaceAll('_', ' '),
                              ),
                            ),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _actionFilter = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                Text(
                  '${filtered.length} entries',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.md),

                if (filtered.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Text('No matching log entries.'),
                    ),
                  )
                else
                  ...filtered.map(
                    (log) => ActivityLogTile(log: log),
                  ),
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
        SkeletonCard(height: 48),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 80),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 80),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 80),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 80),
      ],
    );
  }
}
