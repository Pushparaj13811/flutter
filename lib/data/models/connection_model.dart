import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'connection_model.freezed.dart';
part 'connection_model.g.dart';

@freezed
class ConnectionModel with _$ConnectionModel {
  const factory ConnectionModel({
    required String id,
    required String fromUserId,
    required String toUserId,
    required ConnectionStatus status,
    String? message,
    required String createdAt,
    required String updatedAt,
    UserProfileModel? fromUser,
    UserProfileModel? toUser,
  }) = _ConnectionModel;

  factory ConnectionModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectionModelFromJson(json);
}

enum ConnectionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
}
