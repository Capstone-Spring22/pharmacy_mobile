import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/screens/checkout/widget/checkout_info.dart';

class CheckoutInfoPanel extends StatefulWidget {
  final ScrollController scrollController;
  final DraggableScrollableController draggableScrollableController;
  const CheckoutInfoPanel({
    super.key,
    required this.scrollController,
    required this.draggableScrollableController,
  });

  @override
  State<CheckoutInfoPanel> createState() => _CheckoutInfoPanelState();
}

class _CheckoutInfoPanelState extends State<CheckoutInfoPanel> {
  @override
  Widget build(BuildContext context) {
    CheckoutController checkoutController = Get.find();
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Obx(() {
        if (!checkoutController.isCollase.value) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "⬆️ Scroll up to checkout",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          );
        } else {
          return UserCheckoutInfo(
            scrollController: widget.scrollController,
            draggableScrollableController: widget.draggableScrollableController,
          );
        }
      }),
    );
  }
}
