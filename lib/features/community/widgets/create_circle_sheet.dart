import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_colors_extension.dart';
import 'package:skill_exchange/core/theme/app_radius.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/features/community/providers/community_provider.dart';

class CreateCircleSheet extends ConsumerStatefulWidget {
  const CreateCircleSheet({super.key});

  @override
  ConsumerState<CreateCircleSheet> createState() => _CreateCircleSheetState();
}

class _CreateCircleSheetState extends ConsumerState<CreateCircleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillController = TextEditingController();
  final _maxMembersController = TextEditingController(text: '20');
  final List<String> _skillFocus = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _skillController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skillFocus.contains(skill)) {
      setState(() {
        _skillFocus.add(skill);
        _skillController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skillFocus.remove(skill);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final maxMembers = int.tryParse(_maxMembersController.text.trim()) ?? 20;

    final success =
        await ref.read(communityNotifierProvider.notifier).createCircle(
              _nameController.text.trim(),
              _descriptionController.text.trim(),
              _skillFocus,
              maxMembers,
            );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Learning circle created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create learning circle')),
      );
    }
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.muted,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Create Learning Circle',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Circle Name',
                  hintText: 'e.g. Flutter Study Group',
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.inputGap),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What will this circle focus on?',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.inputGap),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _skillController,
                      decoration: const InputDecoration(
                        labelText: 'Skill Focus',
                        hintText: 'Add a skill',
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _addSkill,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              if (_skillFocus.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: _skillFocus.map((skill) {
                    return Chip(
                      label: Text(skill, style: AppTextStyles.caption),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeSkill(skill),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: AppSpacing.inputGap),
              TextFormField(
                controller: _maxMembersController,
                decoration: const InputDecoration(
                  labelText: 'Max Members',
                  hintText: '20',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Max members is required';
                  }
                  final num = int.tryParse(value.trim());
                  if (num == null || num < 2) {
                    return 'Must be at least 2 members';
                  }
                  if (num > 100) {
                    return 'Cannot exceed 100 members';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.primaryForeground,
                        ),
                      )
                    : const Text('Create Circle'),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
