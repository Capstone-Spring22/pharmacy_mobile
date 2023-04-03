import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.arguments['id'];
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
              "Order ID",
              style: context.textTheme.titleLarge,
            ),
            Text(
              id,
              style: context.textTheme.titleLarge,
            ),
            Text(
              "has been placed successfully",
              style: context.textTheme.titleLarge,
            ),
            SizedBox(
              width: Get.width * .7,
              height: Get.height * .05,
              child: FilledButton(
                onPressed: () {},
                child: const Text("View my order"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
