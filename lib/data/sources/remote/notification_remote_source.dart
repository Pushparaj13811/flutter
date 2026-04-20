import 'package:dio/dio.dart';
import 'package:skill_exchange/core/constants/api_endpoints.dart';
import 'package:skill_exchange/data/models/notification_model.dart';

class NotificationRemoteSource {
  final Dio _dio;

  NotificationRemoteSource(this._dio);

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get(Notifications.list);
    final data = response.data['data']['notifications'] as List;
    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await _dio.get(Notifications.unreadCount);
    return response.data['data']['count'] as int;
  }

  Future<void> markAsRead(String id) async {
    await _dio.post(Notifications.markRead(id));
  }

  Future<void> markAllAsRead() async {
    await _dio.post(Notifications.readAll);
  }

  Future<void> deleteNotification(String id) async {
    await _dio.delete(Notifications.delete(id));
  }
}
