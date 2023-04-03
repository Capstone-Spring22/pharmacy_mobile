import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/screens/product_detail/widgets/quantity.dart';

class AddToCartDetail extends StatelessWidget {
  const AddToCartDetail(this.product, {super.key});

  final PharmacyProduct product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GetX<CartController>(
        builder: (controller) {
          bool isInCart = controller.listCart
              .any((element) => element.productId! == product.id);
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: isInCart
                ? QuantityControlDetail(product.id!)
                : SizedBox(
                    width: Get.width * .5,
                    child: FilledButton(
                      onPressed: () => controller.addToCart(CartItem(
                        productId: product.id!,
                        quantity: 1,
                        price: int.parse(product.price.toString()),
                      )),
                      child: const Text("Add to Cart"),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
