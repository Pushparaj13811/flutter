import 'package:skill_exchange/data/models/user_profile_model.dart';

class LearningCircleModel {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final List<String> skillFocus;
  final int membersCount;
  final int maxMembers;
  final bool isJoinedByMe;
  final String createdAt;
  final String updatedAt;
  final UserProfileModel? creator;

  const LearningCircleModel({
    this.id = '',
    this.name = '',
    this.description = '',
    this.creatorId = '',
    this.skillFocus = const [],
    this.membersCount = 0,
    this.maxMembers = 20,
    this.isJoinedByMe = false,
    this.createdAt = '',
    this.updatedAt = '',
    this.creator,
  });

  factory LearningCircleModel.fromMap(Map<String, dynamic> map) {
    return LearningCircleModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      creatorId: map['creatorId'] as String? ?? '',
      skillFocus: (map['skillFocus'] as List?)?.cast<String>() ?? [],
      membersCount: (map['membersCount'] as num?)?.toInt() ?? 0,
      maxMembers: (map['maxMembers'] as num?)?.toInt() ?? 20,
      isJoinedByMe: map['isJoinedByMe'] as bool? ?? false,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
      creator: map['creator'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['creator'] as Map))
          : null,
    );
  }

  /// Legacy compatibility alias
  factory LearningCircleModel.fromJson(Map<String, dynamic> json) =
      LearningCircleModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'creatorId': creatorId,
        'skillFocus': skillFocus,
        'membersCount': membersCount,
        'maxMembers': maxMembers,
        'isJoinedByMe': isJoinedByMe,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  LearningCircleModel copyWith({
    String? id,
    String? name,
    String? description,
    String? creatorId,
    List<String>? skillFocus,
    int? membersCount,
    int? maxMembers,
    bool? isJoinedByMe,
    String? createdAt,
    String? updatedAt,
    UserProfileModel? creator,
  }) {
    return LearningCircleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      skillFocus: skillFocus ?? this.skillFocus,
      membersCount: membersCount ?? this.membersCount,
      maxMembers: maxMembers ?? this.maxMembers,
      isJoinedByMe: isJoinedByMe ?? this.isJoinedByMe,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creator: creator ?? this.creator,
    );
  }
}

class CreateCircleDto {
  final String name;
  final String description;
  final List<String> skillFocus;
  final int maxMembers;

  const CreateCircleDto({
    this.name = '',
    this.description = '',
    this.skillFocus = const [],
    this.maxMembers = 20,
  });

  factory CreateCircleDto.fromMap(Map<String, dynamic> map) {
    return CreateCircleDto(
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      skillFocus: (map['skillFocus'] as List?)?.cast<String>() ?? [],
      maxMembers: (map['maxMembers'] as num?)?.toInt() ?? 20,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'skillFocus': skillFocus,
        'maxMembers': maxMembers,
      };
}
