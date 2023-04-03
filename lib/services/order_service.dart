import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';

import '../models/order.dart';

class OrderService {
  final dio = appController.dio;
  final api = dotenv.env['API_URL']!;

  Future getOrderId() async {
    var res = await dio.get('${api}Order/GenerateOrderId');
    return res.data;
  }

  Future<num> getPoint() async {
    var res = await dio.get('${api}Order/GetPoint');
    return res.data['point'];
  }

  Future postOrder(Order order) async {
    try {
      var res = await dio.post('${api}Order/Checkout', data: order.toJson());
      return res.statusCode;
    } catch (e) {
      Get.log(e.toString());
    }
  }
}
