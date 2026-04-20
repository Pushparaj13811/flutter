import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';

class SkillFormSheet extends StatefulWidget {
  const SkillFormSheet({super.key});

  @override
  State<SkillFormSheet> createState() => _SkillFormSheetState();
}

class _SkillFormSheetState extends State<SkillFormSheet> {
  final _nameController = TextEditingController();
  String _selectedCategory = 'Programming';

  static const _categories = [
    'Programming',
    'Frontend',
    'Backend',
    'Mobile',
    'Cloud',
    'DevOps',
    'Design',
    'Data Science',
    'Blockchain',
    'Security',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add New Skill', style: AppTextStyles.h3),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Skill Name',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.of(context).pop({
                'name': name,
                'category': _selectedCategory,
              });
            },
            child: const Text('Create Skill'),
          ),
        ],
      ),
    );
  }
}
