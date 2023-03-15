import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
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
            final item = productController
                .getProductById(controller.listCart[index].pid);
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (item.imageModel == null)
                    Lottie.asset('assets/lottie/capsule_loading.json'),
                  if (item.imageModel != null)
                    CachedNetworkImage(
                      imageUrl: item.imageModel!.imageURL!,
                      placeholder: (context, url) => LoadingWidget(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AutoSizeText(
                      item.name.toString(),
                      maxLines: 2,
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        // child: AnimatedSwitcher(
                        //   key: UniqueKey(),
                        //   switchInCurve: Curves.easeIn,
                        //   duration: const Duration(milliseconds: 300),
                        //   child: AutoSizeText(
                        //     convertCurrency(controller.listCart[index].price),
                        //     style: context.theme.primaryTextTheme.bodyLarge!
                        //         .copyWith(color: Colors.black),
                        //   ),
                        // ),
                        child: AnimatedTextKit(
                          key: UniqueKey(),
                          animatedTexts: [
                            TyperAnimatedText(
                              convertCurrency(controller.listCart[index].price),
                              textStyle: const TextStyle(fontSize: 20.0),
                              speed: const Duration(milliseconds: 50),
                            ),
                          ],
                          totalRepeatCount: 1,
                        ),
                      ),
                      Expanded(
                        child: QuantityControl(item),
                      )
                    ],
                  ),
                ],
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
