// Block user bottom sheet

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';

class BlockUserSheet extends StatelessWidget {
  const BlockUserSheet({
    super.key,
    required this.userId,
    this.userName = 'this user',
  });

  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Block icon
          Center(
            child: Icon(
              Icons.block,
              color: context.colors.destructive,
              size: 48,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(
            'Block $userName?',
            style: AppTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),

          // Description
          Text(
            'Blocking $userName will prevent them from viewing your profile, '
            'sending you messages, or requesting sessions. '
            'They will not be notified that you blocked them.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton.destructive(
                  label: 'Block',
                  onPressed: () async {
                    try {
                      final uid =
                          FirebaseAuth.instance.currentUser!.uid;
                      final db = FirebaseFirestore.instance;
                      await db.collection('blocks').add({
                        'blocker': uid,
                        'blocked': userId,
                        'createdAt': FieldValue.serverTimestamp(),
                      });
                      // Also remove any existing connection
                      final connections = await db
                          .collection('connections')
                          .where('participants', arrayContains: uid)
                          .get();
                      for (final doc in connections.docs) {
                        final data = doc.data();
                        final participants =
                            (data['participants'] as List?)?.cast<String>() ??
                                [];
                        if (participants.contains(userId)) {
                          await doc.reference.delete();
                        }
                      }
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User blocked')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to block: $e')),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
