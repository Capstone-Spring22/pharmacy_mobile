// ignore_for_file: unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/cart.dart';

class CartService {
  final dio = appController.dio;
  final api = dotenv.env['API_URL']!;

  Future postCart(Map<String, dynamic> item) async {
    try {
      await dio.post(
        "${api}Cart",
        data: item,
        options: userController.options,
      );
    } on DioError catch (e) {
      Get.log("Error at post cart: $e");
      if (e.message != null) {
        Get.log(e.response.toString());
      }
    }
  }

  Future<String> getCartId() async {
    try {
      while (appController.androidInfo == null) {
        await Future.delayed(const Duration(seconds: 1));
      }
      var res = await dio.get('${api}Cart/${appController.androidInfo!.id}');
      return res.data['cartId'];
    } catch (e) {
      Get.log("getCartId: $e");
      return 'useUserId';
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
