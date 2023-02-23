import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    draggableScrollableController.dispose();
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
              maxChildSize: .9,
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
              child:
                  Text("Total ${convertCurrency(cartController.getTotal())}"),
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
        height: Get.height * .8,
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
          SlideTransition(
            position: _animationController.drive(_offsetTween),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: context.theme.primaryColor,
                ),
                Expanded(
                  child: Input(
                    inputController: checkoutCtrl.nameCtl,
                    title: "Name",
                  ),
                ),
              ],
            ),
          ),
          SlideTransition(
            position: _animationController.drive(_offsetTween),
            child: Row(
              children: [
                Icon(
                  Icons.home,
                  color: context.theme.primaryColor,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed('/address');
                    },
                    child: Input(
                      enabled: false,
                      inputController: checkoutCtrl.address,
                      title: "Address",
                      inputType: TextInputType.streetAddress,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SlideTransition(
            position: _animationController.drive(_offsetTween),
            child: Row(
              children: [
                Icon(
                  Icons.phone,
                  color: context.theme.primaryColor,
                ),
                Expanded(
                  child: Input(
                    inputController: checkoutCtrl.phoneCtl,
                    title: "Phone",
                    inputType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
