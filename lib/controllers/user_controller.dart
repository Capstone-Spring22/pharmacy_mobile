import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/helpers/snack.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';
import 'package:pharmacy_mobile/services/order_service.dart';
import 'package:pharmacy_mobile/services/user_service.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();

  Rx<PharmacyUser?> user = null.obs;
  Rx<DetailUser?> detailUser = null.obs;

  int point = 0;

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
    try {
      if (firebaseUser != null) {
        var firebaseToken = await firebaseUser.getIdToken();
        var result = await loginToken(firebaseToken);

        if (result is PharmacyUser) {
          user = result.obs;
          user.refresh();
          var userDetailRes =
              await UserService().getUserDetail(user.value!.id!);
          if (userDetailRes is DetailUser) {
            detailUser = userDetailRes.obs;
            point = await OrderService()
                .getCustomerPoint(detailUser.value!.phoneNo!);
            detailUser.refresh();
          }
          options = Options(
            headers: {
              'Authorization': 'Bearer ${userController.user.value!.token}'
            },
          );

          showSnack('Thông báo', 'Đăng nhập thành công', SnackType.success);
        } else {
          Get.log(Get.previousRoute);
          Get.log("Current Route: ${Get.currentRoute}");
          if (Get.currentRoute == '/signin' || Get.currentRoute == '/intro') {
            Get.defaultDialog(
              title: "Tài khoản không tồn tại",
              middleText: "Di chuyển đến trang đăng kí?",
              onConfirm: () {
                Get.offNamed('/signup', arguments: {
                  'token': firebaseToken,
                });
              },
              textConfirm: 'Đăng kí',
              onCancel: () {
                appController.setPage(0);
                appController.drawerKey.currentState!.closeDrawer();
                Get.offNamedUntil('/navhub', (route) => route.isFirst);
              },
              textCancel: "Hủy",
            );
          }
        }
      } else {
        user = null.obs;
        detailUser = null.obs;
        options = null;
      }
    } catch (e) {
      Get.log("Error set user: $e");
    }

    isLoggedIn.value = firebaseUser is User &&
        user.value is PharmacyUser &&
        detailUser.value is DetailUser;
  }

  Future refeshUser() async {
    detailUser.value = await UserService().getUserDetail(user.value!.id!);
    point = await OrderService().getCustomerPoint(detailUser.value!.phoneNo!);
  }

  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.padLeft(10, '0');
  }

  Future loginToken(String token) async {
    final api = dotenv.env['API_URL']!;
    final dio = appController.dio;
    Response? res;
    try {
      res = await dio
          .post("${api}Member/Customer/Login", data: {"firebaseToken": token});
      Get.log(res.statusCode.toString());
    } on DioError catch (e) {
      Get.log("Error login token: ${e.response}");
      if (e.response!.statusCode == 404) {
        return;
      }
    }

    appController.drawerKey.currentState!.closeDrawer();
    Get.log("Current rotue: ${Get.currentRoute}");
    Get.back();
    return PharmacyUser.fromMap(res!.data);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    resetState();
    cartController.listCart.clear();
    appController.drawerKey.currentState!.closeDrawer();
    Get.back();
  }

  void resetState() {
    user = null.obs;
    detailUser = null.obs;
    isLoggedIn = false.obs;
    options = null;
    cartController
      ..listCart.clear()
      ..refresh();
  }
}
