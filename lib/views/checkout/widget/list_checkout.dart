import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/views/checkout/widget/hori_list.dart';

import '../../../controllers/checkout_controller.dart';

class ListCheckout extends StatelessWidget {
  const ListCheckout({super.key});

  String? extractUname(String uid) {
    for (var product in productController.products) {
      Get.log(product.name!);
      Get.log(uid);
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
    return Container(
      alignment: Alignment.topCenter,
      height: Get.height * 0.78,
      width: Get.width,
      child: GetBuilder<CartController>(
        builder: (ctl) {
          return GetX<CheckoutController>(
            builder: (controller) {
              return AnimatedContainer(
                height: controller.isCollase.value
                    ? Get.height * .2
                    : Get.height * .8,
                duration: const Duration(milliseconds: 300),
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.isCollase.value
                        ? HorizontalList(ctl)
                        : ListView.builder(
                            key: UniqueKey(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final item = ctl.listCart[index];
                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                  '/product_detail',
                                  arguments: item.productId,
                                  preventDuplicates: false,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: item.productImageUrl == null
                                        ? LoadingWidget()
                                        : CachedNetworkImage(
                                            height: Get.height * .1,
                                            width: Get.width * .15,
                                            imageUrl: item.productImageUrl!,
                                            placeholder: (context, url) =>
                                                LoadingWidget(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                    title: Text(
                                      item.productName!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Số lượng: ${ctl.listCart[index].quantity} ${extractUname(item.productId!)!}"),
                                          Expanded(flex: 1, child: Container()),
                                          Text(
                                            "Giá: ${item.priceAfterDiscount!.convertCurrentcy()}",
                                          ),
                                          Expanded(flex: 3, child: Container()),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: ctl.listCart.length,
                          )),
              );
            },
          );
        },
      ),
    );
  }
}
