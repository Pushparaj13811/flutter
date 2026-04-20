import 'package:skill_exchange/data/models/user_profile_model.dart';

enum SessionStatus {
  scheduled('scheduled'),
  completed('completed'),
  cancelled('cancelled');

  const SessionStatus(this.value);
  final String value;

  static SessionStatus fromString(String s) {
    return SessionStatus.values.firstWhere(
      (e) => e.value == s,
      orElse: () => SessionStatus.scheduled,
    );
  }
}

class SessionModel {
  final String id;
  final String hostId;
  final String participantId;
  final String title;
  final String description;
  final List<String> skillsToCover;
  final String scheduledAt;
  final int duration;
  final SessionStatus status;
  final String sessionMode;
  final String? meetingPlatform;
  final String? meetingLink;
  final String? location;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final UserProfileModel? host;
  final UserProfileModel? participant;

  const SessionModel({
    this.id = '',
    this.hostId = '',
    this.participantId = '',
    this.title = '',
    this.description = '',
    this.skillsToCover = const [],
    this.scheduledAt = '',
    this.duration = 60,
    this.status = SessionStatus.scheduled,
    this.sessionMode = 'online',
    this.meetingPlatform,
    this.meetingLink,
    this.location,
    this.notes,
    this.createdAt = '',
    this.updatedAt = '',
    this.host,
    this.participant,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] as String? ?? '',
      hostId: map['hostId'] as String? ?? '',
      participantId: map['participantId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      skillsToCover: (map['skillsToCover'] as List?)?.cast<String>() ?? [],
      scheduledAt: map['scheduledAt'] as String? ?? '',
      duration: (map['duration'] as num?)?.toInt() ?? 60,
      status: SessionStatus.fromString(map['status'] as String? ?? 'scheduled'),
      sessionMode: map['sessionMode'] as String? ?? 'online',
      meetingPlatform: map['meetingPlatform'] as String?,
      meetingLink: map['meetingLink'] as String?,
      location: map['location'] as String?,
      notes: map['notes'] as String?,
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
      host: map['host'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['host'] as Map))
          : null,
      participant: map['participant'] is Map
          ? UserProfileModel.fromMap(
              Map<String, dynamic>.from(map['participant'] as Map))
          : null,
    );
  }

  /// Legacy compatibility alias
  factory SessionModel.fromJson(Map<String, dynamic> json) =
      SessionModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'hostId': hostId,
        'participantId': participantId,
        'title': title,
        'description': description,
        'skillsToCover': skillsToCover,
        'scheduledAt': scheduledAt,
        'duration': duration,
        'status': status.value,
        'sessionMode': sessionMode,
        'meetingPlatform': meetingPlatform,
        'meetingLink': meetingLink,
        'location': location,
        'notes': notes,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  SessionModel copyWith({
    String? id,
    String? hostId,
    String? participantId,
    String? title,
    String? description,
    List<String>? skillsToCover,
    String? scheduledAt,
    int? duration,
    SessionStatus? status,
    String? sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
    String? notes,
    String? createdAt,
    String? updatedAt,
    UserProfileModel? host,
    UserProfileModel? participant,
  }) {
    return SessionModel(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      participantId: participantId ?? this.participantId,
      title: title ?? this.title,
      description: description ?? this.description,
      skillsToCover: skillsToCover ?? this.skillsToCover,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      sessionMode: sessionMode ?? this.sessionMode,
      meetingPlatform: meetingPlatform ?? this.meetingPlatform,
      meetingLink: meetingLink ?? this.meetingLink,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      host: host ?? this.host,
      participant: participant ?? this.participant,
    );
  }
}
