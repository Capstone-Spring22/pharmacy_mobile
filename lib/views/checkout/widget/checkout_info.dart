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

    return Column(
      children: [
        SizedBox(
          height: Get.height * .05,
        ),
        ...checkoutCtrl.listTextField.map((element) {
          final int index = checkoutCtrl.listTextField.indexOf(element);
          Color color = Colors.white;
          switch (index) {
            case 0:
              color = const Color(0xff8d7aee);
              break;
            case 1:
              color = const Color(0xfff468b7);
              break;
            case 2:
              color = const Color(0xffffc85b);
              break;
            case 3:
              color = const Color(0xff5dd1d3);
              break;
            default:
              color = const Color(0xff5dd1d3);
          }
          return GestureDetector(
            onTap: checkoutCtrl.listTextField[index].fn,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              // child: Row(
              //   children: [
              //     Icon(
              //       checkoutCtrl.listTextField[index].icon,
              //       color: context.theme.primaryColor,zz
              //     ),
              //     Expanded(
              //       child: Input(
              //         enabled: checkoutCtrl
              //                 .listTextField[
              //                     checkoutCtrl.listTextField.indexOf(element)]
              //                 .fn ==
              //             null,
              //         inputController:
              //             checkoutCtrl.listTextField[index].txtCtrl,
              //         title: checkoutCtrl.listTextField[index].label,
              //         inputType: checkoutCtrl.listTextField[index].type,
              //       ),
              //     ),
              //   ],
              // ),

              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    color: color,
                  ),
                  child: Icon(
                    checkoutCtrl.listTextField[index].icon,
                    color: Colors.white,
                  ),
                ),
                title: SizedBox(
                  width: Get.width * .85,
                  child: Input(
                    horiPadding: 0,
                    enabled: checkoutCtrl
                            .listTextField[
                                checkoutCtrl.listTextField.indexOf(element)]
                            .fn ==
                        null,
                    inputController: checkoutCtrl.listTextField[index].txtCtrl,
                    title: checkoutCtrl.listTextField[index].label,
                    inputType: checkoutCtrl.listTextField[index].type,
                  ),
                ),
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
        const SizedBox(
          height: 20,
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
    );
  }
}
