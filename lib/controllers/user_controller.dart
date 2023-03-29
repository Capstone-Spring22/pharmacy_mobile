import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';
import 'package:pharmacy_mobile/services/user_service.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();

  Rx<PharmacyUser> user = PharmacyUser().obs;
  Rx<DetailUser> detailUser = DetailUser().obs;

  RxBool isLoggedIn = false.obs;

  Options? options;

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
        user.value = await loginToken(firebaseToken);

        detailUser.value = await UserService().getUserDetail(user.value.id!);

        options = Options(
          headers: {
            'Authorization': 'Bearer ${userController.user.value.token}'
          },
        );
      } else {
        user = PharmacyUser().obs;
        options = null;
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.padLeft(10, '0');
  }

  Future<PharmacyUser> loginToken(String token) async {
    final api = dotenv.env['API_URL']!;
    final dio = appController.dio;

    var res = await dio
        .post("${api}Member/Customer/Login", data: {"firebaseToken": token});

    appController.drawerKey.currentState!.closeDrawer();
    Get.back();
    return PharmacyUser.fromMap(res.data);
  }
}
