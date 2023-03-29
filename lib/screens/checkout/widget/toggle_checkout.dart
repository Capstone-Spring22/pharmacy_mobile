import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleCheckout extends StatelessWidget {
  const ToggleCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    final CheckoutController checkoutController = Get.find();
    return Obx(
      () => ToggleSwitch(
        initialLabelIndex: checkoutController.checkoutType.value,
        totalSwitches: 2,
        labels: const ['Online Delivery', 'Store Pickup'],
        onToggle: checkoutController.toggleOrderType,
        cornerRadius: 20.0,
        minWidth: Get.width * .4,
        minHeight: Get.height * .05,
        activeBgColor: [context.theme.primaryColor],
      ),
    );
  }
}
