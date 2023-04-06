import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';

class DrawerButton extends GetView<AppController> {
  const DrawerButton({
    super.key,
    this.fn,
  });

  final VoidCallback? fn;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        boxShape: const NeumorphicBoxShape.circle(),
        color: context.theme.canvasColor,
        shape: NeumorphicShape.flat,
      ),
      onPressed: fn ?? () => controller.toggleMenuDrawer(),
      child: const Icon(
        Icons.menu,
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
          // color: Colors.black,
        ));
  }
}
