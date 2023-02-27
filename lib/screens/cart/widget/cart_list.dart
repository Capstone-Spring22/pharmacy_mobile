import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/widgets/quan_control.dart';

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
                if (controller.listCart[index].product.imageModel == null)
                  Lottie.asset('assets/lottie/capsule_loading.json'),
                if (controller.listCart[index].product.imageModel != null)
                  CachedNetworkImage(
                    imageUrl: controller
                        .listCart[index].product.imageModel!.imageURL!,
                    placeholder: (context, url) =>
                        Lottie.asset('assets/lottie/capsule_loading.json'),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                AutoSizeText(
                  controller.listCart[index].product.name.toString(),
                  maxLines: 2,
                  style: context.textTheme.headlineSmall,
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
                          convertCurrency(controller.listCart[index].price),
                          style: context.theme.primaryTextTheme.bodyLarge!
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          QuantityControl(controller.listCart[index].product),
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
