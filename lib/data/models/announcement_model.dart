enum AnnouncementPriority {
  info('info'),
  warning('warning'),
  critical('critical');

  const AnnouncementPriority(this.value);
  final String value;

  static AnnouncementPriority fromString(String s) {
    return AnnouncementPriority.values.firstWhere(
      (e) => e.value == s,
      orElse: () => AnnouncementPriority.info,
    );
  }
}

class AnnouncementModel {
  final String id;
  final String title;
  final String body;
  final AnnouncementPriority priority;
  final bool isActive;
  final String createdAt;
  final String? expiresAt;

  const AnnouncementModel({
    this.id = '',
    this.title = '',
    this.body = '',
    this.priority = AnnouncementPriority.info,
    this.isActive = true,
    this.createdAt = '',
    this.expiresAt,
  });

  factory AnnouncementModel.fromMap(Map<String, dynamic> map) {
    return AnnouncementModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      priority: AnnouncementPriority.fromString(
          map['priority'] as String? ?? 'info'),
      isActive: map['isActive'] as bool? ?? true,
      createdAt: map['createdAt'] as String? ?? '',
      expiresAt: map['expiresAt'] as String?,
    );
  }

  /// Legacy compatibility alias
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =
      AnnouncementModel.fromMap;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'priority': priority.value,
        'isActive': isActive,
        'createdAt': createdAt,
        'expiresAt': expiresAt,
      };
}
