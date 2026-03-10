import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';

class MessagingRemoteSource {
  final Dio _dio;

  MessagingRemoteSource(this._dio);

  Future<List<ConversationModel>> getConversations() async {
    final response = await _dio.get(Messages.conversations);
    final data = response.data['data'] as List;
    return data
        .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageModel>> getMessages(
    String conversationId, {
    int? page,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;

    final response = await _dio.get(
      Messages.conversationMessages(conversationId),
      queryParameters: params,
    );
    final data = response.data['data'] as List;
    return data
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MessageModel> sendMessage(
    String conversationId,
    String content,
  ) async {
    final response = await _dio.post(
      Messages.send,
      data: {'conversationId': conversationId, 'content': content},
    );
    return MessageModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> markAsRead(String id) async {
    await _dio.put(Messages.markRead(id));
  }
}
