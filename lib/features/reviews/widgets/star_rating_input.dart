import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';

class StarRatingInput extends StatelessWidget {
  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isFilled = starValue <= rating;

        return GestureDetector(
          onTap: () => onChanged(starValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              Icons.star_rounded,
              size: 36,
              color: isFilled ? context.colors.starFilled : context.colors.starEmpty,
            ),
          ),
        );
      }),
    );
  }
}
