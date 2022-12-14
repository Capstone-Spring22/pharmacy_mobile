import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';

class DrawerButton extends GetView<AppController> {
  const DrawerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: const NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        color: Colors.white,
        shape: NeumorphicShape.flat,
      ),
      onPressed: () => controller.toggleMenuDrawer(),
      child: const Icon(
        Icons.menu,
        color: Colors.black,
      ),
    );
  }
}

class DrawerButtonNoNeu extends GetView<AppController> {
  const DrawerButtonNoNeu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => controller.toggleMenuDrawer(),
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ));
  }
}
