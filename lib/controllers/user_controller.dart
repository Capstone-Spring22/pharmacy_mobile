import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();

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
        await loginToken(firebaseToken);
        Get.log(JwtDecoder.isExpired(user.value.token!).toString());
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
    final dio = appController.dio;

    var res = await dio
        .post("${api}Member/Customer/Login", data: {"firebaseToken": token});

    user.value = PharmacyUser.fromMap(res.data);

    appController.drawerKey.currentState!.closeDrawer();
    Get.back();
  }
}
