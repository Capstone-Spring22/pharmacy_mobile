import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/widgets/quan_control.dart';

class CartItemListView extends GetView<CartController> {
  const CartItemListView({super.key});

  String? extractUname(String uid) {
    for (var product in productController.products) {
      try {
        var productRef = product.productUnitReferences!.singleWhere(
          (productRef) {
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
        List<List<CartItem>> tempList =
            controller.listCart.value.groupProductsByName();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: tempList.length,
          itemBuilder: (context, index) {
            final item = tempList[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.theme.primaryColor),
                ),
                child: GestureDetector(
                  onTap: () => Get.toNamed(
                    '/product_detail',
                    arguments: [item[0].productId],
                    preventDuplicates: false,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        if (item[0].productImageUrl == null)
                          const LoadingWidget(),
                        if (item[0].productImageUrl != null)
                          CachedNetworkImage(
                            imageUrl: item[0].productImageUrl!,
                            placeholder: (context, url) =>
                                const LoadingWidget(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            item[0].productName.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        ...item.map(
                          (e) {
                            final unitName = extractUname(e.productId!);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          (e.priceAfterDiscount ?? e.price)!
                                              .convertCurrentcy(),
                                          style: context
                                              .theme.primaryTextTheme.bodyLarge!
                                              .copyWith(color: Colors.black),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: QuantityControl(e.productId!),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: AutoSizeText(
                                        unitName!,
                                        maxLines: 1,
                                        style: context.textTheme.bodyLarge,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return const Center(
          child: Text(
            "Giỏ hàng trống",
          ),
        );
      }
    });
  }
}
