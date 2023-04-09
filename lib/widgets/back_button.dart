import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';

class PharmacyBackButton extends GetView<AppController> {
  const PharmacyBackButton({this.fn, super.key});

  final Function? fn;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        color: Colors.white,
        shape: NeumorphicShape.flat,
      ),
      onPressed: () {
        controller.drawerKey.currentState!.closeDrawer();
        controller.drawerKey.currentState!.closeEndDrawer();
        Get.back();
        if (fn != null) {
          fn!();
        }
      },
      child: const Icon(
        CupertinoIcons.back,
        color: Colors.black,
      ),
    );
  }
}
