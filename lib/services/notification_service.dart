import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // 1. Request permissions for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
    }

    // 2. Get the token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
      // Here you would typically save it to Firestore under the user's document
    }

    // 3. Handle incoming messages while foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
        'Received foreground notification: ${message.notification?.title}',
      );
      // Trigger a local notification or update UI
    });

    // 4. Handle notification tap when app is background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification clicked: ${message.data}');
      // Navigate to specific screen based on data
    });
  }

  // Subscribe to topics like 'new_lessons', 'daily_reminder'
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }
}

// Background handler (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background tasks here
  debugPrint("Handling a background message: ${message.messageId}");
}
