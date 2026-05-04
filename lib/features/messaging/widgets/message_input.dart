import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.onSend,
    this.onTypingChanged,
  });

  final ValueChanged<String> onSend;
  final ValueChanged<bool>? onTypingChanged;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _canSend = false;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    if (_isTyping) {
      widget.onTypingChanged?.call(false);
    }
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _canSend) {
      setState(() => _canSend = hasText);
    }

    if (hasText) {
      if (!_isTyping) {
        _isTyping = true;
        widget.onTypingChanged?.call(true);
      }
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _isTyping = false;
        widget.onTypingChanged?.call(false);
      });
    } else {
      if (_isTyping) {
        _isTyping = false;
        _typingTimer?.cancel();
        widget.onTypingChanged?.call(false);
      }
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _typingTimer?.cancel();
    if (_isTyping) {
      _isTyping = false;
      widget.onTypingChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(
          top: BorderSide(color: colors.border, width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Camera icon (left prefix)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: colors.mutedForeground,
                  size: 22,
                ),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                splashRadius: 20,
              ),
            ),
            const SizedBox(width: 4),
            // Text field — pill shape
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                maxLines: 5,
                minLines: 1,
                onSubmitted: (_) => _handleSend(),
                style: TextStyle(color: colors.foreground, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(
                    color: colors.mutedForeground,
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: colors.muted,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: colors.ring,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send / Mic button (right)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: _canSend
                    ? GestureDetector(
                        key: const ValueKey('send'),
                        onTap: _handleSend,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.send_rounded,
                            color: colors.primaryForeground,
                            size: 18,
                          ),
                        ),
                      )
                    : IconButton(
                        key: const ValueKey('mic'),
                        onPressed: () {},
                        icon: Icon(
                          Icons.mic_none_rounded,
                          color: colors.mutedForeground,
                          size: 22,
                        ),
                        constraints:
                            const BoxConstraints(minWidth: 38, minHeight: 38),
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
