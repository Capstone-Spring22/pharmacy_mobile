import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';

class QuantityEditSheet extends GetView<CartController> {
  const QuantityEditSheet({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    TextEditingController txt = TextEditingController();
    // CartItem item = controller.cartItem(id: productId);
    return TextFormField(
      controller: txt,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter Quantity",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: context.theme.highlightColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: context.theme.primaryColor, width: 2),
        ),
      ),
    );
  }
}
