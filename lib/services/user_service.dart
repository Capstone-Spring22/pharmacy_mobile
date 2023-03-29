import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';

class UserService {
  final api = dotenv.env['API_URL']!;
  final dio = appController.dio;

  Future<DetailUser> getUserDetail(String id) async {
    final res = await dio.get('${api}Customer/$id');

    return DetailUser.fromJson(res.data);
  }
}
