import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';

class SearchBarWidget extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    this.hint,
    this.controller,
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const borderRadius = BorderRadius.all(Radius.circular(AppRadius.input));

    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint ?? 'Search...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: onClear != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onClear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.input),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.input),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colors.ring, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
