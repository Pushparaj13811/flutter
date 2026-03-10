import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/features/connections/providers/connections_provider.dart';

class ConnectionRequestSheet extends ConsumerStatefulWidget {
  const ConnectionRequestSheet({
    super.key,
    required this.userId,
    required this.userName,
  });

  final String userId;
  final String userName;

  @override
  ConsumerState<ConnectionRequestSheet> createState() =>
      _ConnectionRequestSheetState();
}

class _ConnectionRequestSheetState
    extends ConsumerState<ConnectionRequestSheet> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendRequest() async {
    setState(() => _isSending = true);

    try {
      await ref.read(connectionsNotifierProvider.notifier).sendRequest(
            widget.userId,
            _messageController.text.trim().isEmpty
                ? null
                : _messageController.text.trim(),
          );

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection request sent to ${widget.userName}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send request: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: context.colors.destructive,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: AppSpacing.lg + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle bar ──
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
          const SizedBox(height: AppSpacing.lg),

          // ── Title ──
          Text(
            'Connect with ${widget.userName}',
            style: AppTextStyles.h4.copyWith(color: context.colors.foreground),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add an optional message to introduce yourself.',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Message field ──
          AppTextField(
            label: 'Message (optional)',
            hint: 'Hi! I would love to connect and learn together...',
            controller: _messageController,
            maxLines: 4,
            enabled: !_isSending,
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _messageController,
              builder: (_, value, _) {
                final count = value.text.length;
                return Text(
                  '$count / 200',
                  style: AppTextStyles.caption.copyWith(
                    color: count > 200
                        ? context.colors.destructive
                        : context.colors.mutedForeground,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Actions ──
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Cancel',
                  onPressed:
                      _isSending ? null : () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _messageController,
                  builder: (_, value, _) {
                    final tooLong = value.text.length > 200;
                    return AppButton.primary(
                      label: 'Send Request',
                      isLoading: _isSending,
                      onPressed: tooLong ? null : _sendRequest,
                    );
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
