import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/screens/signup/widgets/gender.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/scroll_behavior.dart';
import 'package:pharmacy_mobile/widgets/textInput.dart';

import '../../widgets/button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  bool isMale = true;

  void genderSelect(bool value) {
    setState(() {
      isMale = value;
    });
  }

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
        midText: "Sign up",
        rightWidget: TextButton(
          child: const Text("Skip"),
          onPressed: () => result ? Get.offAllNamed("/navhub") : Get.back(),
        ),
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 040.w),
                    child: Form(
                      child: Column(
                        children: [
                          TextInput(
                            inputController: t1,
                            text: "Name",
                            kbType: TextInputType.name,
                          ),
                          TextInput(
                            inputController: t1,
                            text: "Phone Number",
                            kbType: TextInputType.phone,
                          ),
                          TextInput(
                            inputController: t1,
                            text: "Address",
                            kbType: TextInputType.streetAddress,
                          ),
                          TextInput(
                            inputController: t1,
                            text: "Age",
                            kbType: TextInputType.phone,
                          ),
                          PasswordInput(
                            textEditingController: t2,
                            text: "Password",
                          ),
                          PasswordInput(
                            textEditingController: t2,
                            text: "Confirm Password",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: GenderSelect(
                      isMale: isMale,
                      callback: genderSelect,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Hero(
                      tag: "signupBtn",
                      child: SizedBox(
                        width: 300.w,
                        height: 40.h,
                        child: PharmacyButton(
                          onPressed: () {},
                          text: "Sign up",
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: context.textTheme.labelLarge,
                      ),
                      TextButton(
                        onPressed: () => Get.offNamed("/signin"),
                        child: const Text("Sign in"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
