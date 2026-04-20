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
    final result = await showModalBottomSheet<SkillModel?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _AddSkillSheet(),
    );

    if (result != null) {
      final updated = [...widget.skills, result];
      widget.onChanged(updated);
    }
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

// ── Add Skill Bottom Sheet (StatefulWidget to avoid StatefulBuilder bug) ──────

class _AddSkillSheet extends StatefulWidget {
  const _AddSkillSheet();

  @override
  State<_AddSkillSheet> createState() => _AddSkillSheetState();
}

class _AddSkillSheetState extends State<_AddSkillSheet> {
  final _nameController = TextEditingController();
  SkillCategory _selectedCategory = SkillCategory.other;
  SkillLevel _selectedLevel = SkillLevel.beginner;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Add Skill', style: AppTextStyles.h3),
          const SizedBox(height: 20),

          // Skill name
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Skill Name',
              hintText: 'e.g. Flutter, Python, Figma',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category dropdown
          DropdownButtonFormField<SkillCategory>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: SkillCategory.values
                .map((c) => DropdownMenuItem(value: c, child: Text(c.value)))
                .toList(),
            onChanged: (v) => setState(() => _selectedCategory = v!),
          ),
          const SizedBox(height: 16),

          // Level dropdown
          DropdownButtonFormField<SkillLevel>(
            value: _selectedLevel,
            decoration: InputDecoration(
              labelText: 'Level',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: SkillLevel.values
                .map((l) => DropdownMenuItem(
                      value: l,
                      child: Text(l.value[0].toUpperCase() + l.value.substring(1)),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _selectedLevel = v!),
          ),
          const SizedBox(height: 24),

          // Add button
          FilledButton(
            onPressed: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.of(context).pop(SkillModel(
                id: 'tmp_${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                category: _selectedCategory.value,
                level: _selectedLevel,
              ));
            },
            child: const Text('Add Skill'),
          ),
        ],
      ),
    );
  }
}

// ── Deletable Skill Chip ─────────────────────────────────────────────────────

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
