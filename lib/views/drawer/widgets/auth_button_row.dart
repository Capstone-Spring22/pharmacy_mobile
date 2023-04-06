import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/widgets/button.dart';

class AuthButtonRow extends StatelessWidget {
  const AuthButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Hero(
              tag: 'signinBtn',
              child: PharmacyButton(
                onPressed: () => Get.toNamed("/signin"),
                text: "Sign In",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
