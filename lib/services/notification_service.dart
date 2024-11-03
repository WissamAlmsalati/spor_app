import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static late GlobalKey<NavigatorState> _navigatorKey;

  // Initialize Firebase Messaging and local notifications
  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
    await _requestNotificationPermission();
    await _initializeLocalNotifications();
    await _setFirebaseHandlers();
    await _saveDeviceToken(); // Ensure device token is saved here

    // Check if the app was launched by tapping a notification
    _checkInitialMessage();
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

  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          _handleNotificationClick(response.payload!);
        }
      },
    );
  }

  // Show local notification when a message is received
  static Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel name
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: message.data['payload'], // Pass any payload data here
    );
  }

  // Save device token to secure storage
  static Future<void> _saveDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      // Check if the token is already saved
      String? savedToken = await _secureStorage.read(key: 'deviceToken');
      if (savedToken != token) {
        await _secureStorage.write(key: 'deviceToken', value: token);
        print('New device token saved: $token');
      } else {
        print('Device token already saved: $token');
      }
        } catch (e) {
      print('Error saving device token: $e');
    }
  }

  // Set Firebase handlers
  static Future<void> _setFirebaseHandlers() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      if (message.data['payload'] != null) {
        _handleNotificationClick(message.data['payload']);
      }
    });
  }

  // Check if the app was launched by tapping on a notification
  static Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data['payload'] ?? 'No payload');
    }
  }

  // Handle notification click
  static void _handleNotificationClick(String payload) {
    final context = _navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      print("Notification clicked with payload: $payload");
      // You can navigate to a specific screen here if desired
    }
  }
}
