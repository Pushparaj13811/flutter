import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';

class LoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingSpinner({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color ?? context.colors.primary,
      ),
    );
  }
}
