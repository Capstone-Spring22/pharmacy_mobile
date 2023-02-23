import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                                var item = ctl.listCart[index];
                                return ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  child: Image.network(
                                    item.product.img,
                                    width: Get.width * 0.25,
                                    height: Get.width * 0.25,
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
                              var item = ctl.listCart[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: Image.network(item.product.img),
                                  title: Text(
                                    item.product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Quantity: ${item.quantity}"),
                                      Text(convertCurrency(item.price)),
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
