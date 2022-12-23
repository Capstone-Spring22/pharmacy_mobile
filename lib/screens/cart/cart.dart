import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: AutoSizeText(
          textAlign: TextAlign.center,
          "Cart",
          maxLines: 1,
          style: context.textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            AutoSizeText(
              "${"items".tr}:",
              style: context.textTheme.headlineSmall,
            ),
            const Expanded(child: CartItemListView()),
          ],
        ),
      ),
    );
  }
}

class CartItemListView extends StatelessWidget {
  const CartItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(builder: (controller) {
      if (controller.listCart.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.listCart.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Image.network(
                  controller.listCart[index].product.img,
                ),
                AutoSizeText(
                  controller.listCart[index].product.name.toString(),
                  maxLines: 2,
                  style: context.textTheme.headlineSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedSwitcher(
                      key: UniqueKey(),
                      switchInCurve: Curves.easeIn,
                      duration: const Duration(milliseconds: 300),
                      child: AutoSizeText(
                        "${controller.listCart[index].price.toString()} VND",
                        style: context.textTheme.headlineSmall,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => controller
                              .decreaseQuan(controller.listCart[index]),
                          icon: const Icon(Icons.remove),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          // child: Text(
                          //   controller.listCart[index].quantity.toString(),
                          //   maxLines: 1,
                          // ),
                          child: AnimatedSwitcher(
                            key: UniqueKey(),
                            switchInCurve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              controller.listCart[index].quantity.toString(),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => controller
                              .increaseQuan(controller.listCart[index]),
                          icon: const Icon(Icons.add),
                        )
                      ],
                    )
                  ],
                ),
              ],
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
