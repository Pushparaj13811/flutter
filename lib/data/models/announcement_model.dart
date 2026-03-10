import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

enum AnnouncementPriority {
  @JsonValue('info')
  info,
  @JsonValue('warning')
  warning,
  @JsonValue('critical')
  critical,
}

@freezed
class AnnouncementModel with _$AnnouncementModel {
  const factory AnnouncementModel({
    required String id,
    required String title,
    @Default('') String body,
    @Default(AnnouncementPriority.info) AnnouncementPriority priority,
    @Default(true) bool isActive,
    required String createdAt,
    String? expiresAt,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);
}
