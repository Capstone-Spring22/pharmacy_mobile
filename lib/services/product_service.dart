import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:pharmacy_mobile/models/product.dart';

class ProductService {
  final dio = Dio();
  final api = dotenv.env['API_URL']!;

  //Get product 1 page 10 item
  Future<List<PharmacyProduct>> getProducts(int page, int items) async {
    List<PharmacyProduct> listProduct = [];
    Response response = await dio.get(
      '${api}Product',
      queryParameters: {'pageIndex': page, 'pageItems': items},
    );
    // log(response.data.toString());
    try {
      final list = response.data['items'] as List<dynamic>;
      for (var e in list) {
        listProduct.add(PharmacyProduct.fromJson(e));
      }
    } catch (e) {
      log(e.toString());
    }
    return listProduct;
  }

  Future<PharmacyProduct?> getProductByName(String name) async {
    Response response = await dio.get(
      '${api}Product',
      queryParameters: {'pageIndex': 1, 'pageItems': 1, 'productName': name},
    );
    try {
      return PharmacyProduct.fromJson(response.data['items']);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
  // Future<PharmacyProduct?> getProductById(String id) async {
  //   Response response = await dio.get(
  //     '${api}Product',
  //     queryParameters: {'pageIndex': 1, 'pageItems': 1, 'productName': name},
  //   );
  //   try {
  //     return PharmacyProduct.fromJson(response.data['items']);
  //   } catch (e) {
  //     log(e.toString());
  //   }
  //   return null;
  // }
}
