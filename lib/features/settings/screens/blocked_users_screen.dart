import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  List<Map<String, dynamic>> _blockedUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() => _isLoading = true);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return;

    final db = FirebaseFirestore.instance;
    final blocks = await db.collection('blocks')
        .where('blocker', isEqualTo: uid)
        .get();

    final users = <Map<String, dynamic>>[];
    for (final doc in blocks.docs) {
      final blockedUid = doc.data()['blocked'] as String? ?? '';
      if (blockedUid.isEmpty) continue;

      final profile = await db.collection('profiles').doc(blockedUid).get();
      final userData = await db.collection('users').doc(blockedUid).get();
      final profileData = profile.data() ?? {};
      final user = userData.data() ?? {};

      users.add({
        'blockId': doc.id,
        'userId': blockedUid,
        'name': profileData['fullName'] ?? user['name'] ?? 'Unknown User',
        'avatar': profileData['avatar'] ?? user['avatar'],
        'username': profileData['username'] ?? '',
      });
    }

    if (mounted) {
      setState(() {
        _blockedUsers = users;
        _isLoading = false;
      });
    }
  }

  Future<void> _unblock(String blockId, String userName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unblock User'),
        content: Text('Unblock $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('blocks').doc(blockId).delete();
      _loadBlockedUsers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$userName unblocked')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Blocked Users')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _blockedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, size: 48, color: colors.mutedForeground),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No blocked users',
                        style: AppTextStyles.bodyMedium.copyWith(color: colors.mutedForeground),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadBlockedUsers,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    itemCount: _blockedUsers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = _blockedUsers[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        leading: UserAvatar(
                          name: user['name'] as String,
                          imageUrl: user['avatar'] as String?,
                          size: 44,
                        ),
                        title: Text(
                          user['name'] as String,
                          style: AppTextStyles.labelLarge,
                        ),
                        subtitle: user['username'] != ''
                            ? Text(
                                '@${user['username']}',
                                style: AppTextStyles.caption.copyWith(color: colors.mutedForeground),
                              )
                            : null,
                        trailing: OutlinedButton(
                          onPressed: () => _unblock(
                            user['blockId'] as String,
                            user['name'] as String,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.destructive,
                            side: BorderSide(color: colors.destructive),
                          ),
                          child: const Text('Unblock'),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
