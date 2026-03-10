// Profile edit form widget

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/update_profile_dto.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';
import 'package:skill_exchange/features/profile/providers/profile_provider.dart';
import 'package:skill_exchange/features/profile/widgets/availability_grid.dart';
import 'package:skill_exchange/features/profile/widgets/skills_section.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  const ProfileEdit({
    super.key,
    required this.profile,
    required this.onCancel,
    required this.onSaved,
  });

  final UserProfileModel profile;
  final VoidCallback onCancel;
  final VoidCallback onSaved;

  @override
  ConsumerState<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  // ── Controllers ──────────────────────────────────────────────────────────

  late final TextEditingController _fullNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;
  late final TextEditingController _timezoneController;
  late final TextEditingController _interestInputController;

  // ── Mutable edit state ───────────────────────────────────────────────────

  late String _preferredLearningStyle;
  late List<SkillModel> _skillsToTeach;
  late List<SkillModel> _skillsToLearn;
  late List<String> _interests;
  late AvailabilityModel _editedAvailability;

  // ── Learning style options ───────────────────────────────────────────────

  static const List<String> _learningStyles = [
    'visual',
    'auditory',
    'kinesthetic',
    'reading',
  ];

  @override
  void initState() {
    super.initState();

    final p = widget.profile;

    _fullNameController = TextEditingController(text: p.fullName);
    _bioController = TextEditingController(text: p.bio ?? '');
    _locationController = TextEditingController(text: p.location ?? '');
    _timezoneController = TextEditingController(text: p.timezone ?? '');
    _interestInputController = TextEditingController();

    _preferredLearningStyle = _learningStyles.contains(p.preferredLearningStyle)
        ? p.preferredLearningStyle
        : 'visual';

    _skillsToTeach = List<SkillModel>.from(p.skillsToTeach);
    _skillsToLearn = List<SkillModel>.from(p.skillsToLearn);
    _interests = List<String>.from(p.interests);
    _editedAvailability = p.availability;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _timezoneController.dispose();
    _interestInputController.dispose();
    super.dispose();
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    final dto = UpdateProfileDto(
      fullName: _fullNameController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
      timezone: _timezoneController.text.trim(),
      preferredLearningStyle: _preferredLearningStyle,
      skillsToTeach: _skillsToTeach,
      skillsToLearn: _skillsToLearn,
      interests: _interests,
      availability: _editedAvailability,
    );

    final success = await ref
        .read(profileNotifierProvider.notifier)
        .updateProfile(dto);

    if (success && mounted) {
      widget.onSaved();
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  void _addInterest() {
    final text = _interestInputController.text.trim();
    if (text.isEmpty) return;
    if (_interests.contains(text)) {
      _interestInputController.clear();
      return;
    }
    setState(() {
      _interests = [..._interests, text];
      _interestInputController.clear();
    });
  }

  void _removeInterest(String interest) {
    setState(() {
      _interests = _interests.where((i) => i != interest).toList();
    });
  }

  // ── Tab pages ────────────────────────────────────────────────────────────

  Widget _buildBasicInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        AppTextField(
          label: 'Full Name',
          hint: 'Your full name',
          controller: _fullNameController,
        ),
        const SizedBox(height: AppSpacing.inputGap),
        AppTextField(
          label: 'Bio',
          hint: 'Tell others about yourself',
          controller: _bioController,
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.inputGap),
        AppTextField(
          label: 'Location',
          hint: 'City, Country',
          controller: _locationController,
        ),
        const SizedBox(height: AppSpacing.inputGap),
        AppTextField(
          label: 'Timezone',
          hint: 'e.g. UTC+5:30',
          controller: _timezoneController,
        ),
        const SizedBox(height: AppSpacing.inputGap),
        _LabeledDropdown<String>(
          label: 'Preferred Learning Style',
          value: _preferredLearningStyle,
          items: _learningStyles,
          itemLabel: (s) => _capitalize(s),
          onChanged: (val) {
            if (val != null) setState(() => _preferredLearningStyle = val);
          },
        ),
      ],
    );
  }

  Widget _buildSkillsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        SkillsSection(
          title: 'Skills to Teach',
          skills: _skillsToTeach,
          onChanged: (updated) => setState(() => _skillsToTeach = updated),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        SkillsSection(
          title: 'Skills to Learn',
          skills: _skillsToLearn,
          onChanged: (updated) => setState(() => _skillsToLearn = updated),
        ),
      ],
    );
  }

  Widget _buildInterestsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        if (_interests.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: Text('No interests added yet.'),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _interests.map((interest) {
              return Chip(
                label: Text(interest),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeInterest(interest),
              );
            }).toList(),
          ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                hint: 'Add an interest',
                controller: _interestInputController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton.primary(
              label: 'Add',
              onPressed: _interestInputController.text.trim().isNotEmpty
                  ? _addInterest
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilityTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        AvailabilityGrid(
          availability: _editedAvailability,
          readOnly: false,
          onChanged: (updated) =>
              setState(() => _editedAvailability = updated),
        ),
      ],
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final notifierState = ref.watch(profileNotifierProvider);
    final isSaving = notifierState is AsyncLoading;

    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // ── Tab bar ───────────────────────────────────────────────────────
          const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Skills'),
              Tab(text: 'Interests'),
              Tab(text: 'Availability'),
            ],
          ),

          // ── Tab content ───────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              children: [
                _buildBasicInfoTab(),
                _buildSkillsTab(),
                _buildInterestsTab(),
                _buildAvailabilityTab(),
              ],
            ),
          ),

          // ── Action buttons ────────────────────────────────────────────────
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: 'Cancel',
                    onPressed: isSaving ? null : widget.onCancel,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.primary(
                    label: 'Save',
                    isLoading: isSaving,
                    onPressed: isSaving ? null : _save,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

// ── Reusable labeled dropdown ─────────────────────────────────────────────────

class _LabeledDropdown<T> extends StatelessWidget {
  const _LabeledDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
