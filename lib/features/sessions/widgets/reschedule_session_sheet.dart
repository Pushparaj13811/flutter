import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/data/models/reschedule_session_dto.dart';
import 'package:skill_exchange/features/sessions/providers/session_provider.dart';

class RescheduleSessionSheet extends ConsumerStatefulWidget {
  const RescheduleSessionSheet({
    super.key,
    required this.sessionId,
    required this.currentScheduledAt,
    required this.currentDuration,
  });

  final String sessionId;
  final String currentScheduledAt;
  final int currentDuration;

  @override
  ConsumerState<RescheduleSessionSheet> createState() =>
      _RescheduleSessionSheetState();
}

class _RescheduleSessionSheetState
    extends ConsumerState<RescheduleSessionSheet> {
  final _reasonController = TextEditingController();

  DateTime? _newDate;
  TimeOfDay? _newTime;
  late int _newDuration;
  bool _isSubmitting = false;

  static const _durationOptions = [30, 60, 90, 120, 180];

  @override
  void initState() {
    super.initState();
    _newDuration = widget.currentDuration;

    // Pre-fill with current schedule
    try {
      final current = DateTime.parse(widget.currentScheduledAt);
      _newDate = DateTime(current.year, current.month, current.day);
      _newTime = TimeOfDay(hour: current.hour, minute: current.minute);
    } catch (_) {
      // Leave null if parse fails
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  // ── Date / Time pickers ─────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _newDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _newDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _newTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      setState(() => _newTime = picked);
    }
  }

  // ── Submit ──────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (_newDate == null || _newTime == null) {
      _showError('Please select a new date and time.');
      return;
    }

    setState(() => _isSubmitting = true);

    final newScheduledAt = DateTime(
      _newDate!.year,
      _newDate!.month,
      _newDate!.day,
      _newTime!.hour,
      _newTime!.minute,
    );

    final dto = RescheduleSessionDto(
      newScheduledAt: newScheduledAt.toIso8601String(),
      newDuration: _newDuration,
      reason: _reasonController.text.trim().isEmpty
          ? null
          : _reasonController.text.trim(),
    );

    try {
      await ref
          .read(sessionsNotifierProvider.notifier)
          .rescheduleSession(widget.sessionId, dto);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session rescheduled successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showError('Failed to reschedule: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.colors.destructive,
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    String currentFormatted;
    try {
      final parsed = DateTime.parse(widget.currentScheduledAt);
      currentFormatted = DateFormat.yMMMd().add_jm().format(parsed);
    } catch (_) {
      currentFormatted = widget.currentScheduledAt;
    }

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        top: AppSpacing.lg,
        bottom: AppSpacing.lg + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle bar ──
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.muted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Title ──
            Text(
              'Reschedule Session',
              style: AppTextStyles.h4.copyWith(color: context.colors.foreground),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Currently scheduled: $currentFormatted  •  ${widget.currentDuration} min',
              style: AppTextStyles.bodySmall.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── New date & time ──
            Text(
              'New Date & Time',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _PickerChip(
                    icon: Icons.calendar_today,
                    label: _newDate != null
                        ? DateFormat.yMMMd().format(_newDate!)
                        : 'Pick date',
                    onTap: _isSubmitting ? null : _pickDate,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _PickerChip(
                    icon: Icons.access_time,
                    label: _newTime != null
                        ? _newTime!.format(context)
                        : 'Pick time',
                    onTap: _isSubmitting ? null : _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── New duration ──
            Text(
              'New Duration',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<int>(
              initialValue: _newDuration,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                  borderSide: BorderSide(color: context.colors.input),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              items: _durationOptions
                  .map(
                    (d) => DropdownMenuItem(
                      value: d,
                      child: Text('$d min'),
                    ),
                  )
                  .toList(),
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      if (value != null) setState(() => _newDuration = value);
                    },
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Reason ──
            AppTextField(
              label: 'Reason (optional)',
              hint: 'Why are you rescheduling?',
              controller: _reasonController,
              maxLines: 3,
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Actions ──
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: 'Cancel',
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.primary(
                    label: 'Reschedule',
                    icon: Icons.schedule,
                    isLoading: _isSubmitting,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private helper widget ─────────────────────────────────────────────────

class _PickerChip extends StatelessWidget {
  const _PickerChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.input),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.input),
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: context.colors.mutedForeground),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: context.colors.foreground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
