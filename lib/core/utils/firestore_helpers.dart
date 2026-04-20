import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_exchange/data/models/connection_model.dart';
import 'package:skill_exchange/data/models/discussion_post_model.dart';
import 'package:skill_exchange/data/models/leaderboard_entry_model.dart';
import 'package:skill_exchange/data/models/learning_circle_model.dart';
import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

/// Converts a Firestore Timestamp (or any value) to an ISO 8601 string.
String toIsoString(dynamic value) {
  if (value == null) return DateTime.now().toIso8601String();
  if (value is String) return value;
  // Firestore Timestamp has a toDate() method
  try {
    return (value as dynamic).toDate().toIso8601String();
  } catch (_) {}
  return DateTime.now().toIso8601String();
}

// ── Connection Parsing ───────────────────────────────────────────────────

ConnectionModel parseConnection(Map<String, dynamic> d) {
  return ConnectionModel(
    id: d['id'] as String? ?? '',
    fromUserId: d['requester'] as String? ?? d['fromUserId'] as String? ?? '',
    toUserId: d['recipient'] as String? ?? d['toUserId'] as String? ?? '',
    status: _parseConnectionStatus(d['status'] as String? ?? 'pending'),
    message: d['message'] as String?,
    createdAt: toIsoString(d['createdAt']),
    updatedAt: toIsoString(d['updatedAt'] ?? d['createdAt']),
  );
}

ConnectionStatus _parseConnectionStatus(String status) {
  return switch (status) {
    'accepted' => ConnectionStatus.accepted,
    'rejected' => ConnectionStatus.rejected,
    _ => ConnectionStatus.pending,
  };
}

// ── Learning Circle Parsing ──────────────────────────────────────────────

LearningCircleModel parseCircle(Map<String, dynamic> d) {
  final members = (d['members'] as List?)?.cast<String>() ?? [];
  final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  return LearningCircleModel(
    id: d['id'] as String? ?? '',
    name: d['name'] as String? ?? '',
    description: d['description'] as String? ?? '',
    creatorId: d['createdBy'] as String? ?? d['creatorId'] as String? ?? '',
    skillFocus: (d['skillFocus'] as List?)?.cast<String>() ??
        (d['category'] != null ? [d['category'] as String] : []),
    membersCount: members.length,
    maxMembers: (d['maxMembers'] as num?)?.toInt() ?? 50,
    isJoinedByMe: members.contains(currentUid),
    createdAt: toIsoString(d['createdAt']),
    updatedAt: toIsoString(d['updatedAt'] ?? d['createdAt']),
  );
}

// ── Leaderboard Parsing ──────────────────────────────────────────────────

List<LeaderboardEntryModel> parseLeaderboard(List<Map<String, dynamic>> data) {
  final entries = <LeaderboardEntryModel>[];
  for (int i = 0; i < data.length; i++) {
    final d = data[i];
    entries.add(LeaderboardEntryModel(
      userId: d['id'] as String? ?? '',
      rank: i + 1,
      points: ((d['sessionsCompleted'] as num? ?? 0) * 10 +
              (d['averageRating'] as num? ?? 0) * 20)
          .toInt(),
      sessionsCompleted: (d['sessionsCompleted'] as num?)?.toInt() ?? 0,
      reviewsGiven: 0,
      averageRating: (d['averageRating'] as num?)?.toDouble() ?? 0.0,
    ));
  }
  return entries;
}

// ── Discussion Post Parsing ──────────────────────────────────────────────

DiscussionPostModel parseDiscussionPost(Map<String, dynamic> d) {
  final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final likedBy = (d['likedBy'] as List?)?.cast<String>() ?? [];
  return DiscussionPostModel(
    id: d['id'] as String? ?? '',
    authorId: d['author'] as String? ?? d['authorId'] as String? ?? '',
    title: d['title'] as String? ?? '',
    content: d['content'] as String? ?? '',
    tags: (d['tags'] as List?)?.cast<String>() ?? [],
    likesCount: (d['likesCount'] as num?)?.toInt() ?? 0,
    commentsCount: (d['repliesCount'] as num?)?.toInt() ??
        (d['commentsCount'] as num?)?.toInt() ??
        0,
    isLikedByMe: likedBy.contains(currentUid),
    createdAt: toIsoString(d['createdAt']),
    updatedAt: toIsoString(d['updatedAt'] ?? d['createdAt']),
  );
}

// ── Search / UserProfile Parsing from matchPool data ─────────────────────

UserProfileModel parseSearchResult(Map<String, dynamic> d) {
  return UserProfileModel(
    id: d['id'] as String? ?? '',
    username: d['username'] as String? ?? '',
    email: '',
    fullName: d['username'] as String? ?? '',
    avatar: d['avatar'] as String?,
    location: d['location'] as String?,
    availability: const AvailabilityModel(),
    joinedAt: DateTime.now().toIso8601String(),
    lastActive: DateTime.now().toIso8601String(),
    stats: UserStatsModel(
      averageRating: (d['averageRating'] as num?)?.toDouble() ?? 0.0,
      sessionsCompleted: (d['sessionsCompleted'] as num?)?.toInt() ?? 0,
    ),
    skillsToTeach: _parseSkills(d['skillsToTeach']),
    skillsToLearn: _parseSkills(d['skillsToLearn']),
  );
}

List<SkillModel> _parseSkills(dynamic skills) {
  if (skills == null || skills is! List) return [];
  return skills.map((s) {
    final m = s as Map<String, dynamic>;
    return SkillModel(
      id: m['name'] as String? ?? '',
      name: m['name'] as String? ?? '',
      category: m['category'] as String? ?? '',
      level: SkillLevel.values.firstWhere(
        (l) => l.value == (m['level'] as String? ?? 'beginner'),
        orElse: () => SkillLevel.beginner,
      ),
    );
  }).toList();
}
