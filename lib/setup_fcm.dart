import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:training_apps/routes/routes.dart';
import 'package:training_apps/services/base_service.dart';
// Remove: import 'package:training_apps/main.dart';

final FlutterLocalNotificationsPlugin fln = FlutterLocalNotificationsPlugin();

Future<void> setupFcm() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
  );
  print('Permission: ${settings.authorizationStatus}');

  final token = await messaging.getToken();

  // print(token);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  const androidInit = AndroidInitializationSettings(
    '@drawable/ic_stat_ic_notification',
  );
  const iosInit = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );
  await fln.initialize(settings: initSettings);

  const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications.',
    importance: Importance.high,
  );
  await fln
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      await fln.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'Used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_stat_ic_notification',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
    if (message.data.isNotEmpty) {
      print('Data: ${message.data}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Notification opened: ${message.messageId}');
    // Navigate using message.data if needed
  });
}
