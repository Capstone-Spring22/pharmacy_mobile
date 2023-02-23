import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:motion/motion.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class AppController extends GetxController {
  static AppController instance = Get.find();

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  Rx<TextEditingController> searchCtl = TextEditingController().obs;

  //App Page Navigation
  RxInt pageIndex = 0.obs;

  setPage(int i) => pageIndex.value = i;

  //Theme Setting
  RxBool isDarkMode = false.obs;

  //Debug
  RxString debugText = "".obs;

  void toggleTheme() {
    final box = GetStorage();
    box.write('theme', isDarkMode.value);
    Get.changeTheme(isDarkMode.value ? themeLight : themeDark);
  }

  void readTheme() {
    final box = GetStorage();
    final res = box.read('theme');
    if (res != null) {
      isDarkMode.value = res;
    } else {
      isDarkMode.value = false;
    }
  }

  void initMotion() async {
    /// Initialize the plugin to determine gyroscope availability.
    await Motion.instance.initialize();

    /// Globally set Motion's update interval to 60 frames per second.
    Motion.instance.setUpdateInterval(60.fps);
  }

  void toggleMenuDrawer() => drawerKey.currentState!.openDrawer();
  void toggleCartDrawer() => drawerKey.currentState!.openEndDrawer();

  @override
  void onInit() {
    readTheme();
    initMotion();
    ever(searchCtl, (callback) => print("VALUE: ${callback.value.text}"));
    ever(isDarkMode, (callback) => toggleTheme());
    super.onInit();
  }

  Future<String> getIpAddress() async {
    final response =
        await http.get(Uri.parse('https://api.ipify.org/?format=json'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['ip'];
    } else {
      throw Exception('Failed to get IP address');
    }
  }

  String generateRefBill() {
    final now = DateTime.now();
    final randomNumberString =
        '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
    final randomNumber = int.parse(randomNumberString);
    final random = Random(randomNumber);
    return random.nextInt(99999).toString();
  }
}
