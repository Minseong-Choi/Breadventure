import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);
  await flutterLocalNotificationsPlugin.initialize(settings);
}

Future<void> sendPushNotification(String bakeryName) async {
  print('[🔔] $bakeryName 근처 도착!');
  const androidDetails = AndroidNotificationDetails(
    'nearby_bakery_channel',
    'Nearby Bakery',
    channelDescription: '근처에 있는 빵집 알림',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher', // ✅ 반드시 아이콘 설정
  );
  const details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    '🍞 빵집 근처 도착!',
    '$bakeryName 근처에 도착했어요!',
    details,
  );
}
