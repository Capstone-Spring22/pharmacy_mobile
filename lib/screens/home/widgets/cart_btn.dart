import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CartButton extends StatelessWidget {
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
      onPressed: () {},
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.black,
      ),
    );
  }
}

class CartButtonNoNeu extends StatelessWidget {
  const CartButtonNoNeu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.black,
      ),
    );
  }
}
