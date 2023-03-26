import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/screens/checkout/widget/hori_list.dart';

import '../../../controllers/checkout_controller.dart';

class ListCheckout extends StatelessWidget {
  const ListCheckout({super.key});

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
                              final item = productController
                                  .getProductById(ctl.listCart[index].pid);
                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                  '/product_detail',
                                  arguments: item.id,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    leading: item.imageModel == null
                                        ? LoadingWidget()
                                        : CachedNetworkImage(
                                            imageUrl:
                                                item.imageModel!.imageURL!,
                                            placeholder: (context, url) =>
                                                LoadingWidget(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                    title: Text(
                                      item.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                            "Quantity: ${ctl.listCart[index].quantity}"),
                                        Text(
                                          convertCurrency(
                                              item.priceAfterDiscount!),
                                        ),
                                      ],
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
