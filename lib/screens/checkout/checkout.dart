// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/screens/address/address.dart';
import 'package:pharmacy_mobile/screens/checkout/widget/list_checkout.dart';
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
        actions: [
          Switch(
            value: vl,
            onChanged: (value) => setState(() {
              vl = value;
            }),
          )
        ],
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
                  : Text("Total ${convertCurrency(cartController.getTotal())}"),
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
  final Tween<Offset> _offsetTween = Tween(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  );
  late Animation<Offset> _animation1, _animation2, _animation3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _duration,
      vsync: this,
    );

    _animation1 = Tween<Offset>(begin: const Offset(1.5, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: const Interval(0.0, 0.5)));

    _animation2 = Tween<Offset>(begin: const Offset(1.5, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: const Interval(0.3, 0.8)));

    _animation3 = Tween<Offset>(begin: const Offset(1.5, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: const Interval(0.6, 1.0)));

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
    List<TextFieldProperty> listTextField = [
      TextFieldProperty(
          icon: Icons.person,
          label: "Name",
          txtCtrl: checkoutCtrl.nameCtl,
          type: TextInputType.name),
      TextFieldProperty(
          icon: Icons.home,
          label: "Address",
          txtCtrl: checkoutCtrl.address,
          type: TextInputType.streetAddress,
          fn: () {
            Get.put(AddressController());
            showModalBottomSheet(
              useSafeArea: true,
              enableDrag: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              builder: (context) {
                return const AddressSelectionScreen();
              },
            );
          }),
      TextFieldProperty(
          icon: Icons.phone,
          label: "Phone Number",
          txtCtrl: checkoutCtrl.phoneCtl,
          type: TextInputType.phone),
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .05,
          ),
          // SlideTransition(
          //   position: _animation1,
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.person,
          //         color: context.theme.primaryColor,
          //       ),
          //       Expanded(
          //         child: Input(
          //           inputController: checkoutCtrl.nameCtl,
          //           title: "Name",
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SlideTransition(
          //   position: _animation2,
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.home,
          //         color: context.theme.primaryColor,
          //       ),
          //       Expanded(
          //         child: GestureDetector(
          //           onTap: () {
          //             Get.put(AddressController());
          //             showModalBottomSheet(
          //               useSafeArea: true,
          //               enableDrag: true,
          //               shape: const RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.vertical(
          //                       top: Radius.circular(25.0))),
          //               context: context,
          //               builder: (context) {
          //                 return const AddressSelectionScreen();
          //               },
          //             );
          //           },
          //           child: Input(
          //             enabled: false,
          //             centerText: true,
          //             inputController: checkoutCtrl.address,
          //             title: "Address",
          //             inputType: TextInputType.streetAddress,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SlideTransition(
          //   position: _animation3,
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.phone,
          //         color: context.theme.primaryColor,
          //       ),
          //       Expanded(
          //         child: Input(
          //           inputController: checkoutCtrl.phoneCtl,
          //           title: "Phone",
          //           inputType: TextInputType.phone,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SlideTransition(
          //   position: _animation3,
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.phone,
          //         color: context.theme.primaryColor,
          //       ),
          //       Expanded(
          //         child: Input(
          //           inputController: checkoutCtrl.phoneCtl,
          //           title: "Phone",
          //           inputType: TextInputType.phone,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return SlideTransition(
                  position: getSlideTransition(index),
                  child: GestureDetector(
                    onTap: listTextField[index].fn,
                    child: Row(
                      children: [
                        Icon(
                          listTextField[index].icon,
                          color: context.theme.primaryColor,
                        ),
                        Expanded(
                          child: Input(
                            enabled: listTextField[index].fn == null,
                            inputController: listTextField[index].txtCtrl,
                            title: listTextField[index].label,
                            inputType: listTextField[index].type,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: listTextField.length,
            ),
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
