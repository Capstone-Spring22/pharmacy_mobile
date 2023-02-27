import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../services/firebase_phone.dart';

class CodeSent extends StatelessWidget {
  const CodeSent({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController otpCtl = TextEditingController();
    final PhoneAuth phoneAuth = PhoneAuth();

    return SizedBox(
      height: Get.height,
      child: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "We've sent an SMS with a verification code to your phone number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Lottie.asset(
              'assets/lottie/loading.json',
              height: Get.height * 0.2,
            ),
            const Text(
              "Listening for OTP",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(
                color: Colors.black.withOpacity(.1), height: Get.height * .05),
            const Text(
              "OR",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Divider(color: Colors.transparent, height: Get.height * .05),
            const Text(
              "Enter Code Manually",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            Divider(color: Colors.transparent, height: Get.height * .05),
            TextField(
              controller: otpCtl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      BorderSide(color: context.theme.highlightColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: context.theme.primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            FilledButton(
              child: const Text("Submit OTP"),
              onPressed: () async {
                Get.defaultDialog(
                  title: "Signing you in",
                  middleText: "Please wait",
                  content: const CircularProgressIndicator.adaptive(),
                );
                await phoneAuth
                    .signInWithPhoneNumber(otpCtl.text)
                    .then((value) {
                  Get.back();
                  Get.back();
                });
              },
            ),
            // const Spacer(),
          ],
        ),
      ),
    );
  }
}