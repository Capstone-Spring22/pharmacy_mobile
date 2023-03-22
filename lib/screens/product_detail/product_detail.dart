import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/models/product_detail.dart';
import 'package:pharmacy_mobile/screens/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/screens/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/screens/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/screens/home/widgets/drawer_btn.dart';
import 'package:pharmacy_mobile/screens/product_detail/widgets/add_to_cart.dart';
import 'package:pharmacy_mobile/screens/product_detail/widgets/content_info.dart';
import 'package:pharmacy_mobile/screens/product_detail/widgets/image_view.dart';
import 'package:pharmacy_mobile/screens/product_detail/widgets/ingredeent.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

import '../../models/description.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
              future: ProductService().getProductDetail(product.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      CachedNetworkImage(
                        height: Get.height * .3,
                        imageUrl: product.imageModel!.imageURL!,
                        width: double.infinity,
                      ),
                      ...infoWidget(context),
                      LoadingWidget(
                        size: 60,
                      )
                    ],
                  );
                } else if (snapshot.data is String) {
                  return const Text("Empty Error");
                } else {
                  final detail = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * .3,
                        width: double.infinity,
                        child: ImageList(
                          imageUrls: detail!.imageModels!
                              .map((e) => e.imageURL!)
                              .toList(),
                        ),
                      ),
                      ...infoWidget(context),
                      ...descriptionWidgets(detail.descriptionModels!)
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List descriptionWidgets(DescriptionModels desc) {
    return [
      if (desc.effect != 'string')
        ContentInfo(
          title: "Effect",
          content: desc.effect!,
        ),
      if (desc.instruction != 'string')
        ContentInfo(
          title: "Instruction",
          content: desc.instruction!,
        ),
      if (desc.sideEffect != 'string')
        ContentInfo(
          title: "SideEffect",
          content: desc.sideEffect!,
        ),
      if (desc.contraindications != 'string')
        ContentInfo(
          title: "Contraindications",
          content: desc.contraindications!,
        ),
      if (desc.preserve != 'string')
        ContentInfo(
          title: "Preserve",
          content: desc.preserve!,
        ),
      if (desc.ingredientModel!.isNotEmpty)
        IngredientsText(
          ingre: desc.ingredientModel!,
        )
    ];
  }

  List infoWidget(BuildContext context) {
    return [
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
                "Price: ${convertCurrency(num.parse(product.price.toString()))}",
                textAlign: TextAlign.center,
                style: detailPrice.copyWith(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List infoWidgetDetail(BuildContext context, PharmacyDetail detail) {
    return [
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
                "${convertCurrency(num.parse(product.price.toString()))}/${detail.unitName}",
                textAlign: TextAlign.center,
                style: detailPrice.copyWith(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
