import 'package:skill_exchange/data/models/skill_model.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

class UserProfile {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? avatar;
  final String? bio;
  final String? location;
  final String? timezone;
  final List<String> languages;
  final List<SkillModel> skillsToTeach;
  final List<SkillModel> skillsToLearn;
  final List<String> interests;
  final AvailabilityModel availability;
  final String preferredLearningStyle;
  final String joinedAt;
  final String lastActive;
  final UserStatsModel stats;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.avatar,
    this.bio,
    this.location,
    this.timezone,
    this.languages = const [],
    this.skillsToTeach = const [],
    this.skillsToLearn = const [],
    this.interests = const [],
    required this.availability,
    this.preferredLearningStyle = 'visual',
    required this.joinedAt,
    required this.lastActive,
    required this.stats,
  });
}
