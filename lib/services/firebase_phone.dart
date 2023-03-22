import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';

class PhoneAuth {
  final _auth = FirebaseAuth.instance;
  late String _phoneNumber;
  late String _verificationId;

  Future<void> verifyPhoneNumber() async {
    verificationCompleted(AuthCredential credential) async {
      var res = await _auth.signInWithCredential(credential);
    }

    verificationFailed(exception) {
      debugPrint("Phone Verification Failed: ${exception.message}");
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text("Phone Verification Failed ${exception.message}")));
    }

    codeSent(String verificationId, int? forceResendingToken) async =>
        _verificationId = verificationId;

    codeAutoRetrievalTimeout(String verificationId) =>
        _verificationId = verificationId;

    await _auth.verifyPhoneNumber(
      phoneNumber: toE164(_phoneNumber.substring(1)),
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<bool> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    final User user = (await _auth.signInWithCredential(credential)).user!;
    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);
    return true;
  }

  void setPhoneNumber(String phoneNumber) => _phoneNumber = phoneNumber;

  String getPhoneNumber() => _phoneNumber;
}
