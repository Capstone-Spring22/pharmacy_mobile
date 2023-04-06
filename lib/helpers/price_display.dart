import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/views/home/widgets/product_tile.dart';

extension PriceConvert on num {
  String convertCurrentcy() {
    return NumberFormat.currency(locale: 'vi', symbol: 'đ').format(this);
  }
}

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
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: context.theme.primaryColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: displayPrice(
                            e.price!,
                            e.priceAfterDiscount!,
                            e.unitName!,
                          ),
                        ),
                      ),
                      if (!product.isPrescription!)
                        Expanded(
                          flex: 2,
                          child: BuyButton(
                            id: e.id!,
                            price: e.price!,
                            priceAfterDiscount: e.priceAfterDiscount!,
                          ),
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
