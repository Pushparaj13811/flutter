import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.showOnlineIndicator = false,
    this.heroTag,
  });

  final String? imageUrl;
  final String name;
  final double size;
  final bool showOnlineIndicator;
  final String? heroTag;

  /// Returns up to two initials: first letter of the first word and, if
  /// present, first letter of the last word.  Always uppercase.
  String get _initials {
    final List<String> words =
        name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final double indicatorSize = size * 0.25;
    final double fontSize = size * 0.35;

    Widget avatar = _buildAvatar(fontSize, colors);

    if (showOnlineIndicator) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: colors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.card,
                  width: indicatorSize * 0.2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget result = Semantics(
      label: name,
      image: true,
      excludeSemantics: true,
      child: SizedBox(width: size, height: size, child: avatar),
    );

    if (heroTag != null) {
      result = Hero(tag: heroTag!, child: result);
    }

    return result;
  }

  Widget _buildAvatar(double fontSize, AppColorsExtension colors) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    if (hasImage) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => _buildInitialsCircle(fontSize, colors),
          placeholder: (_, _) => _buildInitialsCircle(fontSize, colors),
        ),
      );
    }

    return _buildInitialsCircle(fontSize, colors);
  }

  Widget _buildInitialsCircle(double fontSize, AppColorsExtension colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.muted,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: AppTextStyles.labelMedium.copyWith(
          fontSize: fontSize,
          color: colors.mutedForeground,
          height: 1,
        ),
      ),
    );
  }
}
