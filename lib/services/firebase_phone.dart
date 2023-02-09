// phone_auth.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'dart:math';

class PhoneAuth {
  final _auth = FirebaseAuth.instance;
  late String _phoneNumber;
  late String _verificationId;

  Future<void> verifyPhoneNumber() async {
    verificationCompleted(AuthCredential credential) async {
      var res = await _auth.signInWithCredential(credential);
      if (res.user != null) {
        String token = await res.user!.getIdToken();
        await Clipboard.setData(ClipboardData(text: token));
        ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(content: Text("Token copied to clipboard")));
      }
    }

    double haversineDistance(
        double lat1, double lon1, double lat2, double lon2) {
      var r = 6371; // radius of earth in km
      var phi1 = lat1 * pi / 180;
      var phi2 = lat2 * pi / 180;
      var deltaPhi = (lat2 - lat1) * pi / 180;
      var deltaLambda = (lon2 - lon1) * pi / 180;

      var a = pow(sin(deltaPhi / 2), 2) +
          cos(phi1) * cos(phi2) * pow(sin(deltaLambda / 2), 2);
      var c = 2 * atan2(sqrt(a), sqrt(1 - a));

      var distance = r * c;
      return distance;
    }

    verificationFailed(exception) {
      print("Phone Verification Failed: ${exception.message}");
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text("Phone Verification Failed ${exception.message}")));
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
    }

    codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
    }

    await _auth.verifyPhoneNumber(
        phoneNumber: toE164(_phoneNumber.substring(1)),
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<bool> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    final User user = (await _auth.signInWithCredential(credential)).user!;
    final User currentUser = _auth.currentUser!;
    assert(user.uid == currentUser.uid);
    return true;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }
}
