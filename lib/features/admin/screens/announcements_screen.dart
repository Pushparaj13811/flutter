import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/announcement_tile.dart';

class AnnouncementsScreen extends ConsumerWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(announcementsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: announcementsAsync.when(
        loading: () => _buildLoading(),
        error: (e, _) => Center(
          child: ErrorMessage(
            message: 'Could not load announcements.',
            onRetry: () => ref.invalidate(announcementsProvider),
          ),
        ),
        data: (announcements) {
          if (announcements.isEmpty) {
            return const Center(child: Text('No announcements yet.'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(announcementsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: announcements.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.listItemGap),
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Dismissible(
                  key: ValueKey(announcement.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    color: Theme.of(context).colorScheme.error,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Announcement'),
                        content: const Text(
                          'Are you sure you want to delete this announcement?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (_) {
                    ref
                        .read(adminNotifierProvider.notifier)
                        .deleteAnnouncement(announcement.id);
                  },
                  child: AnnouncementTile(
                    announcement: announcement,
                    onDelete: () => ref
                        .read(adminNotifierProvider.notifier)
                        .deleteAnnouncement(announcement.id),
                  ),
                );
              },
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
        SkeletonCard(height: 100),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 100),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 100),
      ],
    );
  }

  Future<void> _showCreateSheet(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AnnouncementFormSheet(),
    );
    if (result != null) {
      ref.read(adminNotifierProvider.notifier).createAnnouncement(result);
    }
  }
}

class _AnnouncementFormSheet extends StatefulWidget {
  const _AnnouncementFormSheet();

  @override
  State<_AnnouncementFormSheet> createState() => _AnnouncementFormSheetState();
}

class _AnnouncementFormSheetState extends State<_AnnouncementFormSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _priority = 'info';

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New Announcement', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(
              labelText: 'Body',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _priority,
            decoration: const InputDecoration(
              labelText: 'Priority',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'info', child: Text('Info')),
              DropdownMenuItem(value: 'warning', child: Text('Warning')),
              DropdownMenuItem(value: 'critical', child: Text('Critical')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _priority = v);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () {
              final title = _titleController.text.trim();
              if (title.isEmpty) return;
              Navigator.of(context).pop({
                'title': title,
                'body': _bodyController.text.trim(),
                'priority': _priority,
              });
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
