import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/screens/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/screens/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/screens/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/screens/home/widgets/drawer_btn.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

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
        child: SizedBox(
          height: Get.height * .9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (product.imageModel == null)
                Lottie.asset('assets/lottie/capsule_loading.json'),
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
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: GetX<CartController>(
                  builder: (controller) {
                    bool isInCart = controller.listCart
                        .any((element) => element.product == product);

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: isInCart
                          ? QuantityControlDetail(product)
                          : FilledButton(
                              onPressed: () => controller.addToCart(CartItem(
                                product: product,
                                quantity: 1,
                                price: num.parse(product.price.toString()),
                              )),
                              child: const Text("Add to Cart"),
                            ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuantityControlDetail extends GetView<CartController> {
  const QuantityControlDetail(this.product, {super.key});

  final PharmacyProduct product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var focusNode = FocusNode();
        TextEditingController txt = TextEditingController();
        focusNode.requestFocus();
        Get.defaultDialog(
          buttonColor: context.theme.primaryColor,
          cancelTextColor: context.theme.primaryColor,
          // content: QuantityEditSheet(productId: product.id),
          title: "Edit Quantity",
          barrierDismissible: true,
          content: TextFormField(
            focusNode: focusNode,
            controller: txt,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Enter Quantity",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    BorderSide(color: context.theme.highlightColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: context.theme.primaryColor, width: 2),
              ),
            ),
          ),
          onConfirm: () {
            controller.updateQuantity(
              product.id!,
              num.parse(txt.text),
            );
            Get.back();
          },
          onCancel: () {},
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(),
          ),
          GestureDetector(
            onTap: () =>
                controller.decreaseQuan(controller.cartItem(id: product.id)),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.theme.primaryColor,
                  width: 2.0,
                ),
              ),
              child: const Icon(Icons.remove),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            controller.listCart
                .firstWhere((element) => element.product == product)
                .quantity
                .toString(),
            style: tileTitle.copyWith(fontSize: 18),
          ),
          Expanded(
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: FilledButton(
              onPressed: () =>
                  controller.increaseQuan(controller.cartItem(id: product.id)),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.theme.primaryColor,
                    width: 2.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.add), Text("Add more")],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
