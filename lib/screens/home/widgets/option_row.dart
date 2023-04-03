import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/screens/home/widgets/option_box.dart';
import 'package:pharmacy_mobile/services/product_service.dart';

class OptionButtonRow extends StatelessWidget {
  const OptionButtonRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OptionBox(
          color: Colors.blue[100]!.withOpacity(.5),
          image: "assets/images/Pill.png",
          text: "drug_btn".tr,
          func: () {},
        ),
        OptionBox(
          color: Colors.yellow[100]!.withOpacity(1),
          image: "assets/images/Image.png",
          text: "prescription_btn".tr,
          func: () => ProductService().checkAvailSite(),
        ),
        OptionBox(
          color: Colors.green[100]!.withOpacity(.7),
          image: "assets/images/UserFocus.png",
          text: "contact_btn".tr,
          func: () {
            if (userController.isLoggedIn.isTrue) {
              Get.toNamed("/chat");
            } else {
              Get.toNamed("/signin");
            }
          },
        ),
      ],
    );
  }
}
