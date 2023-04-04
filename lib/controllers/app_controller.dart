import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:motion/motion.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  AndroidDeviceInfo? androidInfo;

  Rx<String> searchCtl = "".obs;

  //App Page Navigation
  RxInt pageIndex = 0.obs;

  setPage(int i) => pageIndex.value = i;

  //Theme Setting
  RxBool isDarkMode = false.obs;

  //Debug
  RxString debugText = "".obs;

  Dio dio = Dio();

  late CacheStore cacheStore;
  late CacheOptions cacheOptions;

  void toggleTheme() {
    final box = GetStorage();
    box.write('theme', isDarkMode.value);
    Get.changeTheme(isDarkMode.value ? themeLight : themeDark);
  }

  initCacheOption() {
    cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);

    cacheOptions = CacheOptions(
      maxStale: const Duration(hours: 1),
      store: cacheStore, allowPostMethod: true,
      hitCacheOnErrorExcept: [], // for offline behaviour
    );

    dio = Dio()
      ..interceptors.add(
        DioCacheInterceptor(options: cacheOptions),
      );
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

  void initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    androidInfo = await deviceInfo.androidInfo;
  }

  void toggleMenuDrawer() => drawerKey.currentState!.openDrawer();
  void toggleCartDrawer() => drawerKey.currentState!.openEndDrawer();

  @override
  void onInit() {
    readTheme();
    initMotion();
    initDeviceInfo();
    initCacheOption();
    ever(isDarkMode, (callback) => toggleTheme());
    super.onInit();
  }

  Future<String> getIpAddress() async {
    try {
      final response = await dio.get('https://api.ipify.org/?format=json');

      if (response.statusCode == 200) {
        final data = response.data;
        return data['ip'];
      } else {
        throw Exception('Failed to get IP address');
      }
    } on DioError catch (e) {
      Get.log(e.response.toString());

      return "";
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
