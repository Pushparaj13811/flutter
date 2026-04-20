import 'package:skill_exchange/data/models/user_profile_model.dart';

class MatchScoreModel {
  final String userId;
  final UserProfileModel profile;
  final double compatibilityScore;
  final double skillOverlapScore;
  final double availabilityScore;
  final double locationScore;
  final double languageScore;
  final MatchedSkillsModel matchedSkills;

  const MatchScoreModel({
    this.userId = '',
    this.profile = const UserProfileModel(),
    this.compatibilityScore = 0.0,
    this.skillOverlapScore = 0.0,
    this.availabilityScore = 0.0,
    this.locationScore = 0.0,
    this.languageScore = 0.0,
    this.matchedSkills = const MatchedSkillsModel(),
  });

  factory MatchScoreModel.fromMap(Map<String, dynamic> map) {
    return MatchScoreModel(
      userId: map['userId'] as String? ?? '',
      profile: map['profile'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['profile'] as Map))
          : const UserProfileModel(),
      compatibilityScore:
          (map['compatibilityScore'] as num?)?.toDouble() ?? 0.0,
      skillOverlapScore:
          (map['skillOverlapScore'] as num?)?.toDouble() ?? 0.0,
      availabilityScore:
          (map['availabilityScore'] as num?)?.toDouble() ?? 0.0,
      locationScore: (map['locationScore'] as num?)?.toDouble() ?? 0.0,
      languageScore: (map['languageScore'] as num?)?.toDouble() ?? 0.0,
      matchedSkills: map['matchedSkills'] is Map
          ? MatchedSkillsModel.fromMap(
              Map<String, dynamic>.from(map['matchedSkills'] as Map))
          : const MatchedSkillsModel(),
    );
  }

  /// Legacy compatibility alias
  factory MatchScoreModel.fromJson(Map<String, dynamic> json) =
      MatchScoreModel.fromMap;

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'profile': profile.toMap(),
        'compatibilityScore': compatibilityScore,
        'skillOverlapScore': skillOverlapScore,
        'availabilityScore': availabilityScore,
        'locationScore': locationScore,
        'languageScore': languageScore,
        'matchedSkills': matchedSkills.toMap(),
      };

  MatchScoreModel copyWith({
    String? userId,
    UserProfileModel? profile,
    double? compatibilityScore,
    double? skillOverlapScore,
    double? availabilityScore,
    double? locationScore,
    double? languageScore,
    MatchedSkillsModel? matchedSkills,
  }) {
    return MatchScoreModel(
      userId: userId ?? this.userId,
      profile: profile ?? this.profile,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      skillOverlapScore: skillOverlapScore ?? this.skillOverlapScore,
      availabilityScore: availabilityScore ?? this.availabilityScore,
      locationScore: locationScore ?? this.locationScore,
      languageScore: languageScore ?? this.languageScore,
      matchedSkills: matchedSkills ?? this.matchedSkills,
    );
  }
}

class MatchedSkillsModel {
  final List<String> theyTeach;
  final List<String> youTeach;

  const MatchedSkillsModel({
    this.theyTeach = const [],
    this.youTeach = const [],
  });

  factory MatchedSkillsModel.fromMap(Map<String, dynamic> map) {
    return MatchedSkillsModel(
      theyTeach: (map['theyTeach'] as List?)?.cast<String>() ?? [],
      youTeach: (map['youTeach'] as List?)?.cast<String>() ?? [],
    );
  }

  /// Legacy compatibility alias
  factory MatchedSkillsModel.fromJson(Map<String, dynamic> json) =
      MatchedSkillsModel.fromMap;

  Map<String, dynamic> toMap() => {
        'theyTeach': theyTeach,
        'youTeach': youTeach,
      };
}
