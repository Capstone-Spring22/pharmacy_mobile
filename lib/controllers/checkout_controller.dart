// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/models/order.dart';
import 'package:pharmacy_mobile/screens/checkout/checkout.dart';
import 'package:pharmacy_mobile/services/order_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutController extends GetxController {
  RxBool isCollase = false.obs;

  RxDouble panelHeight = (Get.height * .1).obs;

  final nameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final address = TextEditingController();
  final emailCtl = TextEditingController();
  final noteCtl = TextEditingController();

  Rx<ScrollController?> scrollController = null.obs;

  RxString selectSite = "".obs;
  RxString selectDate = "".obs;
  RxString selectTime = "".obs;

  RxBool activeBtn = true.obs;

  RxInt paymentType = 0.obs;
  //0 - Cash
  //1 - Card

  RxInt checkoutType = 0.obs;
  //0 - Online
  //1 - Pickup

  void rowView() => isCollase.value = true;
  void colView() => isCollase.value = false;

  double linearInterpolationTop() {
    return 0.8 * (panelHeight.value - 0.1);
  }

  void setPanelHeight(double d) {
    panelHeight.value = d;
  }

  RxList<TextFieldProperty> listTextField = <TextFieldProperty>[].obs;

  @override
  void onInit() {
    final user = userController.user.value;

    ever(checkoutType, (type) {
      if (type == 0) {
        selectSite.value = "";
        selectDate.value = "";
        selectTime.value = "";
        activeBtn.value = true;
      } else {
        activeBtn.value = false;
        everAll([selectDate, selectSite, selectTime], (value) {
          if (type != 0) {
            if (selectDate.value != "" &&
                selectSite.value != "" &&
                selectTime.value != "") {
              activeBtn.value = true;
            } else {
              activeBtn.value = false;
            }
          } else {
            activeBtn.value = true;
          }
        }, condition: type != 0);
      }
    });

    if (user.name != null) {
      nameCtl.text = user.name!;
    }
    phoneCtl.text = user.phoneNo!;

    listTextField.value = [
      TextFieldProperty(
          icon: Icons.person,
          label: "Name",
          txtCtrl: nameCtl,
          type: TextInputType.name),
      TextFieldProperty(
          icon: Icons.phone,
          label: "Phone Number",
          txtCtrl: phoneCtl,
          type: TextInputType.phone),
      TextFieldProperty(
          icon: Icons.email,
          label: "Email (Optional)",
          txtCtrl: emailCtl,
          type: TextInputType.emailAddress),
      TextFieldProperty(
          icon: Icons.note,
          label: "Note (Optional)",
          txtCtrl: noteCtl,
          type: TextInputType.multiline),
    ];
    super.onInit();
  }

  void launchMaps(String address) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
    if (!await launchUrl(Uri.parse(googleUrl),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $googleUrl');
    }
  }

  void toggleOrderType(int? index) {
    checkoutType.value = index!;
  }

  void togglePaymentType(int? index) {
    paymentType.value = index!;
  }

  Future createOrderPickUp() async {
    final user = userController.user.value;
    final detailUser = userController.detailUser.value;
    num type = 2;

    List<Products> listProducts = [];

    for (var element in cartController.listCart) {
      listProducts.add(Products(
        productId: element.productId,
        quantity: element.quantity,
        discountPrice: element.priceAfterDiscount,
        originalPrice: element.price,
      ));
    }

    Get.dialog(
      Center(
        child: LoadingWidget(),
      ),
    );

    if (paymentType.value == 0) {
      final order = Order(
        orderId: await OrderService().getOrderId(),
        orderTypeId: type,
        usedPoint: 0,
        payType: 1,
        isPaid: false,
        discountPrice: cartController.calculateTotal(),
        subTotalPrice: cartController.calculateTotalNonDiscount(),
        shippingPrice: 0,
        totalPrice: cartController.calculateTotal(),
        products: listProducts,
        vouchers: [],
        note: noteCtl.text,
        orderPickUp: OrderPickUp(
          datePickUp: selectDate.value,
          timePickUp: selectTime.value,
        ),
        reveicerInformation: ReveicerInformation(
          gender: true,
          fullname: nameCtl.text,
          phoneNumber: phoneCtl.text,
          email: emailCtl.text,
        ),
        siteId: selectSite.value,
      );

      await OrderService().postOrder(order).then((value) async {
        if (value == 200) {
          Get.back();
          Get.offAndToNamed(
            '/order_success',
            arguments: order.orderId,
          );
          await OrderService().wipeCart(cartController.docId!);
        } else {
          Get.back();
          Get.snackbar("Error", "Something went wrong");
        }
      });
    } else {
      Get.toNamed('/vnpay')!.then((value) async {
        Get.log("Data from previous Screen: $value");
        if (value != null) {
          Uri uri = Uri.parse(value.toString());
          String vnpAmount = uri.queryParameters['vnp_Amount']!;
          String vnpBankCode = uri.queryParameters['vnp_BankCode']!;
          String vnpBankTranNo = uri.queryParameters['vnp_BankTranNo']!;
          String vnpCardType = uri.queryParameters['vnp_CardType']!;
          String vnpOrderInfo = uri.queryParameters['vnp_OrderInfo']!;
          String vnpPayDate = uri.queryParameters['vnp_PayDate']!;
          String vnpResponseCode = uri.queryParameters['vnp_ResponseCode']!;
          String vnpTmnCode = uri.queryParameters['vnp_TmnCode']!;
          String vnpTransactionNo = uri.queryParameters['vnp_TransactionNo']!;
          String vnpTransactionStatus =
              uri.queryParameters['vnp_TransactionStatus']!;
          String vnpTxnRef = uri.queryParameters['vnp_TxnRef']!;
          String vnpSecureHash = uri.queryParameters['vnp_SecureHash']!;

          final order = Order(
              orderId: await OrderService().getOrderId(),
              orderTypeId: type,
              usedPoint: 0,
              payType: 2,
              isPaid: true,
              discountPrice: cartController.calculateTotal(),
              subTotalPrice: cartController.calculateTotalNonDiscount(),
              shippingPrice: 0,
              totalPrice: cartController.calculateTotal(),
              products: listProducts,
              vouchers: [],
              note: noteCtl.text,
              siteId: selectSite.value,
              orderPickUp: OrderPickUp(
                datePickUp: selectDate.value,
                timePickUp: selectTime.value,
              ),
              reveicerInformation: ReveicerInformation(
                gender: true,
                fullname: nameCtl.text,
                phoneNumber: phoneCtl.text,
                email: emailCtl.text,
              ),
              vnpayInformation: VnpayInformation(
                vnpTransactionNo: vnpTransactionNo,
                vnpPayDate: vnpPayDate,
              ));

          await OrderService().postOrder(order).then((value) async {
            if (value == 200) {
              await OrderService().wipeCart(order.orderId!);
              Get.back();
              Get.offAndToNamed(
                '/order_success',
                arguments: order.orderId,
              );
            } else {
              Get.back();
              Get.snackbar("Error", "Something went wrong");
            }
          });
        } else {
          Get.back();
          Get.snackbar("Error", "You cancel the payment");
        }
      });
    }
  }

  void createOrder() {
    if (checkoutType.value == 0) {
      createOrderOnline();
    } else {
      createOrderPickUp();
    }
  }

  Future createOrderOnline() async {
    final detailUser = userController.detailUser.value;
    num type = 3;

    List<Products> listProducts = [];

    for (var element in cartController.listCart) {
      listProducts.add(Products(
        productId: element.productId,
        quantity: element.quantity,
        discountPrice: element.priceAfterDiscount,
        originalPrice: element.price,
      ));
    }

    final address = detailUser.customerAddressList!
        .singleWhere((element) => element.isMainAddress == true);

    num shipping = 25000;

    Get.dialog(
      Center(
        child: LoadingWidget(),
      ),
    );

    if (paymentType.value == 0) {
      final order = Order(
        orderId: await OrderService().getOrderId(),
        orderTypeId: type,
        usedPoint: 0,
        payType: 1,
        isPaid: false,
        discountPrice: cartController.calculateTotal(),
        subTotalPrice: cartController.calculateTotalNonDiscount(),
        shippingPrice: shipping,
        totalPrice: cartController.calculateTotal() + shipping,
        products: listProducts,
        vouchers: [],
        note: noteCtl.text,
        reveicerInformation: ReveicerInformation(
          cityId: address.cityId,
          districtId: address.districtId,
          wardId: address.wardId,
          gender: true,
          fullname: nameCtl.text,
          phoneNumber: phoneCtl.text,
          email: emailCtl.text,
          homeAddress: address.fullyAddress,
        ),
      );

      await OrderService().postOrder(order).then((value) async {
        await OrderService().wipeCart(order.orderId!);
        Get.back();
        if (value == 200) {
          Get.offAndToNamed(
            '/order_success',
            arguments: order.orderId,
          );
        } else {
          Get.back();
          Get.snackbar("Error", "Something went wrong");
        }
      });
    } else {
      Get.toNamed('/vnpay')!.then((value) async {
        Get.log("Data from previous Screen: $value");
        if (value != null) {
          Uri uri = Uri.parse(value.toString());
          String vnpAmount = uri.queryParameters['vnp_Amount']!;
          String vnpBankCode = uri.queryParameters['vnp_BankCode']!;
          String vnpBankTranNo = uri.queryParameters['vnp_BankTranNo']!;
          String vnpCardType = uri.queryParameters['vnp_CardType']!;
          String vnpOrderInfo = uri.queryParameters['vnp_OrderInfo']!;
          String vnpPayDate = uri.queryParameters['vnp_PayDate']!;
          String vnpResponseCode = uri.queryParameters['vnp_ResponseCode']!;
          String vnpTmnCode = uri.queryParameters['vnp_TmnCode']!;
          String vnpTransactionNo = uri.queryParameters['vnp_TransactionNo']!;
          String vnpTransactionStatus =
              uri.queryParameters['vnp_TransactionStatus']!;
          String vnpTxnRef = uri.queryParameters['vnp_TxnRef']!;
          String vnpSecureHash = uri.queryParameters['vnp_SecureHash']!;

          final order = Order(
              orderId: await OrderService().getOrderId(),
              orderTypeId: type,
              usedPoint: 0,
              payType: 2,
              isPaid: true,
              discountPrice: cartController.calculateTotal(),
              subTotalPrice: cartController.calculateTotalNonDiscount(),
              shippingPrice: shipping,
              totalPrice: cartController.calculateTotal() + shipping,
              products: listProducts,
              vouchers: [],
              note: noteCtl.text,
              reveicerInformation: ReveicerInformation(
                cityId: address.cityId,
                districtId: address.districtId,
                wardId: address.wardId,
                gender: true,
                fullname: nameCtl.text,
                phoneNumber: phoneCtl.text,
                email: emailCtl.text,
                homeAddress: address.fullyAddress,
              ),
              vnpayInformation: VnpayInformation(
                vnpTransactionNo: vnpTransactionNo,
                vnpPayDate: vnpPayDate,
              ));

          await OrderService().postOrder(order).then((value) async {
            await OrderService().wipeCart(order.orderId!);
            Get.back();
            if (value == 200) {
              Get.offAndToNamed(
                '/order_success',
                arguments: order.orderId,
              );
            } else {
              Get.back();
              Get.snackbar("Error", "Something went wrong");
            }
          });
        } else {
          Get.back();
          Get.snackbar("Error", "You cancel the payment");
        }
      });
    }
  }

  Future redirectToVnPay() async {}
}
