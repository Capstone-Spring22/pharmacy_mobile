import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/screens/checkout/checkout.dart';

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
                    ? Get.height * .08
                    : Get.height * .8,
                duration: const Duration(milliseconds: 300),
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.isCollase.value
                        ? SizedBox(
                            height: Get.height * .08,
                            key: UniqueKey(),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                // var item = ctl.listCart[index];
                                final item = productController
                                    .getProductById(ctl.listCart[index].pid);
                                return ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  // child: Image.network(
                                  //   item.product.img,
                                  //   width: Get.width * 0.25,
                                  //   height: Get.width * 0.25,
                                  // ),

                                  child: item.imageModel == null
                                      ? Lottie.asset(
                                          'assets/lottie/capsule_loading.json',
                                          width: Get.width * 0.25,
                                          height: Get.width * 0.25,
                                        )
                                      : CachedNetworkImage(
                                          width: Get.width * 0.25,
                                          height: Get.width * 0.25,
                                          imageUrl: item.imageModel!.imageURL!,
                                          placeholder: (context, url) =>
                                              Lottie.asset(
                                                  'assets/lottie/capsule_loading.json'),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                );
                              },
                              itemCount: ctl.listCart.length,
                            ),
                          )
                        : ListView.builder(
                            key: UniqueKey(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final item = productController
                                  .getProductById(ctl.listCart[index].pid);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: item.imageModel == null
                                      ? Lottie.asset(
                                          'assets/lottie/capsule_loading.json')
                                      : CachedNetworkImage(
                                          imageUrl: item.imageModel!.imageURL!,
                                          placeholder: (context, url) =>
                                              Lottie.asset(
                                                  'assets/lottie/capsule_loading.json'),
                                          errorWidget: (context, url, error) =>
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
                                      Text(convertCurrency(
                                          item.priceAfterDiscount!)),
                                    ],
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
