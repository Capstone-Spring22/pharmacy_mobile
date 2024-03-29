import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/checkout_controller.dart';
import 'package:pharmacy_mobile/models/main_cate.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/models/product_detail.dart';
import 'package:pharmacy_mobile/models/site.dart';
import 'package:pharmacy_mobile/models/sub_category.dart';
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

  Future<List<PharmacyProduct>> getProductsCustomOption(
      int page, int items, String mainCate, String subMain) async {
    List<PharmacyProduct> listProduct = [];
    var response = await dio.get(
      '${api}Product',
      queryParameters: {
        'pageIndex': page,
        'pageItems': items,
        'mainCategoryID': mainCate,
        'subCategoryID': subMain,
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

  Future<List<MainCategory>> fetchCategories() async {
    List<MainCategory> listCategory = [];
    try {
      var response = await dio.get('${api}MainCategory', queryParameters: {
        'pageIndex': 1,
        'pageItems': 10,
      });

      final list = response.data['items'] as List<dynamic>;
      for (var e in list) {
        final item = MainCategory.fromJson(e);
        listCategory.add(item);
      }
    } on DioError catch (e) {
      Get.log(e.response.toString());
    }

    return listCategory;
  }

  Future<List<SubCategory>> fetchSubCategoriesById(String id) async {
    List<SubCategory> listSubCategory = [];
    try {
      var response = await dio.get('${api}SubCategory', queryParameters: {
        'pageIndex': 1,
        'pageItems': 10,
        'MainCategoryID': id,
      });

      final list = response.data['items'] as List<dynamic>;
      for (var e in list) {
        final item = SubCategory.fromJson(e);
        listSubCategory.add(item);
      }
    } on DioError catch (e) {
      Get.log(e.response.toString());
    }

    return listSubCategory;
  }

  Future<List<PharmacyProduct>> fetchHomePageProduct(int typeId) async {
    List<PharmacyProduct> listProduct = [];
    try {
      var response = await dio.get('${api}Product/HomePage', queryParameters: {
        'GetProductType': typeId,
        'pageIndex': 1,
        'pageItems': 10,
        'isPrescription': false,
      });

      final list = response.data['items'] as List<dynamic>;
      for (var e in list) {
        final item = PharmacyProduct.fromJson(e);
        listProduct.add(item);
      }
    } on DioError catch (e) {
      Get.log(e.response.toString());
    }

    return listProduct;
  }

  Future<List<PharmacyProduct>> fetchProductsByMainCate(String id) async {
    List<PharmacyProduct> listProduct = [];
    try {
      var response = await dio.get('${api}Product', queryParameters: {
        'pageIndex': 1,
        'pageItems': 10,
        'mainCategoryID': id,
      });

      final list = response.data['items'] as List<dynamic>;
      for (var e in list) {
        final item = PharmacyProduct.fromJson(e);
        listProduct.add(item);
      }
    } on DioError catch (e) {
      Get.log(e.response.toString());
    }

    return listProduct;
  }

  Future<PharmacyProduct?> getProductByName(String name) async {
    var response = await dio.get(
      '${api}Product',
      queryParameters: {'pageIndex': 1, 'pageItems': 1, 'productName': name},
    );
    try {
      return PharmacyProduct.fromJson(response.data['items'][0]);
    } catch (e) {
      return null;
    }
  }

  Future<List<PharmacyProduct>> getListProductByName(String name) async {
    List<PharmacyProduct> listProduct = [];
    try {
      var response = await dio.get(
        '${api}Product',
        queryParameters: {
          'pageIndex': 1,
          'pageItems': 1000,
          'productName': name
        },
      );

      final list = response.data['items'] as List<dynamic>;
      for (var e in list) {
        final item = PharmacyProduct.fromJson(e);
        listProduct.add(item);
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
    try {
      var response = await dio.get(
        '${api}Product/View/$id',
      );
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

  Future<List<PharmacySite>> getSite() async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;

    final res = await dio.get('${api}Site', queryParameters: {
      'pageIndex': 1,
      'pageItems': 10,
    });

    final list = res.data['items'] as List<dynamic>;
    List<PharmacySite> listSite = [];
    for (var e in list) {
      final item = PharmacySite.fromJson(e);
      listSite.add(item);
    }

    return listSite;
  }
}
