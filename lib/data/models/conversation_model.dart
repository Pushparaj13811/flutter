import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    @Default([]) List<String> participants,
    String? lastMessage,
    String? lastMessageAt,
    @Default(0) int unreadCount,
    required String updatedAt,
    @Default([]) List<UserProfileModel> participantProfiles,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
}
