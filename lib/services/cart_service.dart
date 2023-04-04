// ignore_for_file: unnecessary_null_comparison

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';

class CartService {
  final dio = appController.dio;
  final api = dotenv.env['API_URL']!;

  Future postCart(Map<String, dynamic> item) async {
    try {
      Get.log(item.toString());
      var res = await dio.post(
        "${api}Cart",
        data: item,
        options: userController.options,
      );

      Get.log(res.data.toString());

      if (res.statusCode == 400) {
        Get.snackbar(
          "Error adding to cart",
          "Please check your network or try again",
        );
      }
    } catch (e) {
      Get.log("Error at post cart: $e");
    }
  }

  Future<String?> getCartId() async {
    try {
      while (appController.androidInfo == null) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var res = await dio.get('${api}Cart/${appController.androidInfo!.id}');
      return res.data['cartId'];
    } catch (e) {
      Get.log("getCartId: $e");
      return null;
    }
  }

  Future<List<CartItem>> getListCartItem() async {
    List<CartItem> list = [];
    try {
      while (appController.androidInfo == null) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var res = await dio.get('${api}Cart/${appController.androidInfo!.id}');
      for (final e in res.data['items']) {
        list.add(CartItem.fromJson(e));
      }
      return list;
    } catch (e) {
      Get.log("getCart: $e");
      return [];
    }
  }

  Future removeCart(String productId, String cartId) async {
    await dio
        .delete('${api}Cart', data: {"productId": productId, "cartId": cartId});
  }
}
