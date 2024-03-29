import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/views/cart/widget/cart_list.dart';
import 'package:pharmacy_mobile/views/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: "title".tr,
        rightWidget: const CartButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Expanded(child: CartItemListView()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: SizedBox(
                width: Get.width * 0.5,
                child: FilledButton(
                  onPressed: () {
                    if (cartController.listCart.isEmpty) {
                      Get.showSnackbar(GetSnackBar(
                        message: "Hãy thêm sản phẩm vào giỏ",
                        duration: 3.seconds,
                        mainButton: IconButton(
                          onPressed: () {
                            Get.closeAllSnackbars();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                        ),
                      ));
                    } else {
                      Get.toNamed("/checkout");
                    }
                  },
                  child: const Text("Thanh toán"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
