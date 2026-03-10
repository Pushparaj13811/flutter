import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/core/theme/app_spacing.dart';
import 'package:skill_exchange/core/theme/app_text_styles.dart';
import 'package:skill_exchange/core/widgets/error_message.dart';
import 'package:skill_exchange/core/widgets/skeleton_card.dart';
import 'package:skill_exchange/features/admin/providers/admin_provider.dart';
import 'package:skill_exchange/features/admin/widgets/admin_skill_tile.dart';
import 'package:skill_exchange/features/admin/widgets/skill_form_sheet.dart';

class SkillsManagementScreen extends ConsumerStatefulWidget {
  const SkillsManagementScreen({super.key});

  @override
  ConsumerState<SkillsManagementScreen> createState() =>
      _SkillsManagementScreenState();
}

class _SkillsManagementScreenState
    extends ConsumerState<SkillsManagementScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final skillsAsync = ref.watch(adminSkillsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminSkillsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSkillSheet(context),
        child: const Icon(Icons.add),
      ),
      body: skillsAsync.when(
        loading: () => _buildLoading(),
        error: (e, _) => Center(
          child: ErrorMessage(
            message: 'Could not load skills.',
            onRetry: () => ref.invalidate(adminSkillsProvider),
          ),
        ),
        data: (skills) {
          // Collect categories
          final categories =
              skills.map((s) => s.category).toSet().toList()..sort();

          // Filter
          var filtered = skills;
          if (_searchQuery.isNotEmpty) {
            filtered = filtered
                .where((s) =>
                    s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
          }
          if (_selectedCategory != null) {
            filtered = filtered
                .where((s) => s.category == _selectedCategory)
                .toList();
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(adminSkillsProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                // Search bar
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search skills...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Category filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = null),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ...categories.map(
                        (cat) => Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat,
                            onSelected: (_) => setState(
                              () => _selectedCategory =
                                  _selectedCategory == cat ? null : cat,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Results count
                Text(
                  '${filtered.length} skills',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Skills list
                ...filtered.map(
                  (skill) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppSpacing.listItemGap,
                    ),
                    child: AdminSkillTile(
                      skill: skill,
                      onToggleActive: () => ref
                          .read(adminNotifierProvider.notifier)
                          .updateSkill(skill.id, {
                        'isActive': !skill.isActive,
                      }),
                      onDelete: () => ref
                          .read(adminNotifierProvider.notifier)
                          .deleteSkill(skill.id),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddSkillSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SkillFormSheet(),
    );
    if (result != null && mounted) {
      ref.read(adminNotifierProvider.notifier).createSkill(result);
    }
  }

  Widget _buildLoading() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: const [
        SkeletonCard(height: 48),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 80),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 80),
        SizedBox(height: AppSpacing.md),
        SkeletonCard(height: 80),
      ],
    );
  }
}
