import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/network/connectivity_provider.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isOnline = ref.watch(connectivityProvider).valueOrNull ?? true;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isOnline ? 0 : 32,
          curve: Curves.easeInOut,
          child: isOnline
              ? const SizedBox.shrink()
              : Material(
                  color: colors.warning,
                  child: SafeArea(
                    bottom: false,
                    child: SizedBox(
                      height: 32,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              size: 16,
                              color: colors.foreground,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'No internet connection',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colors.foreground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
