import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';

class QuantityControl extends GetView<CartController> {
  const QuantityControl(this.productId, {super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final count = controller.listCart
        .singleWhere((element) => element.productId == productId)
        .quantity;
    return GestureDetector(
      onTap: () {
        var focusNode = FocusNode();
        TextEditingController txt = TextEditingController();
        focusNode.requestFocus();
        Get.defaultDialog(
          buttonColor: context.theme.primaryColor,
          cancelTextColor: context.theme.primaryColor,
          // content: QuantityEditSheet(productId: product.id),
          title: "Sửa số lượng",
          barrierDismissible: true,
          content: TextFormField(
            focusNode: focusNode,
            controller: txt,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Nhập số lượng",
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
            controller.customQuan(
              productId,
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
            onTap: () => controller.decreaseQuan(productId),
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
            count.toString(),
            style: tileTitle.copyWith(fontSize: 18),
          ),
          Expanded(
            child: Container(),
          ),
          GestureDetector(
            onTap: () => controller.increaseQuan(productId),
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
