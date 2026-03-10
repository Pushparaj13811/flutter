import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_card.dart';
import 'package:skill_exchange/core/widgets/star_rating.dart';
import 'package:skill_exchange/core/widgets/user_avatar.dart';
import 'package:skill_exchange/data/models/review_model.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
  });

  final ReviewModel review;

  String get _reviewerName =>
      review.fromUser?.fullName ?? 'Unknown User';

  String? get _reviewerAvatar => review.fromUser?.avatar;

  String get _formattedDate {
    final date = DateTime.tryParse(review.createdAt);
    if (date == null) return review.createdAt;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar, name, date
          Row(
            children: [
              UserAvatar(
                imageUrl: _reviewerAvatar,
                name: _reviewerName,
                size: 40,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _reviewerName,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: context.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    StarRating(
                      rating: review.rating.toDouble(),
                      size: 16,
                    ),
                  ],
                ),
              ),
              Text(
                _formattedDate,
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Comment
          Text(
            review.comment,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colors.foreground,
            ),
          ),

          // Skills reviewed chips
          if (review.skillsReviewed.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: review.skillsReviewed.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.muted,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    skill,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: context.colors.mutedForeground,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
