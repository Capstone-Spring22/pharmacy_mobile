import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_picker/day_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/reminder.dart';

class AlarmPicker extends StatefulWidget {
  const AlarmPicker({super.key});

  @override
  State<AlarmPicker> createState() => _AlarmPickerState();
}

class _AlarmPickerState extends State<AlarmPicker> {
  Alarm _alarm = Alarm(times: []);
  TextEditingController labelCtl = TextEditingController();
  TextEditingController doseCtl = TextEditingController();

  final ff = ["Tabs", "Piece", "Mg", "Gr"];

  String currentType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentType = ff[0];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    labelCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return Scaffold(
      backgroundColor: const Color(0xFFfefeff),
      appBar: AppBar(
        title: const Text("Set your reminder"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Reminder Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                ReminderInput(
                  txtControlller: labelCtl,
                  inputType: TextInputType.name,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dose",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ReminderInput(
                            txtControlller: doseCtl,
                            inputType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DropdownButtonFormField2(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              fillColor: const Color(0xFFf7f9fc),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0.0,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                            buttonHeight: 60,
                            buttonPadding:
                                const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            items: ff
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: currentType == item
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                currentType = value!;
                              });
                            },
                            onSaved: (value) {
                              Get.log(value.toString());
                            },
                            value: ff[0],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SelectWeekDays(
                  backgroundColor: Colors.transparent,
                  unSelectedDayTextColor: Colors.black,
                  selectedDayTextColor: Colors.white,
                  daysBorderColor: context.theme.primaryColor,
                  daysFillColor: context.theme.primaryColor,
                  onSelect: (List<String> value) {
                    if (value.isEmpty) {
                      setState(() {
                        _alarm.repeatDays = [];
                      });
                    }
                    List<bool> tempDateBool = List.filled(7, false);
                    for (var e in value) {
                      int index = days.indexOf(e);
                      tempDateBool[index] = true;
                    }
                    setState(() {
                      _alarm = _alarm.copyWith(repeatDays: tempDateBool);
                    });
                  },
                  days: days.map((e) => DayInWeek(e)).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reminder Times: ${_alarm.times!.length}",
                      style: context.textTheme.headlineSmall,
                    ),
                    IconButton(
                        onPressed: () {
                          final now = DateTime.now();
                          Navigator.of(context).push(
                            showPicker(
                              iosStylePicker: true,
                              is24HrFormat: true,
                              accentColor: context.theme.primaryColor,
                              ltrMode: true,
                              context: context,
                              value: Time(hour: now.hour, minute: now.minute),
                              onChange: (v) {
                                if (_alarm.times!.contains(v)) {
                                  Get.snackbar(
                                    "Duplicate Time",
                                    "You have already select this time",
                                    backgroundGradient: Gradients.coldLinear,
                                  );
                                } else {
                                  setState(() {
                                    _alarm.times!.add(v);
                                    Get.log(v.toString());
                                  });
                                }
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                _alarm.times!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final time = _alarm.times![index];
                            final String hours = time.hour < 10
                                ? "0${time.hour}"
                                : "${time.hour}";
                            final String mins = time.minute < 10
                                ? "0${time.minute}"
                                : "${time.minute}";
                            final String ampm = time.hour <= 12 ? "AM" : "PM";
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Slidable(
                                key: UniqueKey(),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (v) {
                                        final now = TimeOfDay.now();
                                        Navigator.of(context).push(
                                          showPicker(
                                            iosStylePicker: true,
                                            is24HrFormat: true,
                                            accentColor:
                                                context.theme.primaryColor,
                                            ltrMode: true,
                                            context: context,
                                            value: Time(
                                                hour: now.hour,
                                                minute: now.minute),
                                            onChange: (v) {
                                              setState(() {
                                                _alarm.times![index] = v;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                      backgroundColor: const Color(0xFF0392CF),
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (v) {
                                        setState(() {
                                          _alarm.times!.removeAt(index);
                                        });
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: LayoutBuilder(builder:
                                    (contextFromLayoutBuilder, constraints) {
                                  return CupertinoListTile(
                                    title: Text(
                                      notiController
                                          .getTimeOfDay(int.parse(hours)),
                                    ),
                                    subtitle: Text(
                                      textAlign: TextAlign.center,
                                      "$hours : $mins $ampm ",
                                      style: context.textTheme.displayMedium,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        final slidable = Slidable.of(
                                            contextFromLayoutBuilder);
                                        if (slidable?.actionPaneConfigurator ==
                                            null) {
                                          slidable?.openEndActionPane(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.decelerate,
                                          );
                                        } else {
                                          slidable!.close();
                                        }
                                      },
                                      icon: const Icon(CupertinoIcons.back),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                          itemCount: _alarm.times!.length,
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text("No time selected"),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: Get.width * .8,
                    height: Get.height * .065,
                    child: FilledButton(
                      onPressed: _alarm.times!.isNotEmpty &&
                              _alarm.repeatDays.contains(true)
                          ? () {
                              _alarm.label = labelCtl.text;
                              _alarm.icon = Icons.adb_sharp;
                              _alarm.note = "Take your medicine";
                              _alarm.products = ["01", "02", "03"];

                              notiController.addAlarm(_alarm);
                              Get.back();
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text("Add Reminder"), Icon(Icons.add)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReminderInput extends StatelessWidget {
  const ReminderInput({
    super.key,
    required this.txtControlller,
    required this.inputType,
  });

  final TextEditingController txtControlller;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: txtControlller,
      keyboardType: inputType,
      decoration: InputDecoration(
        fillColor: const Color(0xFFf7f9fc),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent, width: 2),
        ),
      ),
    );
  }
}
