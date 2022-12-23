import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/button.dart';
import 'package:pharmacy_mobile/widgets/textInput.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController t1 = TextEditingController();

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
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextInput(
                      inputController: t1,
                      text: "Phone Number",
                      kbType: TextInputType.phone,
                    ),
                    PasswordInput(
                      textEditingController: t1,
                      text: "Password",
                    ),
                    Hero(
                      tag: "signinBtn",
                      child: SizedBox(
                        width: 300.w,
                        height: 40.h,
                        child: PharmacyButton(
                          onPressed: () {},
                          text: "Sign in",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: context.textTheme.labelLarge,
                  ),
                  TextButton(
                    onPressed: () => Get.offNamed("/signup"),
                    child: Text(
                      "Sign up",
                      style: context.textTheme.labelLarge!.copyWith(
                        color: const Color(0xFFFEC107),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
