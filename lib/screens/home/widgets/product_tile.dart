import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/helpers/formatter.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/models/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.fn, required this.product});

  final VoidCallback fn;
  final PharmacyProduct product;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      style: NeumorphicStyle(
        color: context.theme.canvasColor,
        lightSource: LightSource.top,
      ),
      onPressed: fn,
      child: Column(
        children: [
          CachedNetworkImage(
            filterQuality: FilterQuality.low,
            maxHeightDiskCache: 512,
            imageUrl: product.img,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          BuyButton(product: product)
        ],
      ),
    );
  }
}

class BuyButton extends StatefulWidget {
  const BuyButton({
    super.key,
    required this.product,
  });

  final PharmacyProduct product;

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  int quan = 1;
  late Widget buyOneChild;
  late Widget buyMoreChild;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buyOneChild = const Text(
      "Buy 1",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    Widget buyMoreChild = AnimatedFlipCounter(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      value: quan,
      textStyle: const TextStyle(color: Colors.white),
    );
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "${formatter.format(widget.product.price).toString()} VND",
              textAlign: TextAlign.center,
              style: context.textTheme.labelLarge!.copyWith(color: Colors.blue),
            ),
          ),
          // Expanded(
          //   child: NeumorphicButton(
          //     padding: EdgeInsets.zero,
          //     provideHapticFeedback: true,
          //     style: const NeumorphicStyle(
          //       color: Colors.white,
          //       lightSource: LightSource.top,
          //       shape: NeumorphicShape.flat,
          //     ),
          //     // child: Row(
          //     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     //   children: [
          //     //     IconButton(
          //     //       padding: EdgeInsets.zero,
          //     //       onPressed: () {
          //     //         setState(() => quan > 1 ? --quan : quan = 1);
          //     //       },
          //     //       icon: const Icon(
          //     //         Icons.remove,
          //     //         color: Colors.white,
          //     //       ),
          //     //     ),
          //     //     const Icon(
          //     //       Icons.shopping_cart_checkout_sharp,
          //     //       color: Colors.white,
          //     //     ),
          //     //     AnimatedSwitcher(
          //     //       switchInCurve: Curves.easeIn,
          //     //       duration: const Duration(milliseconds: 300),
          //     //       child: quan > 1 ? buyMoreChild : buyOneChild,
          //     //     ),
          //     //     IconButton(
          //     //       padding: EdgeInsets.zero,
          //     //       onPressed: () {
          //     //         setState(() => ++quan);
          //     //       },
          //     //       icon: const Icon(
          //     //         Icons.add,
          //     //         color: Colors.white,
          //     //       ),
          //     //     ),
          //     //   ],
          //     // ),
          //     child: SizedBox(width: Get.width * 0.1, child: const Text("Buy")),
          //     onPressed: () {
          //       final cart = CartItem(
          //           product: widget.product,
          //           quantity: quan,
          //           price: widget.product.price * quan);

          //       cartController.addToCart(cart);
          //     },
          //   ),
          // )
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final cart = CartItem(
                      product: widget.product,
                      quantity: quan,
                      price: widget.product.price * quan);

                  cartController.addToCart(cart);
                },
                child: const Text("Add to Cart"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
