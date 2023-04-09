import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/widgets/quan_control.dart';

class CartItemListView extends GetView<CartController> {
  const CartItemListView({super.key});

  String? extractUname(String uid) {
    for (var product in productController.products) {
      Get.log(product.name!);
      Get.log(uid);
      try {
        var productRef = product.productUnitReferences!.singleWhere(
          (productRef) {
            Get.log("$uid > ${productRef.id} -- ${productRef.unitName}");
            return productRef.id == uid;
          },
        );
        return productRef.unitName;
      } catch (e) {}
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(builder: (controller) {
      if (controller.listCart.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.listCart.length,
          itemBuilder: (context, index) {
            final item = controller.listCart[index];
            Get.log(item.productId!);
            final unitName = extractUname(item.productId!);
            return GestureDetector(
              onTap: () => Get.toNamed(
                '/product_detail',
                arguments: item.productId,
                preventDuplicates: false,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    if (item.productImageUrl == null) LoadingWidget(),
                    if (item.productImageUrl != null)
                      CachedNetworkImage(
                        imageUrl: item.productImageUrl!,
                        placeholder: (context, url) => LoadingWidget(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        item.productName.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: AnimatedSwitcher(
                            key: UniqueKey(),
                            switchInCurve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                            child: AutoSizeText(
                              item.priceAfterDiscount!.convertCurrentcy(),
                              style: context.theme.primaryTextTheme.bodyLarge!
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          child: QuantityControl(item.productId!),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            unitName!,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        return const Center(
          child: Text(
            "Empty",
          ),
        );
      }
    });
  }
}
