// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pharmacy_mobile/models/reminder.dart';
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notiRes) async {
  // handle action
  final String? payload = notiRes.payload;
  if (notiRes.payload != null) {
    log('notification payload: $payload');
    Get.toNamed("/navhub");
  }
}

@pragma('vm:entry-point')
void notificationTap(NotificationResponse notiRes) async {
  // handle action
  final String? payload = notiRes.payload;
  if (notiRes.payload != null) {
    log('notification payload: $payload');
    Get.snackbar("Noti", 'notification payload: $payload');
  }
}

class NotificationController extends GetxController {
  static NotificationController instance = Get.find();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  RxList<Alarm> listAlarms = <Alarm>[].obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  String getTimeOfDay(int hour) {
    if (hour >= 6 && hour < 12) {
      return "Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Evening";
    } else {
      return "Night";
    }
  }

  void addAlarm(Alarm alarm) {
    listAlarms.add(alarm);
    update();
  }

  void removeAlarm(Alarm alarm) {
    listAlarms.remove(alarm);
  }

  void init() async {
    tz.initializeTimeZones();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: notificationTap,
    );
  }

  void fireAlarm(
      {required String title,
      required String body,
      required TimeOfDay time}) async {
    var androidNoti =
        const AndroidNotificationDetails('medAlarm', 'Medicine Reminder');

    var platformSpec = NotificationDetails(android: androidNoti);
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     0,
    //     'scheduled title',
    //     'scheduled body',
    //     tz.TZDateTime.from(time, local),
    //     platformSpec,
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     payload: "Hello World from >>>>>>");
  }

  void requestAppPermissions() async {
    var nofiStatus = await Permission.notification.status;

    if (nofiStatus == PermissionStatus.denied) {
      await Permission.notification.request();
      Get.defaultDialog(
        middleText: "Grant Notification Setting",
        onCancel: () => Get.back(),
        confirm: FilledButton(
          onPressed: () {
            Get.back();
            openAppSettings();
          },
          child: const Text("Confirm"),
        ),
        cancel: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
      );
    }
  }
}
