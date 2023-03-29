import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/screens/address/address.dart';
import 'package:pharmacy_mobile/screens/checkout/checkout.dart';

class CheckoutController extends GetxController {
  RxBool isCollase = false.obs;

  RxDouble panelHeight = (Get.height * .1).obs;

  final nameCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final address = TextEditingController();

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
          icon: Icons.home,
          label: "Address",
          txtCtrl: address,
          type: TextInputType.streetAddress,
          fn: () {
            Get.put(AddressController());
            showModalBottomSheet(
              useSafeArea: true,
              enableDrag: true,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: Get.context!,
              builder: (context) {
                return const AddressSelectionScreen();
              },
            );
          }),
      TextFieldProperty(
          icon: Icons.phone,
          label: "Phone Number",
          txtCtrl: phoneCtl,
          type: TextInputType.phone),
    ];

    super.onInit();
  }

  void toggleOrderType(int? index) {
    checkoutType.value = index!;
  }
}
