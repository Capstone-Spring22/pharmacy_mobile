import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/views/checkout/widget/check_product_avail.dart';
import 'package:pharmacy_mobile/views/checkout/widget/toggle_checkout.dart';
import 'package:pharmacy_mobile/views/user/widget/address_card.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

import 'payment_type.dart';

class UserCheckoutInfo extends StatefulWidget {
  const UserCheckoutInfo(
      {super.key,
      required this.scrollController,
      required this.draggableScrollableController});

  final ScrollController scrollController;
  final DraggableScrollableController draggableScrollableController;

  @override
  State<UserCheckoutInfo> createState() => _UserCheckoutInfoState();
}

class _UserCheckoutInfoState extends State<UserCheckoutInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Duration _duration = const Duration(milliseconds: 500);

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _duration,
      vsync: this,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  getSlideTransition(int index) {
    final end = (index + 1) * 0.3;
    return Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.3,
          end.clamp(0.0, 1.0),
        ),
      ),
    );
  }

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
            return SlideTransition(
              position: getSlideTransition(index),
              child: GestureDetector(
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
                                  .listTextField[checkoutCtrl.listTextField
                                      .indexOf(element)]
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
              ),
            );
          }),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Hình thức thanh toán"),
          ),
          const PaymentType(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Loại đơn hàng"),
          ),
          const ToggleCheckout(),
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
        ],
      ),
    );
  }
}
