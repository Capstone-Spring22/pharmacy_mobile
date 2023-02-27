import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/screens/signin/signin.dart';

import '../../../services/firebase_phone.dart';

class InputPhone extends StatelessWidget {
  const InputPhone({super.key});

  @override
  Widget build(BuildContext context) {
    final PhoneAuth phoneAuth = PhoneAuth();
    TextEditingController phoneCtl = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: phoneCtl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Enter Phone Number",
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
          onChanged: (value) {
            if (isVietnamesePhoneNumber(value)) {
              phoneAuth.setPhoneNumber(value);
            }
          },
        ),
        const SizedBox(
          height: 16.0,
        ),
        Hero(
          tag: 'signinBtn',
          child: FilledButton(
            child: const Text("Sent OTP"),
            onPressed: () {
              phoneAuth.verifyPhoneNumber().then((value) {
                SignupController ctl = Get.find();
                ctl.codeSent.value = true;
              });
            },
          ),
        )
      ],
    );
  }
}