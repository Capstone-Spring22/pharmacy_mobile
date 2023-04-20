// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/models/order.dart';
import 'package:pharmacy_mobile/views/checkout/checkout.dart';
import 'package:pharmacy_mobile/services/order_service.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutController extends GetxController {
  RxBool isCollase = false.obs;

  RxDouble panelHeight = (Get.height * .1).obs;

  final nameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final addressCtl = TextEditingController();
  final emailCtl = TextEditingController();
  final noteCtl = TextEditingController();
  final pointCtl = TextEditingController();

  Rx<ScrollController?> scrollController = null.obs;

  RxString selectSite = "".obs;
  RxString selectDate = "".obs;
  RxString selectTime = "".obs;

  RxBool activeBtn = true.obs;

  RxBool usePoint = false.obs;
  Rx<num> reducePrice = 0.obs;

  RxInt paymentType = 0.obs;
  //0 - Cash
  //1 - Card

  RxInt checkoutType = 0.obs;
  //0 - Online
  //1 - Pickup

  void rowView() => isCollase.value = true;
  void colView() => isCollase.value = false;

  final formKey = GlobalKey<FormState>();
  final debouncer = Debouncer(delay: 300.milliseconds);

  num shipping = 25000;

  double linearInterpolationTop() {
    return 0.8 * (panelHeight.value - 0.1);
  }

  void setPanelHeight(double d) {
    panelHeight.value = d;
  }

  RxInt pointUsed = 0.obs;

  RxBool loading = false.obs;

  RxList<TextFieldProperty> listTextField = <TextFieldProperty>[].obs;

  @override
  void onInit() {
    final user = userController.user.value;
    final detailUser = userController.detailUser.value;

    ever(checkoutType, (type) {
      if (type == 0) {
        selectSite.value = "";
        selectDate.value = "";
        selectTime.value = "";
        setBtnActive(userController.detailUser.value!);
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

    if (user!.name != null) {
      nameCtl.text = user.name!;
    }
    phoneCtl.text = user.phoneNo!;
    emailCtl.text = detailUser!.email ?? "";

    listTextField.value = [
      TextFieldProperty(
          icon: Icons.person,
          label: "Tên",
          txtCtrl: nameCtl,
          type: TextInputType.name),
      TextFieldProperty(
          icon: Icons.phone,
          label: "Số điện thoại",
          txtCtrl: phoneCtl,
          type: TextInputType.phone),
      TextFieldProperty(
          icon: Icons.email,
          label: "Email (Không yêu cầu)",
          txtCtrl: emailCtl,
          type: TextInputType.emailAddress),
      TextFieldProperty(
          icon: Icons.note,
          label: "Ghi chú (Không yêu cầu)",
          txtCtrl: noteCtl,
          type: TextInputType.multiline),
    ];
    super.onInit();
  }

  String? validatePoint() {
    int point = 0;
    try {
      point = int.parse(pointCtl.text);
    } catch (e) {}

    final userPoint = userController.point;

    final totalPrice = cartController.calculateTotalNonDiscount();

    if (point > userPoint) {
      pointUsed.value = 0;
      return "Số điểm không đủ, tối đa ${userController.point} điểm";
    }
    if (point * 1000 > totalPrice) {
      pointUsed.value = 0;
      return "Số điểm không được lớn hơn tổng tiền";
    }
    return null;
  }

  void calculateUsedPoint() {
    final point = userController.point;

    final total = cartController.calculateTotalNonDiscount();

    final input = pointCtl.text;
    if (validatePoint() == null) {
      if (input.isNumericOnly) {
        try {
          pointUsed.value = int.parse(input);
        } catch (e) {
          Get.log('calc Used point: $e - $input');
        }
      } else {
        Get.log('NaN: $input');
      }

      reducePrice.value = pointUsed.value * 1000;
    } else {
      reducePrice.value = 0;
    }
  }

  String calcTotal() {
    num total = cartController.calculateTotalNonDiscount();
    if (usePoint.value) {
      total -= reducePrice.value;
    }
    if (checkoutType.value == 0) {
      total += shipping;
    }
    return total.convertCurrentcy();
  }

  void setBtnActive(DetailUser u) async {
    loading.value = true;
    final uAddress = u.customerAddressList
        ?.singleWhere((element) => element.isMainAddress == true);
    final i = await OrderService()
        .checkSiteListAvailable(uAddress!.cityId!, uAddress.districtId!);
    Get.log('Check SITE: $i');
    if (checkoutType.value == 0) {
      i > 0 ? activeBtn.value = true : activeBtn.value = false;
    }
    loading.value = false;
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
    if (index == 0) {
      shipping = 25000;
    } else {
      shipping = 0;
    }
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
      const Center(
        child: LoadingWidget(),
      ),
    );

    if (paymentType.value == 0) {
      // Cash Pickup
      final order = Order(
        orderId: await OrderService().getOrderId(),
        orderTypeId: type,
        usedPoint: pointUsed.value,
        payType: 1,
        isPaid: false,
        discountPrice: pointUsed.value * 1000,
        subTotalPrice: cartController.calculateTotalNonDiscount(),
        shippingPrice: 0,
        totalPrice: cartController.calculateTotalNonDiscount() -
            (usePoint.value ? reducePrice.value : 0) +
            (checkoutType.value == 0 ? shipping : 0),
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
          await OrderService().wipeCart(cartController.docId!);
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
      // Online Bank Pickup
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
              usedPoint: pointUsed.value,
              payType: 2,
              isPaid: true,
              discountPrice: pointUsed.value * 1000,
              subTotalPrice: cartController.calculateTotalNonDiscount(),
              shippingPrice: 0,
              totalPrice: cartController.calculateTotalNonDiscount() -
                  (usePoint.value ? reducePrice.value : 0) +
                  (checkoutType.value == 0 ? shipping : 0),
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
              await OrderService().wipeCart(cartController.docId!);
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

    final address = detailUser!.customerAddressList!
        .singleWhere((element) => element.isMainAddress == true);

    Get.dialog(
      const Center(
        child: LoadingWidget(),
      ),
    );

    if (paymentType.value == 0) {
      //Cash Delivery
      final order = Order(
        orderId: await OrderService().getOrderId(),
        orderTypeId: type,
        usedPoint: pointUsed.value,
        payType: 1,
        isPaid: false,
        discountPrice: pointUsed.value * 1000,
        subTotalPrice: cartController.calculateTotalNonDiscount(),
        shippingPrice: shipping,
        totalPrice: cartController.calculateTotalNonDiscount() -
            (usePoint.value ? reducePrice.value : 0) +
            (checkoutType.value == 0 ? shipping : 0),
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
          homeAddress: address.homeAddress,
        ),
      );

      await OrderService().postOrder(order).then((value) async {
        await OrderService().wipeCart(cartController.docId!);
        Get.back();
        if (value == 200) {
          Get.offNamedUntil(
            '/order_success',
            (route) => route.settings.name == '/navhub',
            arguments: order.orderId,
          );
        } else {
          Get.back();
          Get.snackbar("Error", "Something went wrong");
        }
      });
    } else {
      //Online Bank Delivery
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
              usedPoint: pointUsed.value,
              payType: 2,
              isPaid: true,
              discountPrice: pointUsed.value * 1000,
              subTotalPrice: cartController.calculateTotalNonDiscount(),
              shippingPrice: shipping,
              totalPrice: cartController.calculateTotalNonDiscount() -
                  (usePoint.value ? reducePrice.value : 0) +
                  (checkoutType.value == 0 ? shipping : 0),
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
                homeAddress: address.homeAddress,
              ),
              vnpayInformation: VnpayInformation(
                vnpTransactionNo: vnpTransactionNo,
                vnpPayDate: vnpPayDate,
              ));

          await OrderService().postOrder(order).then((value) async {
            await OrderService().wipeCart(cartController.docId!);
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
