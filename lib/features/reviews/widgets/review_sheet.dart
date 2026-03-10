import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/data/models/create_review_dto.dart';
import 'package:skill_exchange/features/reviews/providers/review_provider.dart';
import 'package:skill_exchange/features/reviews/widgets/star_rating_input.dart';

class ReviewSheet extends ConsumerStatefulWidget {
  const ReviewSheet({
    super.key,
    required this.toUserId,
    required this.toUserName,
    this.sessionId,
  });

  final String toUserId;
  final String toUserName;
  final String? sessionId;

  @override
  ConsumerState<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<ReviewSheet> {
  final _commentController = TextEditingController();
  final _skillController = TextEditingController();
  int _rating = 0;
  final List<String> _skillsReviewed = [];
  String? _commentError;
  String? _ratingError;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;

    if (_rating == 0) {
      setState(() => _ratingError = 'Please select a rating');
      valid = false;
    } else {
      setState(() => _ratingError = null);
    }

    final comment = _commentController.text.trim();
    if (comment.length < 10) {
      setState(() => _commentError = 'Comment must be at least 10 characters');
      valid = false;
    } else if (comment.length > 1000) {
      setState(() => _commentError = 'Comment must be at most 1000 characters');
      valid = false;
    } else {
      setState(() => _commentError = null);
    }

    return valid;
  }

  Future<void> _submit() async {
    if (!_validate()) return;

    setState(() => _isSubmitting = true);

    final dto = CreateReviewDto(
      toUserId: widget.toUserId,
      rating: _rating,
      comment: _commentController.text.trim(),
      skillsReviewed: _skillsReviewed,
      sessionId: widget.sessionId,
    );

    final success =
        await ref.read(reviewNotifierProvider.notifier).createReview(dto);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skillsReviewed.contains(skill)) {
      setState(() {
        _skillsReviewed.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() => _skillsReviewed.remove(skill));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.muted,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'Review ${widget.toUserName}',
              style: AppTextStyles.h3.copyWith(color: context.colors.foreground),
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // Rating
            Text(
              'Rating',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            StarRatingInput(
              rating: _rating,
              onChanged: (value) => setState(() {
                _rating = value;
                _ratingError = null;
              }),
            ),
            if (_ratingError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _ratingError!,
                style: AppTextStyles.caption.copyWith(
                  color: context.colors.destructive,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.inputGap),

            // Comment
            AppTextField(
              label: 'Comment',
              hint: 'Share your experience (min 10 characters)',
              controller: _commentController,
              maxLines: 4,
              errorText: _commentError,
              onChanged: (_) {
                if (_commentError != null) {
                  setState(() => _commentError = null);
                }
              },
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // Skills reviewed
            Text(
              'Skills Reviewed',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hint: 'Add a skill',
                    controller: _skillController,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppButton.icon(
                  icon: Icons.add_rounded,
                  onPressed: _addSkill,
                  tooltip: 'Add skill',
                ),
              ],
            ),
            if (_skillsReviewed.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _skillsReviewed.map((skill) {
                  return Chip(
                    label: Text(
                      skill,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: context.colors.foreground,
                      ),
                    ),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeSkill(skill),
                    backgroundColor: context.colors.muted,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.sectionGap),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                label: 'Submit Review',
                onPressed: _isSubmitting ? null : _submit,
                isLoading: _isSubmitting,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
