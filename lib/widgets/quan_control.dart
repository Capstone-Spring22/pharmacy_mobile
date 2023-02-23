import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/models/product.dart';

class QuantityControl extends GetView<CartController> {
  const QuantityControl(this.product, {super.key});

  final PharmacyProduct product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var focusNode = FocusNode();
        TextEditingController txt = TextEditingController();
        focusNode.requestFocus();
        Get.defaultDialog(
          buttonColor: context.theme.primaryColor,
          cancelTextColor: context.theme.primaryColor,
          // content: QuantityEditSheet(productId: product.id),
          title: "Edit Quantity",
          barrierDismissible: true,
          content: TextFormField(
            focusNode: focusNode,
            controller: txt,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Enter Quantity",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    BorderSide(color: context.theme.highlightColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: context.theme.primaryColor, width: 2),
              ),
            ),
          ),
          onConfirm: () {
            controller.updateQuantity(
              product.id,
              num.parse(txt.text),
            );
            Get.back();
          },
          onCancel: () {},
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(),
          ),
          GestureDetector(
            onTap: () =>
                controller.decreaseQuan(controller.cartItem(id: product.id)),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.theme.primaryColor,
                  width: 2.0,
                ),
              ),
              child: const Icon(Icons.remove),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            controller.listCart
                .firstWhere((element) => element.product == product)
                .quantity
                .toString(),
            style: tileTitle.copyWith(fontSize: 18),
          ),
          Expanded(
            child: Container(),
          ),
          GestureDetector(
            onTap: () =>
                controller.increaseQuan(controller.cartItem(id: product.id)),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.theme.primaryColor,
                  width: 2.0,
                ),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
