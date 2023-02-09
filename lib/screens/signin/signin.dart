// login_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/services/firebase_phone.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final PhoneAuth _phoneAuth = PhoneAuth();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController otpCtl = TextEditingController();
  bool _isCodeSent = false;
  late String _smsCode;

  bool done = false;

  @override
  Widget build(BuildContext context) {
    const bool kDebugMode = !kReleaseMode && !kProfileMode;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            kDebugMode
                ? StreamBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return FilledButton(
                            onPressed: () async {
                              FirebaseAuth.instance.signOut();
                            },
                            child: const Text(
                                "Have USER, token copied to clipboard, hit this button to signout"));
                      } else {
                        return const Center(child: Text("No User yet"));
                      }
                    },
                    stream: FirebaseAuth.instance.authStateChanges(),
                  )
                : Container(),
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
                  _phoneAuth.setPhoneNumber(value);
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
                  _phoneAuth.verifyPhoneNumber().then((value) {
                    setState(() {
                      _isCodeSent = true;
                    });
                  });
                },
              ),
            ),
            _isCodeSent
                ? Column(
                    children: [
                      TextField(
                        controller: otpCtl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Enter OTP",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: context.theme.highlightColor, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: context.theme.primaryColor, width: 2),
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
                          await _phoneAuth
                              .signInWithPhoneNumber(otpCtl.text)
                              .then((value) {
                            Get.back();
                            Get.back();
                            setState(() {
                              _isCodeSent = false;
                            });
                          });
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
