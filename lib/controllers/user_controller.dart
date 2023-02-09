import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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

  // _setInitialScreen(User? user) => isLoggedIn.value = user != null;
  _setUser(User? firebaseUser) async {
    isLoggedIn.value = firebaseUser != null;
    if (firebaseUser != null) {
      var firebaseToken = await firebaseUser.getIdToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(firebaseToken);
      user = PharmacyUser(
              phone: num.parse(e164ToReadable(decodedToken['phone_number'])))
          .obs;
    }
  }

  String formatPhoneNumber(num phoneNumber) {
    return phoneNumber.toString().padLeft(10, '0');
  }
}
