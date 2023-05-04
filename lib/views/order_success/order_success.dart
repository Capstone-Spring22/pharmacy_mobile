import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.arguments;
    return Scaffold(
      appBar: PharmacyAppBar(
        leftWidget: Container(
          height: 50,
        ),
        midText: "Đặt hàng thành công",
        rightWidget: Container(
          height: 50,
        ),
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
                onPressed: () {
                  Get.offNamedUntil(
                    '/order_detail',
                    ModalRoute.withName('/navhub'),
                    arguments: id,
                  );
                },
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
