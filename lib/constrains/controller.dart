import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/controllers/camera_controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/controllers/chat_controller.dart';
import 'package:pharmacy_mobile/controllers/notification_controller.dart';
import 'package:pharmacy_mobile/controllers/product_controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/screens/address/address.dart';

AppController appController = AppController.instance;
CartController cartController = CartController.instance;
ProductController productController = ProductController.instance;
UserController userController = UserController.instance;
NotificationController notiController = NotificationController.instance;
QrCameraController cameraController = QrCameraController.instance;
AddressController addressController = AddressController.instance;
ChatController chatController = ChatController.instance;

String convertCurrency(num number) {
  var formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
  );
  return formatter.format(number);
}

bool isVietnamesePhoneNumber(String phoneNumber) {
  final phoneNumberPattern = RegExp(r"^(0[3|5|7|8|9])+([0-9]{8})$");
  return phoneNumberPattern.hasMatch(phoneNumber);
}

String toE164(String phone) {
  final formattedPhone = phone.trim().replaceAll(RegExp(r'[^+\d]'), '');
  return "+84$formattedPhone";
}

String e164ToReadable(String number) {
  Map<String, String> countryCodeMap = {'+84': 'Vietnam'};

  if (number.length >= 11) {
    String countryCode = number.substring(0, 3);
    if (countryCodeMap.containsKey(countryCode)) {
      return number.substring(3);
    }
  }
  return number;
}
