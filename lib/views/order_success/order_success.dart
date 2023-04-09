import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Success"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LottieBuilder.asset(
              'assets/lottie/success.json',
              frameRate: FrameRate.max,
              repeat: false,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    const ['**'],
                    value: context.theme.primaryColor,
                  ),
                ],
              ),
            ),
            Text(
              "Mã đơn",
              style: context.textTheme.titleLarge,
            ),
            Text(
              id,
              style: context.textTheme.titleLarge,
            ),
            Text(
              "đã được đặt thành công",
              style: context.textTheme.titleLarge,
            ),
            SizedBox(
              width: Get.width * .7,
              height: Get.height * .05,
              child: FilledButton(
                onPressed: () => Get.toNamed('/order_detail', arguments: id),
                child: const Text("Xem đơn hàng"),
              ),
            ),
            SizedBox(
              width: Get.width * .7,
              height: Get.height * .05,
              child: FilledButton(
                onPressed: () => Get.offAllNamed('/navhub'),
                child: const Text("Về trang chủ"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
