import 'package:flutter/material.dart';
import 'package:skill_exchange/core/extensions/date_extensions.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, this.onCallBack});

  final Map<String, dynamic> message;
  final VoidCallback? onCallBack;

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
    final callDuration = message['callDuration'] as int? ?? 0;
    final durationStr = callDuration > 0
        ? '${(callDuration ~/ 60).toString().padLeft(2, '0')}:${(callDuration % 60).toString().padLeft(2, '0')}'
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Call icon in circle
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (_callConnected ? colors.success : colors.destructive)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _callConnected ? Icons.call_made : Icons.call_missed,
              size: 18,
              color: _callConnected ? colors.success : colors.destructive,
            ),
          ),
          const SizedBox(width: 12),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video Call',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _callConnected
                      ? (_isMine ? 'Outgoing' : 'Incoming') +
                          (durationStr != null ? ' · $durationStr' : '')
                      : (_isMine ? 'Outgoing · No answer' : 'Missed call'),
                  style: AppTextStyles.caption.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          // Time + call-back button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formattedTime,
                style: AppTextStyles.caption.copyWith(
                  color: colors.mutedForeground,
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 4),
              if (onCallBack != null)
                GestureDetector(
                  onTap: onCallBack,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.videocam,
                      size: 16,
                      color: colors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
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
