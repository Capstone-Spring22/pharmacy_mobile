import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widget/list_checkout.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  double topPad = 0.1;
  double bottomPad = 0.8;
  double _top = 0;
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
          IconButton(
            onPressed: () => checkoutController.isCollase.toggle(),
            icon: const Icon(Icons.switch_camera),
          )
        ],
      ),
      body: Stack(
        children: [
          const ListCheckout(),
          // const InfoPanel(),
          DraggableScrollableSheet(
            snap: true,
            initialChildSize: .1,
            minChildSize: .1,
            maxChildSize: .9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => const Text("data"),
                  itemCount: 20,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class CheckoutController extends GetxController {
  RxBool isCollase = false.obs;
}
