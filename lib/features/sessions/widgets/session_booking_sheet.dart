import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/data/models/create_session_dto.dart';
import 'package:skill_exchange/features/sessions/providers/session_provider.dart';

class SessionBookingSheet extends ConsumerStatefulWidget {
  const SessionBookingSheet({
    super.key,
    required this.participantId,
    required this.participantName,
  });

  final String participantId;
  final String participantName;

  @override
  ConsumerState<SessionBookingSheet> createState() =>
      _SessionBookingSheetState();
}

class _SessionBookingSheetState extends ConsumerState<SessionBookingSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillController = TextEditingController();

  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;
  int _duration = 60;
  String _sessionMode = 'online';
  final List<String> _skillsToCover = [];
  bool _isBooking = false;

  static const _durationOptions = [30, 60, 90, 120, 180];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  // ── Date / Time pickers ─────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _scheduledDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _scheduledDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _scheduledTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      setState(() => _scheduledTime = picked);
    }
  }

  // ── Skills chip input ───────────────────────────────────────────────────

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skillsToCover.contains(skill)) {
      setState(() {
        _skillsToCover.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() => _skillsToCover.remove(skill));
  }

  // ── Submit ──────────────────────────────────────────────────────────────

  Future<void> _bookSession() async {
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a session title.');
      return;
    }
    if (_scheduledDate == null || _scheduledTime == null) {
      _showError('Please select a date and time.');
      return;
    }

    setState(() => _isBooking = true);

    final scheduledAt = DateTime(
      _scheduledDate!.year,
      _scheduledDate!.month,
      _scheduledDate!.day,
      _scheduledTime!.hour,
      _scheduledTime!.minute,
    );

    final dto = CreateSessionDto(
      participantId: widget.participantId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      skillsToCover: _skillsToCover,
      scheduledAt: scheduledAt.toIso8601String(),
      duration: _duration,
      sessionMode: _sessionMode,
      meetingPlatform: _sessionMode == 'online' ? 'In-App Call' : null,
      meetingLink: null,
      location: _sessionMode == 'offline'
          ? _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim()
          : null,
    );

    try {
      await ref.read(sessionsNotifierProvider.notifier).createSession(dto);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Session booked with ${widget.participantName}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isBooking = false);
        _showError('Failed to book session: $e');
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
    final isOnline = _sessionMode == 'online';

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
              'Book Session with ${widget.participantName}',
              style: AppTextStyles.h4.copyWith(color: context.colors.foreground),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Session title ──
            AppTextField(
              label: 'Title',
              hint: 'e.g. Flutter State Management Basics',
              controller: _titleController,
              enabled: !_isBooking,
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Description ──
            AppTextField(
              label: 'Description',
              hint: 'What will be covered in this session?',
              controller: _descriptionController,
              maxLines: 3,
              enabled: !_isBooking,
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Date & Time ──
            Text(
              'Schedule',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: _DateTimeChip(
                    icon: Icons.calendar_today,
                    label: _scheduledDate != null
                        ? DateFormat.yMMMd().format(_scheduledDate!)
                        : 'Pick date',
                    onTap: _isBooking ? null : _pickDate,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _DateTimeChip(
                    icon: Icons.access_time,
                    label: _scheduledTime != null
                        ? _scheduledTime!.format(context)
                        : 'Pick time',
                    onTap: _isBooking ? null : _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Duration ──
            Text(
              'Duration',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<int>(
              initialValue: _duration,
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
              onChanged: _isBooking
                  ? null
                  : (value) {
                      if (value != null) setState(() => _duration = value);
                    },
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Session mode toggle ──
            Text(
              'Session Mode',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                _ModeToggle(
                  label: 'Online',
                  icon: Icons.videocam_outlined,
                  isSelected: isOnline,
                  onTap: _isBooking
                      ? null
                      : () => setState(() => _sessionMode = 'online'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _ModeToggle(
                  label: 'Offline',
                  icon: Icons.location_on_outlined,
                  isSelected: !isOnline,
                  onTap: _isBooking
                      ? null
                      : () => setState(() => _sessionMode = 'offline'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Online info ──
            if (isOnline) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.input),
                ),
                child: Row(
                  children: [
                    Icon(Icons.videocam, size: 18, color: context.colors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Session will use in-app video call',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.inputGap),
            ],

            // ── Offline field ──
            if (!isOnline) ...[
              AppTextField(
                label: 'Location',
                hint: 'e.g. Coffee Shop, Library, Office',
                controller: _locationController,
                enabled: !_isBooking,
              ),
              const SizedBox(height: AppSpacing.inputGap),
            ],

            // ── Skills to cover ──
            Text(
              'Skills to Cover',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hint: 'Add a skill...',
                    controller: _skillController,
                    enabled: !_isBooking,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: _isBooking ? null : _addSkill,
                  icon: const Icon(Icons.add_circle_outline),
                  color: context.colors.primary,
                ),
              ],
            ),
            if (_skillsToCover.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _skillsToCover.map((skill) {
                  return Chip(
                    label: Text(
                      skill,
                      style: AppTextStyles.labelSmall,
                    ),
                    onDeleted: _isBooking ? null : () => _removeSkill(skill),
                    deleteIconColor: context.colors.mutedForeground,
                    backgroundColor: context.colors.muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),

            // ── Actions ──
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: 'Cancel',
                    onPressed:
                        _isBooking ? null : () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.primary(
                    label: 'Book Session',
                    icon: Icons.calendar_month,
                    isLoading: _isBooking,
                    onPressed: _bookSession,
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

// ── Private helper widgets ────────────────────────────────────────────────

class _DateTimeChip extends StatelessWidget {
  const _DateTimeChip({
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

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.input),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border.all(
              color: isSelected ? context.colors.primary : context.colors.input,
            ),
            borderRadius: BorderRadius.circular(AppRadius.input),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? context.colors.primary : context.colors.mutedForeground,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
