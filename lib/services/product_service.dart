import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/models/product_detail.dart';
import 'package:pharmacy_mobile/models/unit.dart';

class ProductService {
  final dio = appController.dio;
  final api = dotenv.env['API_URL']!;

  //Get product 1 page 10 item
  Future<List<PharmacyProduct>> getProducts(int page, int items) async {
    List<PharmacyProduct> listProduct = [];
    var response = await dio.get(
      '${api}Product',
      queryParameters: {
        'pageIndex': page,
        'pageItems': items,
        // 'isPrescription': false,
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
    var response = await dio.get(
      '${api}Product',
      queryParameters: {'pageIndex': 1, 'pageItems': 1, 'productName': name},
    );
    return PharmacyProduct.fromJson(response.data['items'][0]);
  }

  Future<List<PharmacyProduct>> getListProductByName(String name) async {
    var response = await dio.get(
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
      var res = await dio.get('${api}Product/HomePage', queryParameters: {
        'GetProductType': 1,
        'pageIndex': 1,
        'pageItems': 10,
      });

      final list = res.data['items'] as List<dynamic>;
      for (var e in list) {
        final item = PharmacyProduct.fromJson(e);
        listProduct.add(item);
      }
    } catch (e) {
      log(e.toString());
    }

    return listProduct;
  }

  Future<PharmacyDetail?> getProductDetail(String id) async {
    var response = await dio.get(
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
    var response = await dio.get(
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
    var response = await dio.get('${api}Unit/$id');
    try {
      return ProductUnit.fromJson(response.data);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future checkAvailSite() async {
    final listItem = cartController.listCart;

    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;

    final res = await dio.get(
      '${api}Order/PickUp/Site',
      queryParameters: {
        'ProductId': listItem.map((e) => e.productId).join(';'),
        'Quantity': listItem.map((e) => e.quantity).join(';'),
        // 'CityId':userController.detailUser.value.customerAddressList!.singleWhere((element) => element.isMainAddress==true).cityId,
        'CityId': "79",
      },
      options: userController.options,
    );

    return res.data;
  }

  Future checkProductOnSite(String id) async {
    final res = await dio.get(
      '${api}Order/PickUp/Site',
      queryParameters: {
        'ProductId': id,
        'Quantity': 1,
        'CityId': "79",
      },
      options: userController.options,
    );
    return res.data;
  }

  Future pickDate() async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;

    final res = await dio.get('${api}Order/PickUp/DateAvailable');

    return res.data;
  }

  Future pickTime() async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;

    CheckoutController checkoutController = Get.find();
    final date = checkoutController.selectDate.value;
    if (date != "") {
      final res = await dio.get('${api}Order/PickUp/$date/TimeAvailable');

      return res.data;
    } else {
      return [];
    }
  }

  Future getSite() async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;

    final res = await dio.get('${api}Site', queryParameters: {
      'pageIndex': 1,
      'pageItems': 10,
    });

    return res.data;
  }
}
