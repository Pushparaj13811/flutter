// 7-day availability toggle grid

import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

class AvailabilityGrid extends StatelessWidget {
  const AvailabilityGrid({
    super.key,
    required this.availability,
    this.readOnly = true,
    this.onChanged,
  });

  final AvailabilityModel availability;
  final bool readOnly;
  final ValueChanged<AvailabilityModel>? onChanged;

  static const List<_DayEntry> _days = [
    _DayEntry(label: 'Mon', index: 0),
    _DayEntry(label: 'Tue', index: 1),
    _DayEntry(label: 'Wed', index: 2),
    _DayEntry(label: 'Thu', index: 3),
    _DayEntry(label: 'Fri', index: 4),
    _DayEntry(label: 'Sat', index: 5),
    _DayEntry(label: 'Sun', index: 6),
  ];

  bool _isAvailable(int index) {
    switch (index) {
      case 0:
        return availability.monday;
      case 1:
        return availability.tuesday;
      case 2:
        return availability.wednesday;
      case 3:
        return availability.thursday;
      case 4:
        return availability.friday;
      case 5:
        return availability.saturday;
      case 6:
        return availability.sunday;
      default:
        return false;
    }
  }

  AvailabilityModel _toggle(int index) {
    switch (index) {
      case 0:
        return availability.copyWith(monday: !availability.monday);
      case 1:
        return availability.copyWith(tuesday: !availability.tuesday);
      case 2:
        return availability.copyWith(wednesday: !availability.wednesday);
      case 3:
        return availability.copyWith(thursday: !availability.thursday);
      case 4:
        return availability.copyWith(friday: !availability.friday);
      case 5:
        return availability.copyWith(saturday: !availability.saturday);
      case 6:
        return availability.copyWith(sunday: !availability.sunday);
      default:
        return availability;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _days.map((day) {
        final bool available = _isAvailable(day.index);

        final Color bgColor = available
            ? context.colors.success.withValues(alpha: 0.1)
            : context.colors.muted;

        final Color textColor = available
            ? context.colors.success
            : context.colors.mutedForeground;

        final Widget tile = Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            day.label,
            style: AppTextStyles.labelSmall.copyWith(color: textColor),
          ),
        );

        if (readOnly) return tile;

        return GestureDetector(
          onTap: () => onChanged?.call(_toggle(day.index)),
          child: tile,
        );
      }).toList(),
    );
  }
}

class _DayEntry {
  const _DayEntry({required this.label, required this.index});

  final String label;
  final int index;
}
