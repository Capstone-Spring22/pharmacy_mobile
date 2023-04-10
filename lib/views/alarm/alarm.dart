// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/views/alarm/widget/alarm_tile.dart';
import 'package:pharmacy_mobile/views/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/views/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TimeOfDay time = TimeOfDay.now();
    return Scaffold(
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: "Nhắc uống thuốc",
        rightWidget: NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: const NeumorphicBoxShape.circle(),
            color: context.theme.canvasColor,
            shape: NeumorphicShape.flat,
          ),
          onPressed: () {
            try {
              Get.toNamed('/reminder_picker', preventDuplicates: false);
            } catch (e) {
              log(e.toString());
            }
          },
          child: const Icon(
            Icons.shopping_bag_outlined,
          ),
        ),
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
                child: Text("Chưa có nhắc nhở nào"),
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