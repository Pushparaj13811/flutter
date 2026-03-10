import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.rating,
    this.size = 20,
    this.interactive = false,
    this.onRatingChanged,
  });

  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onRatingChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: 'Rating: ${rating.toStringAsFixed(1)} out of 5',
      excludeSemantics: true,
      child: RatingBar.builder(
      initialRating: rating,
      minRating: 0,
      itemCount: 5,
      allowHalfRating: true,
      itemSize: size,
      ignoreGestures: !interactive,
      unratedColor: colors.starEmpty,
      itemBuilder: (context, index) => Icon(
        Icons.star_rounded,
        color: colors.starFilled,
      ),
      onRatingUpdate: (value) {
        if (interactive) {
          onRatingChanged?.call(value);
        }
      },
      ),
    );
  }
}
