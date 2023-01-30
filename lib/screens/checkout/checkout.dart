import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/screens/checkout/widget/checkout_drag_controller.dart';
import 'package:pharmacy_mobile/screens/checkout/widget/input_field.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  final double headerHeight = 0;

  @override
  Widget build(BuildContext context) {
    final checkoutController = CheckoutController();
    void _onVerticalDrag(DragUpdateDetails details) {
      if (details.primaryDelta! < -2) {
        checkoutController.changeCheckoutState(CheckoutState.extended);
      } else if (details.primaryDelta! > 2.8) {
        checkoutController.changeCheckoutState(CheckoutState.normal);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('checkout'.tr),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          color: const Color(0xFFEAEAEA),
          child: AnimatedBuilder(
              animation: checkoutController,
              builder: (context, snapshot) {
                Widget pullupNoti = Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_upward_outlined),
                    AutoSizeText("Pull up to Checkout"),
                  ],
                );
                return LayoutBuilder(builder: (context, constrains) {
                  return Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: checkoutController.state == CheckoutState.normal
                            ? Get.height * 0.78
                            : Get.height * 0.15,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: GetX<CartController>(builder: (controller) {
                          var list = controller.listCart.value;
                          Widget emptyText = const Center(
                              child: Text("Your Cart is Empty!!!"));
                          Widget rowCartItem = GestureDetector(
                            onVerticalDragUpdate: _onVerticalDrag,
                            onTap: () => checkoutController
                                .changeCheckoutState(CheckoutState.extended),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: controller.listCart
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 100.0,
                                              width: 100.0,
                                              child: Card(
                                                  child: Column(
                                                children: [
                                                  Hero(
                                                    tag: e.product.img,
                                                    child: Image.network(
                                                      e.product.img,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  Text(
                                                    e.product.name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                ],
                                              )),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          );
                          Widget viewList = ImplicitlyAnimatedList(
                            itemData: list,
                            itemBuilder: (_, data) {
                              return ListTile(
                                leading: Hero(
                                  tag: data.product.img,
                                  child: Image.network(data.product.img),
                                ),
                                title: AutoSizeText(
                                  data.product.name,
                                  maxLines: 2,
                                ),
                                subtitle: Column(
                                  children: [
                                    Align(
                                      heightFactor: 2,
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "${data.price.toString()} VND",
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              controller.decreaseQuan(data),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white)),
                                          child: AnimatedSwitcher(
                                            key: UniqueKey(),
                                            switchInCurve: Curves.easeIn,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Text(
                                              data.quantity.toString(),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              controller.increaseQuan(data),
                                          icon: const Icon(Icons.add),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: list.isEmpty
                                ? emptyText
                                : checkoutController.state ==
                                        CheckoutState.normal
                                    ? viewList
                                    : rowCartItem,
                          );
                        }),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onVerticalDragUpdate: _onVerticalDrag,
                              onTap: () => checkoutController
                                  .changeCheckoutState(CheckoutState.extended),
                              child: Stack(
                                children: [
                                  Container(
                                    height: Get.height * 0.1,
                                    color: Colors.transparent,
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.1,
                                    child: GetX<CartController>(
                                      builder: (controller) {
                                        num subtotal = 0;
                                        for (var element
                                            in controller.listCart) {
                                          subtotal += element.price;
                                        }

                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            priceView("Subtotal:", subtotal),
                                            priceView("Shipping:", subtotal),
                                            priceView("Total:", subtotal),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: checkoutController.state ==
                                        CheckoutState.normal
                                    ? pullupNoti
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          children: [
                                            InputField(
                                              inputController:
                                                  TextEditingController(),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                });
              }),
        ),
      ),
    );
  }

  Widget priceView(String txt, num price) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            txt,
            style: const TextStyle(fontSize: 20),
          ),
          AutoSizeText(
            "$price VND",
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
