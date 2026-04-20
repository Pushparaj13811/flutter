class RescheduleSessionDto {
  final String newScheduledAt;
  final int newDuration;
  final String? reason;

  const RescheduleSessionDto({
    this.newScheduledAt = '',
    this.newDuration = 60,
    this.reason,
  });

  factory RescheduleSessionDto.fromMap(Map<String, dynamic> map) {
    return RescheduleSessionDto(
      newScheduledAt: map['newScheduledAt'] as String? ?? '',
      newDuration: (map['newDuration'] as num?)?.toInt() ?? 60,
      reason: map['reason'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'newScheduledAt': newScheduledAt,
        'newDuration': newDuration,
        'reason': reason,
      };

  /// Legacy compatibility alias
  Map<String, dynamic> toJson() => toMap();
}
