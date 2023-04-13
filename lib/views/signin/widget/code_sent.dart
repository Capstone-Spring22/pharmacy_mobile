import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';

import '../../../services/firebase_phone.dart';

class CodeSent extends StatelessWidget {
  const CodeSent(this.phoneAuth, {super.key});
  final PhoneAuth phoneAuth;
  @override
  Widget build(BuildContext context) {
    TextEditingController otpCtl = TextEditingController();

    return SingleChildScrollView(
      child: SizedBox(
        height: Get.height * .7,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "SMS với mã bảo mật OTP đã được gửi",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            Lottie.asset(
              'assets/lottie/loading.json',
              height: Get.height * 0.2,
            ),
            const Text(
              "Lắng nghe mã OTP",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(
                color: Colors.black.withOpacity(.1), height: Get.height * .05),
            const Text(
              "HOẶC",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Divider(color: Colors.transparent, height: Get.height * .05),
            const Text(
              "Điền mã",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            Divider(color: Colors.transparent, height: Get.height * .05),
            TextField(
              textAlign: TextAlign.center,
              controller: otpCtl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Nhập OTP",
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
              child: const Text("Đăng nhập"),
              onPressed: () async {
                Get.defaultDialog(
                  title: "Đang đăng nhập",
                  middleText: "Vui lòng đợi",
                  content: const CircularProgressIndicator.adaptive(),
                );
                await phoneAuth
                    .signInWithPhoneNumber(otpCtl.text)
                    .then((value) {
                  Get.back();
                  Get.back();
                  // Get.back();
                  // Get.back();
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
