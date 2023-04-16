import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/views/product_detail/widgets/add_to_cart.dart';

List<Widget> displayPrice(num price, num priceAfterDiscount, String unit) {
  if (price == priceAfterDiscount) {
    return [
      AutoSizeText(
        "$unit: ${priceAfterDiscount.convertCurrentcy()}",
        style: detailPrice.copyWith(
          color: Get.context!.theme.primaryColor,
        ),
      ),
    ];
  } else {
    return [
      AutoSizeText(
        "$unit:",
        style: detailPrice.copyWith(
          color: Get.context!.theme.primaryColor,
        ),
      ),
      AutoSizeText(
        priceAfterDiscount.convertCurrentcy(),
        style: detailPrice.copyWith(
          color: Get.context!.theme.primaryColor,
        ),
      ),
      AutoSizeText(
        price.convertCurrentcy(),
        style: detailPrice.copyWith(
          decoration: TextDecoration.lineThrough,
          color: Colors.grey,
          fontSize: 18,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Get.context!.theme.primaryColor),
          color: Get.context!.theme.primaryColor,
        ),
        padding: const EdgeInsets.all(5),
        child: AutoSizeText(
          "-${(priceAfterDiscount * 100 / price).round()}%",
          style: detailPrice.copyWith(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    ];
  }
}

class ListPrice extends GetView<CartController> {
  const ListPrice(this.product, {super.key});

  final PharmacyProduct product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...product.productUnitReferences!.map(
          (e) => Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  // border: Border.all(color: context.theme.primaryColor),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xfff6f5f8),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    runAlignment: WrapAlignment.spaceEvenly,
                    alignment: WrapAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: displayPrice(
                          e.price!,
                          e.priceAfterDiscount!,
                          e.unitName!,
                        ),
                      ),
                      if (!product.isPrescription!)
                        AddToCartDetail(
                          id: e.id!,
                          price: product.priceAfterDiscount!,
                          unit: e.unitName!,
                        ),
                    ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
