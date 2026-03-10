import 'package:fpdart/fpdart.dart';
import 'package:skill_exchange/core/errors/failures.dart';
import 'package:skill_exchange/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications();
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String id);
}
