import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/screens/signup/widgets/gender.dart';
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
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(CupertinoIcons.back),
                      ),
                    ),
                    Text(
                      "Sign up",
                      style: context.textTheme.headlineMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () => Get.changeThemeMode(
                            Get.isDarkMode ? ThemeMode.light : ThemeMode.dark),
                        icon: Icon(Get.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.w),
                  child: GenderSelect(
                    isMale: isMale,
                    callback: genderSelect,
                  ),
                ),
                SizedBox(
                  height: 10.w,
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
                      onPressed: () {},
                      child: Text(
                        "Sign in",
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
      ),
    );
  }
}
