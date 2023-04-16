import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/views/cart/cart.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * 0.8,
      // backgroundColor: Colors.transparent,
      child: const CartScreen(),
    );
  }
}
