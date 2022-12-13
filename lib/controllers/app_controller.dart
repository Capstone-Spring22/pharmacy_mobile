import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();

  final menuDrawerController = ZoomDrawerController();
  final cartDrawerController = ZoomDrawerController();

  RxInt pageIndex = 0.obs;

  setPage(int i) => pageIndex.value = i;

  void toggleDrawer() {
    menuDrawerController.toggle?.call();
    update();
  }

  void toggleSideDrawer() {
    cartDrawerController.toggle?.call();
    update();
  }
}
