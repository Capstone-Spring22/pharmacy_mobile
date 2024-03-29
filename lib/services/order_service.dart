import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/progress_history.dart';
import 'package:pharmacy_mobile/views/order_history/models/order_history.dart';

import '../models/order.dart';

class OrderService {
  Future getOrderId() async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    var res = await dio.get('${api}Order/GenerateOrderId');
    return res.data;
  }

  Future<num> getPoint() async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    var res = await dio.get('${api}Order/GetPoint');
    return res.data['point'];
  }

  Future postOrder(Order order) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    // ignore: prefer_typing_uninitialized_variables
    var res;
    try {
      res = await dio.post('${api}Order/Checkout', data: order.toJson());
      return res.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        Get.log(e.response!.data.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        Get.log(e.requestOptions.toString());
        Get.log(e.message.toString());
      }
    }
  }

  Future<List<OrderHistory>> getOrderHistory(int page) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    List<OrderHistory> list = [];
    try {
      var res = await dio.get(
        '${api}Order/',
        queryParameters: {
          'pageIndex': page,
          'pageItems': 10,
        },
        options: userController.options,
      );
      for (var item in res.data['items']) {
        list.add(OrderHistory.fromJson(item));
      }
      return list;
    } catch (e) {
      Get.log(e.toString());
      return [];
    }
  }

  Future wipeCart(String id) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    try {
      var res = await dio.delete('${api}Cart/$id');
      Get.log(res.toString());
    } on DioError catch (e) {
      Get.log(e.response.toString());
    }
    // cartController.connectToCloudCart(true);
  }

  Future getOrderHistoryDetail(String id) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    try {
      var res = await dio.get('${api}Order/$id');
      return res.data;
    } catch (e) {
      Get.log("Error: $e");
    }
  }

  Future<num> checkSiteListAvailable(String cityId, String districtId) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    try {
      var res = await dio.get('${api}Site', queryParameters: {
        'pageIndex': 1,
        'pageItems': 10,
        'CityID': cityId,
        'DistrictID': districtId,
        'IsDelivery': true,
      });
      return res.data['totalRecord'] as num;
    } catch (e) {
      Get.log("Error: $e");
    }
    return 0;
  }

  Future<int> getCustomerPoint(String phone) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    try {
      var res = await dio.get(
        '${api}CustomerPoint/$phone/CustomerAvailablePoint',
      );
      return res.data;
    } on DioError catch (e) {
      Get.log("Error get customer point: ${e.response.toString()}");
    }
    return 0;
  }

  Future cancelOrder(String orderId, String reason) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    try {
      var ip = await appController.getIpAddress();
      var res = await dio.put(
        '${api}Order/CancelOrder',
        options: userController.options,
        data: {
          "orderId": orderId,
          "reason": reason,
          "ipAddress": ip,
        },
      );

      Get.log('Cancel order: ${res.data}');
      return res.statusCode;
    } on DioError catch (e) {
      Get.log('Cancel order Error: ${e.response!.toString()}');
    }
  }

  Future<List<OrderProgressHistory>> orderProgressHistory(String id) async {
    final dio = appController.dio;
    final api = dotenv.env['API_URL']!;
    try {
      var res = await dio.get(
        '${api}Order/OrderExecutionHistory/$id',
        options: userController.options,
      );

      final List<OrderProgressHistory> list = [];

      for (final item in res.data) {
        list.add(OrderProgressHistory.fromJson(item));
      }

      return list;
    } on DioError catch (e) {
      Get.log('Order progress history error: ${e.response!.toString()}');
    }
    return [];
  }
}
