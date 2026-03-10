import 'package:freezed_annotation/freezed_annotation.dart';

part 'reschedule_session_dto.freezed.dart';
part 'reschedule_session_dto.g.dart';

@freezed
class RescheduleSessionDto with _$RescheduleSessionDto {
  const factory RescheduleSessionDto({
    required String newScheduledAt,
    required int newDuration,
    String? reason,
  }) = _RescheduleSessionDto;

  factory RescheduleSessionDto.fromJson(Map<String, dynamic> json) =>
      _$RescheduleSessionDtoFromJson(json);
}
