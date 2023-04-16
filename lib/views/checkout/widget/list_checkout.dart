import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/views/checkout/widget/hori_list.dart';

import '../../../controllers/checkout_controller.dart';

class ListCheckout extends StatelessWidget {
  const ListCheckout({super.key});

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
    CheckoutController checkoutController = Get.find();
    return Container(
      alignment: Alignment.topCenter,
      height: Get.height * 0.78,
      width: Get.width,
      child: Obx(() {
        List<List<CartItem>> tempList =
            cartController.listCart.groupProductsByName();
        return AnimatedContainer(
          height: checkoutController.isCollase.value
              ? Get.height * .2
              : Get.height * .8,
          duration: const Duration(milliseconds: 300),
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: checkoutController.isCollase.value
                  ? HorizontalList(cartController)
                  : ListView.builder(
                      key: UniqueKey(),
                      // itemCount: ctl.listCart.length,
                      itemCount: tempList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final item = tempList[index];
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            '/product_detail',
                            arguments: item[0].productId,
                            preventDuplicates: false,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xfff6f5f8),
                                    spreadRadius: 10,
                                    blurRadius: 10,
                                    offset: Offset(
                                      0,
                                      3,
                                    ),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: item[0].productImageUrl == null
                                    ? const LoadingWidget()
                                    : CachedNetworkImage(
                                        height: Get.height * .1,
                                        width: Get.width * .15,
                                        imageUrl: item[0].productImageUrl!,
                                        placeholder: (context, url) =>
                                            const LoadingWidget(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                title: Text(
                                  item[0].productName!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Column(
                                  children: [
                                    ...item.map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Số lượng: ${e.quantity} ${extractUname(e.productId!)!}"),
                                            const Spacer(),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Giá: ${e.priceAfterDiscount!.convertCurrentcy()}",
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .slideX(delay: (index * 150).ms, begin: 1)
                            .fade(delay: (index * 150).ms);
                      },
                    )),
        );
      }),
    );
  }
}
