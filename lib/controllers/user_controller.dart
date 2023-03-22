import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';

class UserController extends GetxController {
  Rx<PharmacyUser> user = PharmacyUser().obs;

  RxBool isLoggedIn = false.obs;

  late Rx<User?> _firebaseuser;
  @override
  void onInit() {
    super.onInit();
    _firebaseuser = Rx<User?>(FirebaseAuth.instance.currentUser);
    _firebaseuser.bindStream(FirebaseAuth.instance.idTokenChanges());
    ever(_firebaseuser, _setUser);
  }

  _setUser(User? firebaseUser) async {
    isLoggedIn.value = firebaseUser != null;
    try {
      if (firebaseUser != null && user == PharmacyUser().obs) {
        var firebaseToken = await firebaseUser.getIdToken();
        loginToken(firebaseToken);
      } else {
        user = PharmacyUser().obs;
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.padLeft(10, '0');
  }

  Future loginToken(String token) async {
    final api = dotenv.env['API_URL']!;
    final dio = Dio();

    var res = await dio
        .post("${api}Member/Customer/Login", data: {"firebaseToken": token});

    user.value = PharmacyUser.fromMap(res.data);

    // Get.log(res.data.toString());
    // Get.log(token);

    appController.drawerKey.currentState!.closeDrawer();
    Get.back();
  }
}
