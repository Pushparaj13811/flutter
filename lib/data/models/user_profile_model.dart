import 'package:skill_exchange/data/models/skill_model.dart';

class UserProfileModel {
  final String id;
  final String? userId;
  final String username;
  final String email;
  final String fullName;
  final String? avatar;
  final String? coverImage;
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
  final PrivacyPreferencesModel? privacyPreferences;
  final NotificationPreferencesModel? notificationPreferences;

  const UserProfileModel({
    this.id = '',
    this.userId,
    this.username = '',
    this.email = '',
    this.fullName = '',
    this.avatar,
    this.coverImage,
    this.bio,
    this.location,
    this.timezone,
    this.languages = const [],
    this.skillsToTeach = const [],
    this.skillsToLearn = const [],
    this.interests = const [],
    this.availability = const AvailabilityModel(),
    this.preferredLearningStyle = 'visual',
    this.joinedAt = '',
    this.lastActive = '',
    this.stats = const UserStatsModel(),
    this.privacyPreferences,
    this.notificationPreferences,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String?,
      username: map['username'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? map['name'] as String? ?? '',
      avatar: map['avatar'] as String?,
      coverImage: map['coverImage'] as String?,
      bio: map['bio'] as String?,
      location: map['location'] as String?,
      timezone: map['timezone'] as String?,
      languages: (map['languages'] as List?)?.cast<String>() ?? [],
      skillsToTeach: _parseSkillsList(map['skillsToTeach']),
      skillsToLearn: _parseSkillsList(map['skillsToLearn']),
      interests: (map['interests'] as List?)?.cast<String>() ?? [],
      availability: map['availability'] is Map
          ? AvailabilityModel.fromMap(
              Map<String, dynamic>.from(map['availability'] as Map))
          : const AvailabilityModel(),
      preferredLearningStyle:
          map['preferredLearningStyle'] as String? ?? 'visual',
      joinedAt: map['joinedAt'] as String? ?? '',
      lastActive: map['lastActive'] as String? ?? '',
      stats: map['stats'] is Map
          ? UserStatsModel.fromMap(
              Map<String, dynamic>.from(map['stats'] as Map))
          : const UserStatsModel(),
      privacyPreferences: map['privacyPreferences'] is Map
          ? PrivacyPreferencesModel.fromMap(
              Map<String, dynamic>.from(map['privacyPreferences'] as Map))
          : null,
      notificationPreferences: map['notificationPreferences'] is Map
          ? NotificationPreferencesModel.fromMap(
              Map<String, dynamic>.from(map['notificationPreferences'] as Map))
          : null,
    );
  }

  /// Legacy compatibility alias
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =
      UserProfileModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'username': username,
        'email': email,
        'fullName': fullName,
        'avatar': avatar,
        'coverImage': coverImage,
        'bio': bio,
        'location': location,
        'timezone': timezone,
        'languages': languages,
        'skillsToTeach': skillsToTeach.map((s) => s.toMap()).toList(),
        'skillsToLearn': skillsToLearn.map((s) => s.toMap()).toList(),
        'interests': interests,
        'availability': availability.toMap(),
        'preferredLearningStyle': preferredLearningStyle,
        'joinedAt': joinedAt,
        'lastActive': lastActive,
        'stats': stats.toMap(),
        'privacyPreferences': privacyPreferences?.toMap(),
        'notificationPreferences': notificationPreferences?.toMap(),
      };

  UserProfileModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? email,
    String? fullName,
    String? avatar,
    String? coverImage,
    String? bio,
    String? location,
    String? timezone,
    List<String>? languages,
    List<SkillModel>? skillsToTeach,
    List<SkillModel>? skillsToLearn,
    List<String>? interests,
    AvailabilityModel? availability,
    String? preferredLearningStyle,
    String? joinedAt,
    String? lastActive,
    UserStatsModel? stats,
    PrivacyPreferencesModel? privacyPreferences,
    NotificationPreferencesModel? notificationPreferences,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
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
      joinedAt: joinedAt ?? this.joinedAt,
      lastActive: lastActive ?? this.lastActive,
      stats: stats ?? this.stats,
      privacyPreferences: privacyPreferences ?? this.privacyPreferences,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
    );
  }

  static List<SkillModel> _parseSkillsList(dynamic skills) {
    if (skills == null || skills is! List) return [];
    return skills.map((s) {
      if (s is Map) {
        return SkillModel.fromMap(Map<String, dynamic>.from(s));
      }
      return const SkillModel();
    }).toList();
  }
}

class AvailabilityModel {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  const AvailabilityModel({
    this.monday = false,
    this.tuesday = false,
    this.wednesday = false,
    this.thursday = false,
    this.friday = false,
    this.saturday = false,
    this.sunday = false,
  });

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      monday: map['monday'] as bool? ?? false,
      tuesday: map['tuesday'] as bool? ?? false,
      wednesday: map['wednesday'] as bool? ?? false,
      thursday: map['thursday'] as bool? ?? false,
      friday: map['friday'] as bool? ?? false,
      saturday: map['saturday'] as bool? ?? false,
      sunday: map['sunday'] as bool? ?? false,
    );
  }

  /// Legacy compatibility alias
  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =
      AvailabilityModel.fromMap;

  Map<String, dynamic> toMap() => {
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
      };

  AvailabilityModel copyWith({
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  }) {
    return AvailabilityModel(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }
}

