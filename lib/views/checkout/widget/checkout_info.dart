import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/views/checkout/widget/check_product_avail.dart';
import 'package:pharmacy_mobile/views/checkout/widget/toggle_checkout.dart';
import 'package:pharmacy_mobile/views/user/widget/address_card.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

import 'payment_type.dart';

class UserCheckoutInfo extends StatelessWidget {
  const UserCheckoutInfo(
      {super.key,
      required this.scrollController,
      required this.draggableScrollableController});

  final ScrollController scrollController;
  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context) {
    final CheckoutController checkoutCtrl = Get.find();

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .05,
          ),
          ...checkoutCtrl.listTextField.map((element) {
            final int index = checkoutCtrl.listTextField.indexOf(element);
            return GestureDetector(
              onTap: checkoutCtrl.listTextField[index].fn,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                      checkoutCtrl.listTextField[index].icon,
                      color: context.theme.primaryColor,
                    ),
                    Expanded(
                      child: Input(
                        enabled: checkoutCtrl
                                .listTextField[
                                    checkoutCtrl.listTextField.indexOf(element)]
                                .fn ==
                            null,
                        inputController:
                            checkoutCtrl.listTextField[index].txtCtrl,
                        title: checkoutCtrl.listTextField[index].label,
                        inputType: checkoutCtrl.listTextField[index].type,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Hình thức thanh toán"),
              ),
              PaymentType(),
            ],
          ),
          Column(
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Loại đơn hàng"),
              ),
              ToggleCheckout(),
            ],
          ),
          Obx(() {
            if (checkoutCtrl.checkoutType.value == 0) {
              return const AddressCard();
            } else {
              return const CheckProductAvailbility();
            }
          }),
          SizedBox(
            height: Get.height * .1,
          )
        ]
            .animate(interval: 30.ms)
            .slideX(begin: 1, delay: 50.ms)
            .fade(delay: 50.ms),
      ),
    );
  }
}
