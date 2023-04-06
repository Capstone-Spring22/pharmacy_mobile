// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/views/alarm/widget/alarm_tile.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TimeOfDay time = TimeOfDay.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medication Remider"),
        actions: [
          IconButton(
            onPressed: () {
              try {
                Get.toNamed('/reminder_picker', preventDuplicates: false);
              } catch (e) {
                log(e.toString());
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(() => notiController.listAlarms.isNotEmpty
            ? ListView.builder(
                itemBuilder: (context, index) => AlarmTile(
                  alarm: notiController.listAlarms[index],
                ),
                itemCount: notiController.listAlarms.length,
              )
            : const Center(
                child: Text("Empty Alarm"),
              )),
      ),
    );
  }
}

// @pragma('vm:entry-point')
// void fireAlarm() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=$isolateId function='$fireAlarm'");
// }

// AndroidAlarmManager.oneShot(
//                   alarmClock: true,
//                   wakeup: true,
//                   const Duration(seconds: 3),
//                   1,
//                   allowWhileIdle: true,
//                   exact: true,
//                   fireAlarm,
//                 );