class UserStatsModel {
  final int connectionsCount;
  final int sessionsCompleted;
  final int reviewsReceived;
  final double averageRating;

  const UserStatsModel({
    this.connectionsCount = 0,
    this.sessionsCompleted = 0,
    this.reviewsReceived = 0,
    this.averageRating = 0.0,
  });

  factory UserStatsModel.fromMap(Map<String, dynamic> map) {
    return UserStatsModel(
      connectionsCount: (map['connectionsCount'] as num?)?.toInt() ?? 0,
      sessionsCompleted: (map['sessionsCompleted'] as num?)?.toInt() ?? 0,
      reviewsReceived: (map['reviewsReceived'] as num?)?.toInt() ?? 0,
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Legacy compatibility alias
  factory UserStatsModel.fromJson(Map<String, dynamic> json) =
      UserStatsModel.fromMap;

  Map<String, dynamic> toMap() => {
        'connectionsCount': connectionsCount,
        'sessionsCompleted': sessionsCompleted,
        'reviewsReceived': reviewsReceived,
        'averageRating': averageRating,
      };

  UserStatsModel copyWith({
    int? connectionsCount,
    int? sessionsCompleted,
    int? reviewsReceived,
    double? averageRating,
  }) {
    return UserStatsModel(
      connectionsCount: connectionsCount ?? this.connectionsCount,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      reviewsReceived: reviewsReceived ?? this.reviewsReceived,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}

class PrivacyPreferencesModel {
  final String profileVisibility;
  final bool showEmail;
  final bool showLocation;
  final bool showOnlineStatus;
  final String allowMessages;

  const PrivacyPreferencesModel({
    this.profileVisibility = 'public',
    this.showEmail = false,
    this.showLocation = true,
    this.showOnlineStatus = true,
    this.allowMessages = 'everyone',
  });

  factory PrivacyPreferencesModel.fromMap(Map<String, dynamic> map) {
    return PrivacyPreferencesModel(
      profileVisibility: map['profileVisibility'] as String? ?? 'public',
      showEmail: map['showEmail'] as bool? ?? false,
      showLocation: map['showLocation'] as bool? ?? true,
      showOnlineStatus: map['showOnlineStatus'] as bool? ?? true,
      allowMessages: map['allowMessages'] as String? ?? 'everyone',
    );
  }

  /// Legacy compatibility alias
  factory PrivacyPreferencesModel.fromJson(Map<String, dynamic> json) =
      PrivacyPreferencesModel.fromMap;

  Map<String, dynamic> toMap() => {
        'profileVisibility': profileVisibility,
        'showEmail': showEmail,
        'showLocation': showLocation,
        'showOnlineStatus': showOnlineStatus,
        'allowMessages': allowMessages,
      };

  PrivacyPreferencesModel copyWith({
    String? profileVisibility,
    bool? showEmail,
    bool? showLocation,
    bool? showOnlineStatus,
    String? allowMessages,
  }) {
    return PrivacyPreferencesModel(
      profileVisibility: profileVisibility ?? this.profileVisibility,
      showEmail: showEmail ?? this.showEmail,
      showLocation: showLocation ?? this.showLocation,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      allowMessages: allowMessages ?? this.allowMessages,
    );
  }
}

class NotificationPreferencesModel {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool connectionRequests;
  final bool sessionReminders;
  final bool newMessages;
  final bool reviewsReceived;
  final bool marketingEmails;

  const NotificationPreferencesModel({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.connectionRequests = true,
    this.sessionReminders = true,
    this.newMessages = true,
    this.reviewsReceived = true,
    this.marketingEmails = false,
  });

  factory NotificationPreferencesModel.fromMap(Map<String, dynamic> map) {
    return NotificationPreferencesModel(
      emailNotifications: map['emailNotifications'] as bool? ?? true,
      pushNotifications: map['pushNotifications'] as bool? ?? true,
      connectionRequests: map['connectionRequests'] as bool? ?? true,
      sessionReminders: map['sessionReminders'] as bool? ?? true,
      newMessages: map['newMessages'] as bool? ?? true,
      reviewsReceived: map['reviewsReceived'] as bool? ?? true,
      marketingEmails: map['marketingEmails'] as bool? ?? false,
    );
  }

  /// Legacy compatibility alias
  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =
      NotificationPreferencesModel.fromMap;

  Map<String, dynamic> toMap() => {
        'emailNotifications': emailNotifications,
        'pushNotifications': pushNotifications,
        'connectionRequests': connectionRequests,
        'sessionReminders': sessionReminders,
        'newMessages': newMessages,
        'reviewsReceived': reviewsReceived,
        'marketingEmails': marketingEmails,
      };

  NotificationPreferencesModel copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? connectionRequests,
    bool? sessionReminders,
    bool? newMessages,
    bool? reviewsReceived,
    bool? marketingEmails,
  }) {
    return NotificationPreferencesModel(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      connectionRequests: connectionRequests ?? this.connectionRequests,
      sessionReminders: sessionReminders ?? this.sessionReminders,
      newMessages: newMessages ?? this.newMessages,
      reviewsReceived: reviewsReceived ?? this.reviewsReceived,
      marketingEmails: marketingEmails ?? this.marketingEmails,
    );
  }
}
