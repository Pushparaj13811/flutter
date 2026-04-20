class CreateSessionDto {
  final String participantId;
  final String title;
  final String? description;
  final List<String> skillsToCover;
  final String scheduledAt;
  final int duration;
  final String sessionMode;
  final String? meetingPlatform;
  final String? meetingLink;
  final String? location;

  const CreateSessionDto({
    this.participantId = '',
    this.title = '',
    this.description,
    this.skillsToCover = const [],
    this.scheduledAt = '',
    this.duration = 60,
    this.sessionMode = 'online',
    this.meetingPlatform,
    this.meetingLink,
    this.location,
  });

  factory CreateSessionDto.fromMap(Map<String, dynamic> map) {
    return CreateSessionDto(
      participantId: map['participantId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      skillsToCover: (map['skillsToCover'] as List?)?.cast<String>() ?? [],
      scheduledAt: map['scheduledAt'] as String? ?? '',
      duration: (map['duration'] as num?)?.toInt() ?? 60,
      sessionMode: map['sessionMode'] as String? ?? 'online',
      meetingPlatform: map['meetingPlatform'] as String?,
      meetingLink: map['meetingLink'] as String?,
      location: map['location'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'participantId': participantId,
        'title': title,
        'description': description,
        'skillsToCover': skillsToCover,
        'scheduledAt': scheduledAt,
        'duration': duration,
        'sessionMode': sessionMode,
        'meetingPlatform': meetingPlatform,
        'meetingLink': meetingLink,
        'location': location,
      };

  /// Legacy compatibility alias
  Map<String, dynamic> toJson() => toMap();
}
