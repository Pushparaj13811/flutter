import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_exchange/config/di/providers.dart';
import 'package:skill_exchange/data/models/match_score_model.dart';
import 'package:skill_exchange/data/models/matching_filters_model.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

// ── Filter & Sort State ───────────────────────────────────────────────────

final matchingFiltersProvider = StateProvider<MatchingFiltersModel>((ref) {
  return const MatchingFiltersModel();
});

final matchingSortProvider = StateProvider<String>((ref) => 'compatibility');

// ── Paginated Matches Notifier ────────────────────────────────────────────

class PaginatedMatchesNotifier
    extends StateNotifier<AsyncValue<List<MatchScoreModel>>> {
  final MatchingFirestoreService _service;

  bool _hasMore = true;

  PaginatedMatchesNotifier(this._service)
      : super(const AsyncValue.loading());

  bool get hasMore => _hasMore;

  /// Resets state and loads matches.
  Future<void> fetchMatches() async {
    _hasMore = false; // Firebase service returns all at once
    state = const AsyncValue.loading();

    try {
      final data = await _service.getSuggestions();
      final matches = data.map((d) {
        final skills = (d['skillsToTeach'] as List?) ?? [];
        final learnSkills = (d['skillsToLearn'] as List?) ?? [];
        return MatchScoreModel(
          userId: d['userId'] as String,
          profile: UserProfileModel(
            id: d['userId'] as String,
            username: d['username'] as String? ?? '',
            email: '',
            fullName: d['username'] as String? ?? '',
            availability: const AvailabilityModel(),
            joinedAt: DateTime.now().toIso8601String(),
            lastActive: DateTime.now().toIso8601String(),
            stats: UserStatsModel(
              averageRating: (d['averageRating'] as num?)?.toDouble() ?? 0.0,
              sessionsCompleted:
                  (d['sessionsCompleted'] as num?)?.toInt() ?? 0,
            ),
            avatar: d['avatar'] as String?,
            location: d['location'] as String?,
            skillsToTeach: skills
                .map((s) => SkillModel(
                      id: (s as Map)['name'] as String? ?? '',
                      name: s['name'] as String? ?? '',
                      category: s['category'] as String? ?? '',
                      level: SkillLevel.values.firstWhere(
                        (l) => l.value == (s['level'] as String? ?? 'beginner'),
                        orElse: () => SkillLevel.beginner,
                      ),
                    ))
                .toList(),
            skillsToLearn: learnSkills
                .map((s) => SkillModel(
                      id: (s as Map)['name'] as String? ?? '',
                      name: s['name'] as String? ?? '',
                      category: s['category'] as String? ?? '',
                      level: SkillLevel.values.firstWhere(
                        (l) => l.value == (s['level'] as String? ?? 'beginner'),
                        orElse: () => SkillLevel.beginner,
                      ),
                    ))
                .toList(),
          ),
          compatibilityScore:
              (d['compatibilityScore'] as num?)?.toDouble() ?? 0.0,
          skillOverlapScore: (d['score'] as num?)?.toDouble() ?? 0.0,
          availabilityScore: 0.0,
          locationScore: 0.0,
          languageScore: 0.0,
          matchedSkills: const MatchedSkillsModel(),
        );
      }).toList();
      state = AsyncValue.data(matches);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// No-op since we load all at once from Firestore.
  Future<void> loadMore() async {}
}

final paginatedMatchesProvider = StateNotifierProvider<
    PaginatedMatchesNotifier, AsyncValue<List<MatchScoreModel>>>((ref) {
  final service = ref.watch(matchingFirestoreServiceProvider);
  return PaginatedMatchesNotifier(service);
});

// ── Top Matches (for Dashboard) ───────────────────────────────────────────

final topMatchesProvider =
    FutureProvider.family<List<MatchScoreModel>, int>((ref, limit) async {
  final service = ref.watch(matchingFirestoreServiceProvider);
  final data = await service.getSuggestions();
  final matches = data.map((d) {
    final skills = (d['skillsToTeach'] as List?) ?? [];
    final learnSkills = (d['skillsToLearn'] as List?) ?? [];
    return MatchScoreModel(
      userId: d['userId'] as String,
      profile: UserProfileModel(
        id: d['userId'] as String,
        username: d['username'] as String? ?? '',
        email: '',
        fullName: d['username'] as String? ?? '',
        availability: const AvailabilityModel(),
        joinedAt: DateTime.now().toIso8601String(),
        lastActive: DateTime.now().toIso8601String(),
        stats: UserStatsModel(
          averageRating: (d['averageRating'] as num?)?.toDouble() ?? 0.0,
          sessionsCompleted: (d['sessionsCompleted'] as num?)?.toInt() ?? 0,
        ),
        avatar: d['avatar'] as String?,
        location: d['location'] as String?,
        skillsToTeach: skills
            .map((s) => SkillModel(
                  id: (s as Map)['name'] as String? ?? '',
                  name: s['name'] as String? ?? '',
                  category: s['category'] as String? ?? '',
                  level: SkillLevel.values.firstWhere(
                    (l) => l.value == (s['level'] as String? ?? 'beginner'),
                    orElse: () => SkillLevel.beginner,
                  ),
                ))
            .toList(),
        skillsToLearn: learnSkills
            .map((s) => SkillModel(
                  id: (s as Map)['name'] as String? ?? '',
                  name: s['name'] as String? ?? '',
                  category: s['category'] as String? ?? '',
                  level: SkillLevel.values.firstWhere(
                    (l) => l.value == (s['level'] as String? ?? 'beginner'),
                    orElse: () => SkillLevel.beginner,
                  ),
                ))
            .toList(),
      ),
      compatibilityScore:
          (d['compatibilityScore'] as num?)?.toDouble() ?? 0.0,
      skillOverlapScore: (d['score'] as num?)?.toDouble() ?? 0.0,
      availabilityScore: 0.0,
      locationScore: 0.0,
      languageScore: 0.0,
      matchedSkills: const MatchedSkillsModel(),
    );
  }).toList();
  return matches.take(limit).toList();
});
