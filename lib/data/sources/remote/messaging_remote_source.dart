import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';

class MessagingRemoteSource {
  final Dio _dio;

  MessagingRemoteSource(this._dio);

  Future<List<ConversationModel>> getThreads() async {
    final response = await _dio.get(Messages.threads);
    final data = response.data['data'] as List;
    return data
        .map((e) => ConversationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getMessages(
    String threadId, {
    int page = 1,
  }) async {
    final response = await _dio.get(
      Messages.threadById(threadId),
      queryParameters: {'page': page},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<MessageModel> sendMessage(
    String receiverId,
    String content,
  ) async {
    final response = await _dio.post(
      Messages.send,
      data: {'receiverId': receiverId, 'content': content},
    );
    return MessageModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  Future<void> markThreadRead(String threadId) async {
    await _dio.post(Messages.markRead(threadId));
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(Messages.unreadCount);
    return response.data['data']['count'] as int;
  }
}
