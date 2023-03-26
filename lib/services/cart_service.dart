import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';

class CartService {
  final dio = appController.dio;
  final api = dotenv.env['API_URL']!;

  Future postCart(Map<String, dynamic> item, String deviceId) async {
    try {
      var res = await dio
          .post("${api}Cart", data: {"deviceId": deviceId, "item": item});

      if (res.statusCode == 400) {
        Get.snackbar(
            "Error adding to cart", "Please check your network or try again");
      }
    } catch (e) {
      Get.log("Error at post cart: $e");
    }
  }
}
