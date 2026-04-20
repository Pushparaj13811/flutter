import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/data/models/matching_filters_model.dart';
import 'package:skill_exchange/data/models/skill_model.dart';

class MatchingFiltersSheet extends StatefulWidget {
  const MatchingFiltersSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  final MatchingFiltersModel currentFilters;
  final ValueChanged<MatchingFiltersModel> onApply;

  @override
  State<MatchingFiltersSheet> createState() => _MatchingFiltersSheetState();
}

class _MatchingFiltersSheetState extends State<MatchingFiltersSheet> {
  late final TextEditingController _skillNameController;
  late final TextEditingController _locationController;

  String? _selectedCategory;
  double _minRating = 0;
  String? _selectedLearningStyle;

  static const List<String> _learningStyles = [
    'visual',
    'auditory',
    'kinesthetic',
    'reading',
  ];

  @override
  void initState() {
    super.initState();
    final filters = widget.currentFilters;
    _skillNameController = TextEditingController(text: filters.skillName ?? '');
    _locationController = TextEditingController(text: filters.location ?? '');
    _selectedCategory = filters.skillCategory;
    _minRating = filters.minRating ?? 0;
    _selectedLearningStyle = filters.learningStyle;
  }

  @override
  void dispose() {
    _skillNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final skillName = _skillNameController.text.trim();
    final location = _locationController.text.trim();

    widget.onApply(
      MatchingFiltersModel(
        skillName: skillName.isEmpty ? null : skillName,
        skillCategory: _selectedCategory,
        location: location.isEmpty ? null : location,
        minRating: _minRating > 0 ? _minRating : null,
        learningStyle: _selectedLearningStyle,
      ),
    );
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    setState(() {
      _skillNameController.clear();
      _locationController.clear();
      _selectedCategory = null;
      _minRating = 0;
      _selectedLearningStyle = null;
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Title row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: AppTextStyles.h3),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // ── Skill name ──
            AppTextField(
              label: 'Skill Name',
              hint: 'e.g. Flutter, Python',
              controller: _skillNameController,
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Skill category dropdown ──
            Text(
              'Skill Category',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                hintText: 'All categories',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All categories'),
                ),
                ...SkillCategory.values.map(
                  (cat) => DropdownMenuItem<String>(
                    value: cat.value,
                    child: Text(cat.value),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Location ──
            AppTextField(
              label: 'Location',
              hint: 'e.g. New York, Remote',
              controller: _locationController,
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Min rating slider ──
            Text(
              'Minimum Rating',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _minRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: _minRating.toStringAsFixed(1),
                    onChanged: (value) =>
                        setState(() => _minRating = value),
                  ),
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    _minRating.toStringAsFixed(1),
                    style: AppTextStyles.labelMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // ── Learning style dropdown ──
            Text(
              'Learning Style',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              initialValue: _selectedLearningStyle,
              decoration: const InputDecoration(
                hintText: 'Any style',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Any style'),
                ),
                ..._learningStyles.map(
                  (style) => DropdownMenuItem<String>(
                    value: style,
                    child: Text(
                      style[0].toUpperCase() + style.substring(1),
                    ),
                  ),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _selectedLearningStyle = value),
            ),
            const SizedBox(height: AppSpacing.sectionGap),

            // ── Action buttons ──
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: 'Reset',
                    onPressed: _resetFilters,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton.primary(
                    label: 'Apply',
                    onPressed: _applyFilters,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
