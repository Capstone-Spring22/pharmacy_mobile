import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 30.h,
              ),
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
                    "Sign In",
                    style: context.textTheme.headlineMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () => Get.changeThemeMode(
                          Get.isDarkMode ? ThemeMode.light : ThemeMode.dark),
                      icon: Icon(
                          Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    ),
                  )
                ],
              ),
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
                    onPressed: () {},
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
