import 'package:flutter/material.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.arguments['orderId'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Detail"),
      ),
    );
  }
}
