import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  Rx<TextEditingController> searchCtl = TextEditingController().obs;

  //App Page Navigation
  RxInt pageIndex = 0.obs;

  setPage(int i) => pageIndex.value = i;

  //Theme Setting
  RxBool isDarkMode = false.obs;

  void toggleTheme() {
    print("Theme: $isDarkMode");
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

  //

  void toggleMenuDrawer() => drawerKey.currentState!.openDrawer();
  void toggleCartDrawer() => drawerKey.currentState!.openEndDrawer();

  @override
  void onInit() {
    readTheme();

    ever(searchCtl, (callback) => print("VALUE: ${callback.value.text}"));
    ever(isDarkMode, (callback) => toggleTheme());
    super.onInit();
  }
}
