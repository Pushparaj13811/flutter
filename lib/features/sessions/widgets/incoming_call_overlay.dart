import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class IncomingCallOverlay extends StatelessWidget {
  const IncomingCallOverlay({
    super.key,
    required this.callerName,
    required this.onAccept,
    required this.onDecline,
  });

  final String callerName;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white24,
              child: Text(
                callerName.isNotEmpty ? callerName[0].toUpperCase() : '?',
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              callerName,
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Incoming Video Call',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
            ),
            const Spacer(flex: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onDecline,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.call_end, color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Decline',
                        style: AppTextStyles.labelMedium.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onAccept,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.videocam, color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Accept',
                        style: AppTextStyles.labelMedium.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
