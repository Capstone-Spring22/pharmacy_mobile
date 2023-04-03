import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/models/product_detail.dart';
import 'package:pharmacy_mobile/models/unit.dart';

class ProductService {
  final dio = appController.dio;
  final api = dotenv.env['API_URL']!;

  //Get product 1 page 10 item
  Future<List<PharmacyProduct>> getProducts(int page, int items) async {
    List<PharmacyProduct> listProduct = [];
    Response response = await dio.get(
      '${api}Product',
      queryParameters: {
        'pageIndex': page,
        'pageItems': items,
        'isPrescription': false,
      },
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
    return PharmacyProduct.fromJson(response.data['items'][0]);
    // try {
    //   debugPrint(response.data['items']);
    // } catch (e) {
    //   log("Error: $e");
    // }
    // return null;
  }

  Future<List<PharmacyProduct>> getListProductByName(String name) async {
    Response response = await dio.get(
      '${api}Product',
      queryParameters: {'pageIndex': 1, 'pageItems': 30, 'productName': name},
    );
    List<PharmacyProduct> listProduct = [];
    try {
      final list = response.data['items'] as List<dynamic>;
      for (var e in list) {
        final item = PharmacyProduct.fromJson(e);
        listProduct.add(item);
        if (!list.contains(item)) {
          list.add(item);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return listProduct;
  }

  Future<List<PharmacyProduct>> getTopSelling() async {
    List<PharmacyProduct> listProduct = [];
    try {
      var res = await dio.get(
          'https://betterhealthapi.azurewebsites.net/api/v1/Product/HomePage?GetProductType=1&pageIndex=1&pageItems=10');
      // var res = await dio.get('${api}Product/HomePage', queryParameters: {
      //   'GetProductType ': 1,
      //   'pageIndex': 1,
      //   'pageItems': 10,
      // });

      final list = res.data['items'] as List<dynamic>;
      for (var e in list) {
        debugPrint(e.toString());
        final item = PharmacyProduct.fromJson(e);
        listProduct.add(item);
      }
    } catch (e) {
      log(e.toString());
    }

    return listProduct;
  }

  Future<PharmacyDetail?> getProductDetail(String id) async {
    Response response = await dio.get(
      '${api}Product/View/$id',
    );
    try {
      return PharmacyDetail.fromJson(response.data);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<PharmacyProduct?> getProductByBarcode(String barcode) async {
    Response response = await dio.get(
      '${api}Product',
      queryParameters: {'pageIndex': 1, 'pageItems': 1, 'productName': barcode},
    );
    try {
      return PharmacyProduct.fromJson(response.data['items'][0]);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<ProductUnit?> getProductUnitById(String id) async {
    Response response = await dio.get('${api}Unit/$id');
    try {
      return ProductUnit.fromJson(response.data);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
