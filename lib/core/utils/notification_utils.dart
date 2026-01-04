import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _defaultAndroidDetails =
      AndroidNotificationDetails(
    'flowzen_general',
    'FlowZen Alerts',
    channelDescription: 'Reminders and motivational nudges',
    importance: Importance.high,
    priority: Priority.high,
  );

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _plugin.initialize(initializationSettings);
  }

  static Future<void> showInstant(String title, String body) async {
    await _plugin.show(
      title.hashCode,
      title,
      body,
      const NotificationDetails(android: _defaultAndroidDetails),
    );
  }

  static Future<void> scheduleDaily(
    String id,
    String title,
    String body,
    TimeOfDay time,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id.hashCode,
      title,
      body,
      scheduled,
      const NotificationDetails(android: _defaultAndroidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
