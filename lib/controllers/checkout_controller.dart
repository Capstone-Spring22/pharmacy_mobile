import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';

class CheckoutController extends GetxController {
  RxBool isCollase = false.obs;

  RxDouble panelHeight = (Get.height * .1).obs;

  final nameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final address = TextEditingController();

  void rowView() => isCollase.value = true;
  void colView() => isCollase.value = false;

  double linearInterpolationTop() {
    return 0.8 * (panelHeight.value - 0.1);
  }

  void setPanelHeight(double d) {
    panelHeight.value = d;
  }

  @override
  void onInit() {
    final user = userController.user.value;

    if (user.name != null) {
      nameCtl.text = user.name!;
    }
    phoneCtl.text = user.phoneNo!;
    super.onInit();
  }
}
