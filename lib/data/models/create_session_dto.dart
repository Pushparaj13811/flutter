import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_session_dto.freezed.dart';
part 'create_session_dto.g.dart';

@freezed
class CreateSessionDto with _$CreateSessionDto {
  const factory CreateSessionDto({
    required String participantId,
    required String title,
    String? description,
    @Default([]) List<String> skillsToCover,
    required String scheduledAt,
    required int duration,
    @Default('online') String sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
  }) = _CreateSessionDto;

  factory CreateSessionDto.fromJson(Map<String, dynamic> json) =>
      _$CreateSessionDtoFromJson(json);
}
