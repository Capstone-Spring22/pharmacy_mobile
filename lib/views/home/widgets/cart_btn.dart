import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';

class CartButton extends GetView<AppController> {
  const CartButton({super.key, this.fn});

  final VoidCallback? fn;

  @override
  Widget build(BuildContext context) {
    return GetX<CartController>(builder: (cartCtrl) {
      return Badge(
        isLabelVisible: cartCtrl.listCart.isNotEmpty,
        label: Text(cartCtrl.listCart.length.toString()),
        child: NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: const NeumorphicBoxShape.circle(),
            color: context.theme.canvasColor,
            shape: NeumorphicShape.flat,
          ),
          onPressed: fn ?? () => controller.toggleCartDrawer(),
          child: const Icon(
            Icons.shopping_bag_outlined,
          ),
        ),
      );
    });
  }
}

class CartButtonNoNeu extends GetView<AppController> {
  const CartButtonNoNeu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => controller.toggleCartDrawer(),
      icon: const Icon(
        Icons.shopping_bag_outlined,
      ),
    );
  }
}
