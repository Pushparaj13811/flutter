import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    required String hostId,
    required String participantId,
    required String title,
    @Default('') String description,
    @Default([]) List<String> skillsToCover,
    required String scheduledAt,
    required int duration,
    required SessionStatus status,
    @Default('online') String sessionMode,
    String? meetingPlatform,
    String? meetingLink,
    String? location,
    String? notes,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? host,
    UserProfileModel? participant,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}

enum SessionStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}
