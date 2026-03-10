import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skill_exchange/data/models/user_profile_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String content,
    required String createdAt,
    @Default(false) bool read,
    UserProfileModel? sender,
    @Default(false) bool isFromMe,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
