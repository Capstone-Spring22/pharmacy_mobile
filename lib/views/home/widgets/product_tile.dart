import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/widgets/quan_control.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({super.key, required this.fn, required this.product});

  final VoidCallback fn;
  final PharmacyProduct product;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'This is a bottom modal dialog with animation. ${widget.product.imageModel!.imageURL}'),
                    const SizedBox(height: 20.0),
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            );
          },
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
        );
      },
      child: NeumorphicButton(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        style: NeumorphicStyle(
          color: context.theme.canvasColor,
          lightSource: LightSource.top,
        ),
        onPressed: widget.fn,
        child: Column(
          children: [
            if (widget.product.imageModel == null) LoadingWidget(),
            if (widget.product.imageModel != null)
              Hero(
                tag: 'image${widget.product.id}',
                child: CachedNetworkImage(
                  height: Get.height * .18,
                  width: Get.width * .4,
                  imageUrl: widget.product.imageModel!.imageURL!,
                  placeholder: (context, url) => LoadingWidget(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            Text(
              widget.product.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tileTitle,
            ),
            Text(
              '${widget.product.priceAfterDiscount!.convertCurrentcy()} / ${widget.product.productUnitReferences![0].unitName}',
              textAlign: TextAlign.center,
              style: tilePrice.copyWith(color: Colors.blue),
            ),
            widget.product.isPrescription!
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AutoSizeText(
                      "Can't buy without prescription",
                      style: tilePrice.copyWith(color: Colors.blue),
                      maxLines: 2,
                    ),
                  )
                : BuyButton(
                    id: widget.product.id!,
                    price: widget.product.price!,
                    priceAfterDiscount: widget.product.priceAfterDiscount!,
                  ),
          ],
        ),
      ),
    );
  }
}

class BuyButton extends StatefulWidget {
  const BuyButton({
    super.key,
    required this.id,
    required this.price,
    required this.priceAfterDiscount,
  });

  final String id;
  final num price;
  final num priceAfterDiscount;

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
    return SizedBox(
      height: Get.height * .05,
      child: GetX<CartController>(
        builder: (controller) {
          bool isInCart =
              controller.listCart.any((e) => e.productId == widget.id);
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: isInCart
                ? QuantityControl(widget.id)
                : FilledButton(
                    onPressed: () => controller.addToCart(CartItem(
                      productId: widget.id,
                      quantity: 1,
                      price: widget.priceAfterDiscount,
                    )),
                    child: const Text("Add to Cart"),
                  ),
          );
        },
      ),
    );
  }
}
