class Session {
  final String id;
  final String hostId;
  final String participantId;
  final String title;
  final String description;
  final List<String> skillsToCover;
  final String scheduledAt;
  final int duration;
  final String status;
  final String sessionMode;
  final String? meetingLink;
  final String? location;

  const Session({
    required this.id,
    required this.hostId,
    required this.participantId,
    required this.title,
    this.description = '',
    this.skillsToCover = const [],
    required this.scheduledAt,
    required this.duration,
    required this.status,
    this.sessionMode = 'online',
    this.meetingLink,
    this.location,
  });
}
