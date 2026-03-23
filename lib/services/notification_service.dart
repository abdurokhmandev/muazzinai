import 'package:flutter/foundation.dart';

/// Mock notification service that works without Firebase.
/// Replace with real Firebase Messaging when Firebase is configured.
class NotificationService {
  Future<void> initialize() async {
    debugPrint('[NotificationService] Initialized (mock mode)');
  }

  /// Show a simulated in-app notification (used for OTP display etc.)
  void showLocalNotification(String title, String body) {
    debugPrint('[Notification] $title: $body');
  }

  Future<void> subscribeToTopic(String topic) async {
    debugPrint('[NotificationService] Subscribed to topic: $topic');
  }
}
