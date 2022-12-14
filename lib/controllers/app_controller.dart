import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  Rx<TextEditingController> searchCtl = TextEditingController().obs;

  RxInt pageIndex = 0.obs;

  setPage(int i) => pageIndex.value = i;

  void toggleMenuDrawer() => drawerKey.currentState!.openDrawer();
  void toggleCartDrawer() => drawerKey.currentState!.openEndDrawer();

  @override
  void onInit() {
    ever(searchCtl, (callback) => print("VALUE: ${callback.value.text}"));
    super.onInit();
  }

  // void toggleSideDrawer() {
  //   cartDrawerController.toggle?.call();
  //   update();
  // }
}
