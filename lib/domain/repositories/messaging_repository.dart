import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';

abstract class MessagingRepository {
  Future<Either<Failure, List<ConversationModel>>> getConversations();
  Future<Either<Failure, List<MessageModel>>> getMessages(
    String conversationId, {
    int? page,
  });
  Future<Either<Failure, MessageModel>> sendMessage(
    String conversationId,
    String content,
  );
  Future<Either<Failure, void>> markAsRead(String id);
}
