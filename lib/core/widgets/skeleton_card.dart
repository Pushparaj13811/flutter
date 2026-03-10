import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';

enum _SkeletonVariant { generic, profile, match, session, message }

class SkeletonCard extends StatelessWidget {
  final double? height;
  final double? width;
  final _SkeletonVariant _variant;

  const SkeletonCard({super.key, this.height, this.width})
      : _variant = _SkeletonVariant.generic;

  const SkeletonCard.profile({super.key})
      : height = null,
        width = null,
        _variant = _SkeletonVariant.profile;

  const SkeletonCard.match({super.key})
      : height = null,
        width = null,
        _variant = _SkeletonVariant.match;

  const SkeletonCard.session({super.key})
      : height = null,
        width = null,
        _variant = _SkeletonVariant.session;

  const SkeletonCard.message({super.key})
      : height = null,
        width = null,
        _variant = _SkeletonVariant.message;

  Widget _rect(Color color, {double? w, double? h, double radius = 4}) {
    return Container(
      width: w,
      height: h ?? 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _circle(Color color, double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildGeneric(Color color) {
    return Container(
      width: width,
      height: height ?? 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    );
  }

  Widget _buildProfile(Color c) {
    return Row(
      children: [
        _circle(c, 48),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _rect(c, w: 120),
            const SizedBox(height: AppSpacing.sm),
            _rect(c, w: 80),
          ],
        ),
      ],
    );
  }

  Widget _buildMatch(Color c) {
    return Row(
      children: [
        _circle(c, 40),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _rect(c, w: 140),
              const SizedBox(height: AppSpacing.sm),
              _rect(c, w: 100),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _rect(c, w: 48, h: 20, radius: 10),
                  const SizedBox(width: AppSpacing.sm),
                  _rect(c, w: 48, h: 20, radius: 10),
                  const SizedBox(width: AppSpacing.sm),
                  _rect(c, w: 48, h: 20, radius: 10),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSession(Color c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _rect(c, w: 100),
        const SizedBox(height: AppSpacing.sm),
        _rect(c, w: 160),
        const SizedBox(height: AppSpacing.sm),
        _rect(c, w: 80),
      ],
    );
  }

  Widget _buildMessage(Color c) {
    return Row(
      children: [
        _circle(c, 36),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _rect(c, w: 120),
            const SizedBox(height: AppSpacing.sm),
            _rect(c, w: 200),
          ],
        ),
      ],
    );
  }

  Widget _buildChild(Color c) {
    return switch (_variant) {
      _SkeletonVariant.profile => _buildProfile(c),
      _SkeletonVariant.match => _buildMatch(c),
      _SkeletonVariant.session => _buildSession(c),
      _SkeletonVariant.message => _buildMessage(c),
      _SkeletonVariant.generic => _buildGeneric(c),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Shimmer.fromColors(
      baseColor: colors.muted,
      highlightColor: colors.muted.withValues(alpha: 0.5),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: _buildChild(colors.card),
      ),
    );
  }
}
