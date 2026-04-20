import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

class UpdateProfileDto {
  final String? fullName;
  final String? bio;
  final String? location;
  final String? timezone;
  final List<String>? languages;
  final List<SkillModel>? skillsToTeach;
  final List<SkillModel>? skillsToLearn;
  final List<String>? interests;
  final AvailabilityModel? availability;
  final String? preferredLearningStyle;

  const UpdateProfileDto({
    this.fullName,
    this.bio,
    this.location,
    this.timezone,
    this.languages,
    this.skillsToTeach,
    this.skillsToLearn,
    this.interests,
    this.availability,
    this.preferredLearningStyle,
  });

  factory UpdateProfileDto.fromMap(Map<String, dynamic> map) {
    return UpdateProfileDto(
      fullName: map['fullName'] as String?,
      bio: map['bio'] as String?,
      location: map['location'] as String?,
      timezone: map['timezone'] as String?,
      languages: (map['languages'] as List?)?.cast<String>(),
      skillsToTeach: (map['skillsToTeach'] as List?)
          ?.map((s) => SkillModel.fromMap(Map<String, dynamic>.from(s as Map)))
          .toList(),
      skillsToLearn: (map['skillsToLearn'] as List?)
          ?.map((s) => SkillModel.fromMap(Map<String, dynamic>.from(s as Map)))
          .toList(),
      interests: (map['interests'] as List?)?.cast<String>(),
      availability: map['availability'] is Map
          ? AvailabilityModel.fromMap(
              Map<String, dynamic>.from(map['availability'] as Map))
          : null,
      preferredLearningStyle: map['preferredLearningStyle'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        if (fullName != null) 'fullName': fullName,
        if (bio != null) 'bio': bio,
        if (location != null) 'location': location,
        if (timezone != null) 'timezone': timezone,
        if (languages != null) 'languages': languages,
        if (skillsToTeach != null)
          'skillsToTeach': skillsToTeach!.map((s) => s.toMap()).toList(),
        if (skillsToLearn != null)
          'skillsToLearn': skillsToLearn!.map((s) => s.toMap()).toList(),
        if (interests != null) 'interests': interests,
        if (availability != null) 'availability': availability!.toMap(),
        if (preferredLearningStyle != null)
          'preferredLearningStyle': preferredLearningStyle,
      };

  /// Legacy compatibility alias
  Map<String, dynamic> toJson() => toMap();

  UpdateProfileDto copyWith({
    String? fullName,
    String? bio,
    String? location,
    String? timezone,
    List<String>? languages,
    List<SkillModel>? skillsToTeach,
    List<SkillModel>? skillsToLearn,
    List<String>? interests,
    AvailabilityModel? availability,
    String? preferredLearningStyle,
  }) {
    return UpdateProfileDto(
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      timezone: timezone ?? this.timezone,
      languages: languages ?? this.languages,
      skillsToTeach: skillsToTeach ?? this.skillsToTeach,
      skillsToLearn: skillsToLearn ?? this.skillsToLearn,
      interests: interests ?? this.interests,
      availability: availability ?? this.availability,
      preferredLearningStyle:
          preferredLearningStyle ?? this.preferredLearningStyle,
    );
  }
}
