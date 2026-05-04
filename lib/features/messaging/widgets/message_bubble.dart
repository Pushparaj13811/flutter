import 'package:flutter/material.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final Map<String, dynamic> message;

  bool get _isMine => message['isFromMe'] as bool? ?? false;
  bool get _isCall => message['type'] == 'call';
  bool get _callConnected => message['callConnected'] as bool? ?? false;

  String get _formattedTime {
    final raw = message['createdAt'] as String? ?? '';
    final dt = raw.toDateTimeOrNull;
    if (dt == null) return '';
    return dt.time;
  }

  bool get _read => message['read'] as bool? ?? false;
  String get _content => message['content'] as String? ?? '';

  @override
  Widget build(BuildContext context) {
    if (_isCall) return _buildCallBubble(context);
    return _buildTextBubble(context);
  }

  Widget _buildCallBubble(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: colors.muted,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _callConnected ? Icons.videocam : Icons.videocam_off,
              size: 16,
              color: _callConnected ? colors.success : colors.destructive,
            ),
            const SizedBox(width: 8),
            Text(
              _content,
              style: AppTextStyles.bodySmall.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formattedTime,
              style: AppTextStyles.caption.copyWith(
                color: colors.mutedForeground,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextBubble(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: _isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isMine ? colors.primary : colors.muted,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(_isMine ? 18 : 4),
              bottomRight: Radius.circular(_isMine ? 4 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                _isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color:
                      _isMine ? colors.primaryForeground : colors.foreground,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formattedTime,
                    style: AppTextStyles.caption.copyWith(
                      color: _isMine
                          ? colors.primaryForeground.withValues(alpha: 0.7)
                          : colors.mutedForeground,
                      fontSize: 9,
                    ),
                  ),
                  if (_isMine) ...[
                    const SizedBox(width: 3),
                    Icon(
                      _read ? Icons.done_all_rounded : Icons.done_rounded,
                      size: 13,
                      color: _read
                          ? colors.primaryForeground
                          : colors.primaryForeground.withValues(alpha: 0.6),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
