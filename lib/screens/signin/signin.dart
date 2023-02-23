// login_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/screens/signin/widget/code_sent.dart';
import 'package:pharmacy_mobile/screens/signin/widget/input_phone.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    bool result = true;
    try {
      final box = GetStorage();
      result = box.read("isFirst");
    } catch (e) {
      print(e);
    }
    return Scaffold(
      appBar: PharmacyAppBar(
        leftWidget: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(CupertinoIcons.back),
        ),
        midText: "Sign in",
        rightWidget: TextButton(
          child: const Text("Skip"),
          onPressed: () => result ? Get.offAllNamed("/navhub") : Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetX<SignupController>(
          builder: (controller) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: controller.codeSent.value
                ? const CodeSent()
                : const InputPhone(),
          ),
        ),
      ),
    );
  }
}

class SignupController extends GetxController {
  RxBool codeSent = false.obs;
}
