import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/conversation_model.dart';
import 'package:skill_exchange/data/models/message_model.dart';
import 'package:skill_exchange/data/sources/remote/messaging_remote_source.dart';
import 'package:skill_exchange/domain/repositories/messaging_repository.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final MessagingRemoteSource _remoteSource;

  MessagingRepositoryImpl(this._remoteSource);

  @override
  Future<Either<Failure, List<ConversationModel>>> getConversations() async {
    try {
      final result = await _remoteSource.getThreads();
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages(
    String conversationId, {
    int? page,
  }) async {
    try {
      final result = await _remoteSource.getMessages(
        conversationId,
        page: page ?? 1,
      );
      final items = result['messages'] as List? ?? [];
      return Right(
        items
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage(
    String conversationId,
    String content,
  ) async {
    try {
      final result = await _remoteSource.sendMessage(conversationId, content);
      return Right(result);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _remoteSource.markThreadRead(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.error as Failure);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
