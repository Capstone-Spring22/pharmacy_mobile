import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';

class CartButton extends GetView<AppController> {
  const CartButton({
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
      onPressed: () => controller.toggleSideDrawer(),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.black,
      ),
    );
  }
}

class CartButtonNoNeu extends GetView<AppController> {
  const CartButtonNoNeu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => controller.toggleSideDrawer(),
      icon: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.black,
      ),
    );
  }
}
