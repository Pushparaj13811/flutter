import 'package:flutter/material.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final MessageModel message;

  bool get _isMine => message.isFromMe;

  String get _formattedTime {
    final dt = message.createdAt.toDateTimeOrNull;
    if (dt == null) return '';
    return dt.time;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              _isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: _isMine ? context.colors.primary : context.colors.muted,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(_isMine ? 16 : 4),
                  bottomRight: Radius.circular(_isMine ? 4 : 16),
                ),
              ),
              child: Text(
                message.content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _isMine
                      ? context.colors.primaryForeground
                      : context.colors.foreground,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formattedTime,
                    style: AppTextStyles.caption.copyWith(
                      color: context.colors.mutedForeground,
                      fontSize: 10,
                    ),
                  ),
                  if (_isMine) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.read ? Icons.done_all : Icons.done,
                      size: 14,
                      color: message.read
                          ? context.colors.primary
                          : context.colors.mutedForeground,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
