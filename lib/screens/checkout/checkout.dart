// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';

import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/screens/checkout/widget/list_checkout.dart';
import 'package:pharmacy_mobile/screens/checkout/widget/toggle_checkout.dart';
import 'package:pharmacy_mobile/screens/user/widget/address_card.dart';
import 'package:pharmacy_mobile/widgets/input.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double topPad = 0.1;
  double bottomPad = 0.8;
  double _top = 0;
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  bool vl = false;

  @override
  void dispose() {
    draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _top = Get.height * bottomPad;
    Get.put(CheckoutController());
  }

  @override
  Widget build(BuildContext context) {
    CheckoutController checkoutController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        actions: const [],
      ),
      body: Stack(
        children: [
          const ListCheckout(),
          NotificationListener(
            onNotification: (DraggableScrollableNotification dsNofti) {
              CheckoutController checkoutController = Get.find();
              checkoutController.setPanelHeight(dsNofti.extent);
              if (dsNofti.extent >= .6) {
                checkoutController.rowView();
              } else if (dsNofti.extent <= .5) {
                checkoutController.colView();
              }
              return false;
            },
            child: DraggableScrollableSheet(
              snap: true,
              initialChildSize: .14,
              minChildSize: .14,
              maxChildSize: .8,
              controller: draggableScrollableController,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Get.theme.hoverColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: CheckoutInfoPanel(
                      scrollController: scrollController,
                      draggableScrollableController:
                          draggableScrollableController),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            top: Get.height * .82,
            child: FilledButton(
              onPressed: () {
                if (checkoutController.isCollase.value) {
                } else {
                  checkoutController.isCollase.value = true;
                  draggableScrollableController.animateTo(
                    .9,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                  );
                }
              },
              child: cartController.listCart.isEmpty
                  ? const Text("Empty Cart")
                  : Text(
                      "Total ${convertCurrency(cartController.calculateTotal())}",
                    ),
            ),
          )
        ],
      ),
    );
  }
}

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
      child: SizedBox(
        height: Get.height * .7,
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
            return const UserCheckoutInfo();
          }
        }),
      ),
    );
  }
}

class UserCheckoutInfo extends StatefulWidget {
  const UserCheckoutInfo({super.key});

  @override
  State<UserCheckoutInfo> createState() => _UserCheckoutInfoState();
}

class _UserCheckoutInfoState extends State<UserCheckoutInfo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Duration _duration = const Duration(milliseconds: 500);

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
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
          const Text("Order Type:"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ToggleCheckout(),
          ),
          const AddressCard(),
        ],
      ),
    );
  }
}

class TextFieldProperty extends Equatable {
  IconData icon;
  String label;
  TextEditingController txtCtrl;
  TextInputType type;
  VoidCallback? fn;
  TextFieldProperty(
      {required this.icon,
      required this.label,
      required this.txtCtrl,
      required this.type,
      this.fn});

  @override
  List<Object> get props => [icon, label, txtCtrl, type];
}
