import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/screens/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/screens/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/screens/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/screens/home/widgets/drawer_btn.dart';
import 'package:pharmacy_mobile/screens/product_detail/widgets/add_to_cart.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

import '../../helpers/loading.dart';

class ProductDetailScreen extends GetView<AppController> {
  const ProductDetailScreen(
    this.product, {
    super.key,
  });

  final PharmacyProduct product;

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> drawerKey = GlobalKey();
    return Scaffold(
      bottomNavigationBar: SizedBox(
        width: Get.width,
        height: Get.height * .08,
        child: AddToCartDetail(product),
      ),
      key: drawerKey,
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: Row(
          children: [
            const PharmacyBackButton(),
            DrawerButton(fn: () => drawerKey.currentState!.openDrawer()),
          ],
        ),
        midText: "title".tr,
        rightWidget:
            CartButton(fn: () => drawerKey.currentState!.openEndDrawer()),
        titleStyle: context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
      ),
      // body: SingleChildScrollView(
      //   child: SizedBox(
      //     height: Get.height * .9,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         if (product.imageModel == null) LoadingWidget(),
      //         if (product.imageModel != null)
      //           CachedNetworkImage(
      //             imageUrl: product.imageModel!.imageURL!,
      //             width: double.infinity,
      //           ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 15),
      //           child: AutoSizeText(
      //             product.name!,
      //             maxLines: 3,
      //             style: context.textTheme.labelLarge!.copyWith(fontSize: 24),
      //           ),
      //         ),
      //         SizedBox(
      //           height: Get.height * .08,
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               Expanded(
      //                 child: Text(
      //                   convertCurrency(num.parse(product.price.toString())),
      //                   textAlign: TextAlign.center,
      //                   style: detailPrice.copyWith(color: Colors.blue),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Expanded(child: Container()),
      //         AddToCartDetail(product)
      //       ],
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (product.imageModel == null) LoadingWidget(),
            if (product.imageModel != null)
              CachedNetworkImage(
                imageUrl: product.imageModel!.imageURL!,
                width: double.infinity,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: AutoSizeText(
                product.name!,
                maxLines: 3,
                style: context.textTheme.labelLarge!.copyWith(fontSize: 24),
              ),
            ),
            SizedBox(
              height: Get.height * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      convertCurrency(num.parse(product.price.toString())),
                      textAlign: TextAlign.center,
                      style: detailPrice.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
