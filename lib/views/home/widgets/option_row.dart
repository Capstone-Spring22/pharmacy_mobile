import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/views/home/widgets/option_box.dart';

class OptionButtonRow extends StatelessWidget {
  const OptionButtonRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: Get.width * .4,
          child: OptionBox(
            color: Colors.blue[100]!.withOpacity(.5),
            Iconcolor: Colors.blue,
            icon: MdiIcons.pill,
            text: "drug_btn".tr,
            func: () => Get.toNamed("/browse_product"),
          ),
        ),
        SizedBox(
          width: Get.width * .4,
          child: OptionBox(
            color: Colors.green[100]!.withOpacity(.7),
            Iconcolor: Colors.green,
            icon: MdiIcons.doctor,
            text: "contact_btn".tr,
            func: () {
              if (userController.isLoggedIn.isTrue) {
                Get.toNamed("/chat");
              } else {
                Get.toNamed("/signin");
              }
            },
          ),
        ),
      ],
    );
  }
}
