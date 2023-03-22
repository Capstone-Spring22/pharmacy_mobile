import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class CartService {
  Dio dio = Dio();
  final api = dotenv.env['API_URL']!;

  Future postCart(Map<String, dynamic> item, String deviceId) async {
    var res =
        await dio.post("${api}Cart", data: {"cartId": deviceId, "item": item});

    if (res.statusCode == 400) {
      Get.snackbar(
          "Error adding to cart", "Please check your network or try again");
    }
  }
}
