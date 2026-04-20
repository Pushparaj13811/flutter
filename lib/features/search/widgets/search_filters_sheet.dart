import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/app_button.dart';
import 'package:skill_exchange/core/widgets/app_text_field.dart';
import 'package:skill_exchange/data/models/search_result_model.dart';
import 'package:skill_exchange/data/models/skill_model.dart';

class SearchFiltersSheet extends ConsumerStatefulWidget {
  const SearchFiltersSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  final SearchFiltersModel? currentFilters;
  final ValueChanged<SearchFiltersModel> onApply;

  @override
  ConsumerState<SearchFiltersSheet> createState() =>
      _SearchFiltersSheetState();
}

class _SearchFiltersSheetState extends ConsumerState<SearchFiltersSheet> {
  late final TextEditingController _skillNameController;
  late final TextEditingController _locationController;

  String? _selectedCategory;
  String? _selectedAvailability;
  double _minRating = 0;
  double _maxRating = 5;
  String? _selectedLearningStyle;

  static const List<String> _availabilityOptions = [
    'weekdays',
    'weekends',
    'evenings',
    'flexible',
  ];

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
    _skillNameController =
        TextEditingController(text: filters?.skillName ?? '');
    _locationController =
        TextEditingController(text: filters?.location ?? '');
    _selectedCategory = filters?.skillCategory;
    _selectedAvailability = filters?.availability;
    _minRating = filters?.minRating ?? 0;
    _maxRating = filters?.maxRating ?? 5;
    _selectedLearningStyle = filters?.learningStyle;
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
      SearchFiltersModel(
        skillName: skillName.isEmpty ? null : skillName,
        skillCategory: _selectedCategory,
        location: location.isEmpty ? null : location,
        availability: _selectedAvailability,
        minRating: _minRating > 0 ? _minRating : null,
        maxRating: _maxRating < 5 ? _maxRating : null,
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
      _selectedAvailability = null;
      _minRating = 0;
      _maxRating = 5;
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
            // -- Title row --
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Search Filters', style: AppTextStyles.h3),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // -- Skill name --
            AppTextField(
              label: 'Skill Name',
              hint: 'e.g. Flutter, Python',
              controller: _skillNameController,
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // -- Skill category dropdown --
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
              onChanged: (value) =>
                  setState(() => _selectedCategory = value),
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // -- Location --
            AppTextField(
              label: 'Location',
              hint: 'e.g. New York, Remote',
              controller: _locationController,
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // -- Availability dropdown --
            Text(
              'Availability',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<String>(
              initialValue: _selectedAvailability,
              decoration: const InputDecoration(
                hintText: 'Any availability',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Any availability'),
                ),
                ..._availabilityOptions.map(
                  (option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option[0].toUpperCase() + option.substring(1),
                    ),
                  ),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _selectedAvailability = value),
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // -- Rating range --
            Text(
              'Rating Range',
              style: AppTextStyles.labelMedium.copyWith(
                color: context.colors.foreground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    _minRating.toStringAsFixed(1),
                    style: AppTextStyles.labelMedium,
                  ),
                ),
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(_minRating, _maxRating),
                    min: 0,
                    max: 5,
                    divisions: 10,
                    labels: RangeLabels(
                      _minRating.toStringAsFixed(1),
                      _maxRating.toStringAsFixed(1),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minRating = values.start;
                        _maxRating = values.end;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 36,
                  child: Text(
                    _maxRating.toStringAsFixed(1),
                    style: AppTextStyles.labelMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.inputGap),

            // -- Learning style dropdown --
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

            // -- Action buttons --
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
