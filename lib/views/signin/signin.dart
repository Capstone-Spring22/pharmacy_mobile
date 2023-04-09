// login_screen.dart

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/views/signin/widget/code_sent.dart';
import 'package:pharmacy_mobile/views/signin/widget/input_phone.dart';
import 'package:pharmacy_mobile/services/firebase_phone.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final PhoneAuth phoneAuth = PhoneAuth();
  @override
  Widget build(BuildContext context) {
    bool result = true;
    try {
      final box = GetStorage();
      result = box.read("isFirst");
    } catch (e) {
      Get.log(e.toString());
    }
    return Scaffold(
      // appBar: PharmacyAppBar(
      //   leftWidget: IconButton(
      //     onPressed: () => Get.back(),
      //     icon: const Icon(CupertinoIcons.back),
      //   ),
      //   midText: "Đăng nhập",
      //   rightWidget: TextButton(
      //     child: const Text("Bỏ qua"),
      //     onPressed: () => result ? Get.offAllNamed("/navhub") : Get.back(),
      //   ),
      // ),
      appBar: AppBar(
        title: const Text("Đăng nhập"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.back),
        ),
        actions: [
          TextButton(
            child: const Text("Bỏ qua"),
            onPressed: () => result ? Get.offAllNamed("/navhub") : Get.back(),
          ),
        ],
      ),
      body: GetX<SignupController>(
        builder: (controller) => Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!controller.codeSent.value)
                    Expanded(flex: 1, child: Container()),
                  if (!controller.codeSent.value)
                    Image.asset(
                      'assets/icons/banner.png',
                      height: Get.height * .2,
                    ),
                  if (!controller.codeSent.value) const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: controller.codeSent.value
                          ? CodeSent(phoneAuth)
                          : InputPhone(phoneAuth),
                    ),
                  ),
                  if (!controller.codeSent.value)
                    Expanded(flex: 5, child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignupController extends GetxController {
  RxBool codeSent = false.obs;
}
