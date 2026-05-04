import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

/// Shared navigator key so the FCM service can navigate without a BuildContext.
final GlobalNavigatorKey globalNavigatorKey = GlobalNavigatorKey._();

class GlobalNavigatorKey {
  GlobalNavigatorKey._();
  final navigatorKey = GlobalKey<NavigatorState>();
}

class FcmService {
  static final FcmService _instance = FcmService._();
  factory FcmService() => _instance;
  FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications with tap callback
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Get and save token
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveToken(token);
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen(_saveToken);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app was in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Handle notification tap when app was terminated
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  Future<void> _saveToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // User doc may not exist yet (e.g., during signup flow)
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'skill_exchange_channel',
          'Skill Exchange',
          channelDescription: 'Skill Exchange notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Pass the actionUrl from data payload as the notification payload
      payload: message.data['actionUrl'] as String?,
    );
  }

  /// Called when user taps a local (foreground) notification.
  void _onLocalNotificationTap(NotificationResponse response) {
    final actionUrl = response.payload;
    if (actionUrl != null && actionUrl.isNotEmpty) {
      _navigateTo(actionUrl);
    }
  }

  /// Called when user taps an FCM notification (background / terminated).
  void _handleMessageTap(RemoteMessage message) {
    final actionUrl = message.data['actionUrl'] as String?;
    if (actionUrl != null && actionUrl.isNotEmpty) {
      _navigateTo(actionUrl);
    }
  }

  /// Navigates to [path] using the global navigator key (go_router compatible).
  void _navigateTo(String path) {
    final context = globalNavigatorKey.navigatorKey.currentContext;
    if (context == null) return;
    GoRouter.of(context).go(path);
  }
}
