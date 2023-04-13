import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';

class UserService {
  final api = dotenv.env['API_URL']!;
  final dio = appController.dio;

  Future getUserDetail(String id) async {
    try {
      final res = await dio.get('${api}Customer/$id');

      return DetailUser.fromJson(res.data);
    } catch (e) {
      return;
    }
  }

  Future registerUser(Map<String, dynamic> data) async {
    try {
      final res = await dio.post('${api}Customer', data: data);

      return res.statusCode;
    } on DioError catch (e) {
      Get.log('Error register user: ${e.response!.data}');
      return;
    }
  }
}
