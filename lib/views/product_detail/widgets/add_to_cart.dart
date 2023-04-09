import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/views/product_detail/widgets/quantity.dart';

class AddToCartDetail extends StatelessWidget {
  const AddToCartDetail(
      {super.key,
      required this.id,
      required this.price,
      this.isMini = false,
      required this.unit});

  final String id;
  final num price;
  final bool isMini;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GetX<CartController>(
        builder: (controller) {
          bool isInCart = controller.listCart.any(
            (element) => element.productId! == id,
          );
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: isInCart
                ? QuantityControlDetail(id)
                : SizedBox(
                    width: isMini ? Get.width * .3 : Get.width * .5,
                    child: FilledButton(
                      onPressed: () => controller.addToCart(CartItem(
                        productId: id,
                        quantity: 1,
                        price: price,
                        unitName: unit,
                      )),
                      child: const Text("Thêm vào giỏ"),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
