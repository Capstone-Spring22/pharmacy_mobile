import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PaymentType extends GetView<CheckoutController> {
  const PaymentType({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ToggleSwitch(
        initialLabelIndex: controller.paymentType.value,
        totalSwitches: 2,
        labels: const ['Cash', 'VNPay'],
        onToggle: controller.togglePaymentType,
        cornerRadius: 20.0,
        inactiveBgColor: context.theme.secondaryHeaderColor,
        minWidth: Get.width * .4,
        minHeight: Get.height * .05,
        activeBgColor: [context.theme.primaryColor],
      ),
    );
  }
}
