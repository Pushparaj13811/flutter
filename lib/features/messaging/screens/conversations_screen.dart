import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/empty_state.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/messaging/providers/messaging_provider.dart';
import 'package:skill_exchange/core/widgets/animated_list_item.dart';
import 'package:skill_exchange/features/messaging/screens/chat_screen.dart';
import 'package:skill_exchange/features/messaging/widgets/conversation_tile.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(conversationsStreamProvider);
    ref.invalidate(conversationsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewConversationSheet(context),
        backgroundColor: context.colors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: conversationsAsync.when(
        loading: () => _buildLoadingSkeleton(),
        error: (error, _) => Center(
          child: ErrorMessage(
            message: error.toString(),
            onRetry: () => _refresh(ref),
          ),
        ),
        data: (conversations) {
          if (conversations.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ListView(
                children: const [
                  EmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'No conversations yet',
                    description:
                        'Start a conversation with one of your connections.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: AppSpacing.screenPadding + 48 + AppSpacing.md,
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return AnimatedListItem(
                  index: index,
                  child: ConversationTile(
                    conversation: conversation,
                    onTap: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ChatScreen(conversationId: conversation['id'] as String),
                        )),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showNewConversationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _NewConversationSheet(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      itemCount: 6,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppSpacing.listItemGap),
      itemBuilder: (_, _) => const SkeletonCard.message(),
    );
  }
}

class _NewConversationSheet extends StatefulWidget {
  const _NewConversationSheet();

  @override
  State<_NewConversationSheet> createState() => _NewConversationSheetState();
}

class _NewConversationSheetState extends State<_NewConversationSheet> {
  List<Map<String, dynamic>> _connections = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    final db = FirebaseFirestore.instance;
    final snap = await db.collection('connections')
        .where('participants', arrayContains: uid)
        .where('status', isEqualTo: 'accepted')
        .get();

    final connections = <Map<String, dynamic>>[];
    for (final doc in snap.docs) {
      final data = doc.data();
      final requester = data['requester'] as String? ?? '';
      final recipient = data['recipient'] as String? ?? '';
      final otherUid = requester == uid ? recipient : requester;
      if (otherUid.isEmpty) continue;

      final profileDoc = await db.collection('profiles').doc(otherUid).get();
      final userDoc = await db.collection('users').doc(otherUid).get();
      final profile = profileDoc.data() ?? {};
      final userData = userDoc.data() ?? {};

      connections.add({
        'uid': otherUid,
        'name': profile['fullName'] ?? userData['name'] ?? 'User',
        'avatar': profile['avatar'] ?? userData['avatar'],
        'username': profile['username'] ?? '',
      });
    }

    if (mounted) setState(() { _connections = connections; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: colors.muted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('New Conversation', style: AppTextStyles.h4),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                'Select a connection to start messaging',
                style: AppTextStyles.bodySmall.copyWith(color: colors.mutedForeground),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _connections.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: Text(
                              'No connections yet. Connect with users first to start messaging.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium.copyWith(color: colors.mutedForeground),
                            ),
                          ),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          itemCount: _connections.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final conn = _connections[index];
                            final name = conn['name'] as String;
                            final avatar = conn['avatar'] as String?;
                            final otherUid = conn['uid'] as String;

                            return ListTile(
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: colors.muted,
                                backgroundImage: avatar != null && avatar.isNotEmpty
                                    ? NetworkImage(avatar)
                                    : null,
                                child: avatar == null || avatar.isEmpty
                                    ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                                        style: AppTextStyles.labelLarge)
                                    : null,
                              ),
                              title: Text(name, style: AppTextStyles.labelLarge),
                              subtitle: Text('@${conn['username'] ?? ''}',
                                  style: AppTextStyles.caption.copyWith(color: colors.mutedForeground)),
                              trailing: Icon(Icons.chat_bubble_outline, color: colors.primary, size: 20),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ChatScreen(conversationId: otherUid),
                                  ));
                              },
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }
}
