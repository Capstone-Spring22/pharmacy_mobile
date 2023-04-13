// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, unused_field
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';

import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/views/checkout/widget/checkout_panel.dart';
import 'package:pharmacy_mobile/views/checkout/widget/list_checkout.dart';

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
    checkoutController.isCollase.value = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán"),
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
                checkoutController.scrollController = scrollController.obs;
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
                        draggableScrollableController,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            top: Get.height * .82,
            child: Obx(() {
              String txt =
                  "Tổng cộng ${cartController.calculateTotal().convertCurrentcy()} + 25.000₫ Phí ship";
              if (checkoutController.checkoutType.value != 0) {
                txt =
                    "Tổng cộng ${cartController.calculateTotal().convertCurrentcy()}";
              }
              return FilledButton(
                onPressed: checkoutController.activeBtn.isFalse
                    ? null
                    : () {
                        if (checkoutController.isCollase.value) {
                          if (checkoutController
                                  .scrollController.value!.position.pixels ==
                              checkoutController.scrollController.value!
                                  .position.maxScrollExtent) {
                            checkoutController.createOrder();
                          } else {
                            checkoutController.scrollController.value
                                ?.animateTo(
                              checkoutController.scrollController.value!
                                  .position.maxScrollExtent,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            );
                          }
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
                    ? const Text("Giỏ hàng trống")
                    : Text(txt),
              );
            }),
          )
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
