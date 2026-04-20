import 'package:flutter/material.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/widgets/skill_tag.dart';
import 'package:skill_exchange/data/models/skill_model.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({
    super.key,
    required this.title,
    required this.skills,
    required this.onChanged,
  });

  final String title;
  final List<SkillModel> skills;
  final ValueChanged<List<SkillModel>> onChanged;

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  void _removeSkill(SkillModel skill) {
    final updated = widget.skills.where((s) => s.id != skill.id).toList();
    widget.onChanged(updated);
  }

  Future<void> _showAddSkillDialog() async {
    final nameController = TextEditingController();
    SkillCategory selectedCategory = SkillCategory.other;
    SkillLevel selectedLevel = SkillLevel.beginner;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Skill', style: AppTextStyles.h4),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skill Name',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: context.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Flutter, Python, Figma',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Category',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: context.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<SkillCategory>(
                      initialValue: selectedCategory,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      items: SkillCategory.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat.value, style: AppTextStyles.bodyMedium),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Level',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: context.colors.foreground,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    DropdownButtonFormField<SkillLevel>(
                      initialValue: selectedLevel,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      items: SkillLevel.values.map((lvl) {
                        return DropdownMenuItem(
                          value: lvl,
                          child: Text(
                            _capitalize(lvl.value),
                            style: AppTextStyles.bodyMedium,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedLevel = val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final newSkill = SkillModel(
                      id: 'tmp_${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      category: selectedCategory.value,
                      level: selectedLevel,
                    );

                    final updated = [...widget.skills, newSkill];
                    widget.onChanged(updated);
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyles.h4.copyWith(color: context.colors.foreground),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (widget.skills.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              'No skills added yet.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.mutedForeground,
              ),
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: widget.skills.map((skill) {
              return _DeletableSkillChip(
                skill: skill,
                onDelete: () => _removeSkill(skill),
              );
            }).toList(),
          ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: _showAddSkillDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Skill'),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colors.primary,
            side: BorderSide(color: context.colors.border),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}

class _DeletableSkillChip extends StatelessWidget {
  const _DeletableSkillChip({
    required this.skill,
    required this.onDelete,
  });

  final SkillModel skill;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: SkillTag(name: skill.name, level: skill.level.value),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: context.colors.destructive,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 10,
                color: context.colors.destructiveForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
