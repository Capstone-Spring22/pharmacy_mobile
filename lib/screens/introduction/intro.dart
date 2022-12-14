import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/screens/nav_hub/nav_bar_hub.dart';

import '../../widgets/button.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return isFirst() ? const IntroWidget() : const NavBarHub();
    // return const IntroWidget();
  }

  bool isFirst() {
    bool result = true;
    try {
      final box = GetStorage();
      result = box.read("isFirst");
    } catch (e) {
      print(e);
    }
    return result;
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AutoSizeText(
                "Welcome to Pharmacy",
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium,
              ),
              Image.asset("assets/images/Intro.png"),
              Hero(
                tag: 'signinBtn',
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: PharmacyButton(
                    onPressed: () => Get.toNamed("/signin"),
                    text: "Sign In",
                  ),
                ),
              ),
              Hero(
                tag: 'signupBtn',
                child: SizedBox(
                  height: 50.h,
                  width: 300.w,
                  child: PharmacyButton(
                    onPressed: () => Get.toNamed("/signup"),
                    text: "Sign up",
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.offAllNamed("/navhub"),
                child: const Text("Skip for now"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
