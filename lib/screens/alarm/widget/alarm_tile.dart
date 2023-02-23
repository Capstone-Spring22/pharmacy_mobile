import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:motion/motion.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/reminder.dart';

class AlarmTile extends StatelessWidget {
  const AlarmTile({super.key, required this.alarm});

  final Alarm alarm;

  @override
  Widget build(BuildContext context) {
    var ff = Gradients.coldLinear;
    final time = alarm.times![0];
    final String hours = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
    final String mins = time.minute < 10 ? "0${time.minute}" : "${time.minute}";
    final String ampm = time.hour <= 12 ? "AM" : "PM";
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      child: Motion(
        shadow: null,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
            gradient: ff,
            boxShadow: [
              BoxShadow(
                color: ff.colors.first.withOpacity(0.25),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(3, 0),
              ),
              BoxShadow(
                color: ff.colors.last.withOpacity(0.25),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(25),
          ),
          height: 200,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                alarm.label!,
                style: context.textTheme.headlineMedium,
              ),
              CupertinoListTile(
                onTap: () {
                  Get.defaultDialog(
                      title: "Delete",
                      onConfirm: () {
                        notiController.removeAlarm(alarm);
                        Get.back();
                      },
                      onCancel: () {},
                      middleText: "You want to remove this alarm?");
                },
                title: Text(
                  notiController.getTimeOfDay(alarm.times![0].hour),
                ),
                subtitle: Text(
                  textAlign: TextAlign.center,
                  "$hours : $mins $ampm ",
                  style: context.textTheme.displayMedium,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
