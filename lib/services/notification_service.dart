import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Method to initialize Firebase Messaging
  static Future<void> initialize() async {
    await _requestNotificationPermission();
    await _setFirebaseHandlers();
    await _saveDeviceToken();
  }

  // Request permission for notifications
  static Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Save device token to secure storage
  static Future<void> _saveDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await _secureStorage.write(key: 'deviceToken', value: token);
      print("Device Token saved: $token");
    } else {
      print("Failed to get device token");
    }
  }

  // Set up handlers for different notification types
  static Future<void> _setFirebaseHandlers() async {
    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      // Handle message here, e.g., show a dialog or notification
    });

    // Handle background notifications
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    // Handle the background message if necessary
  }
}