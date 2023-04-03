import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/models/cart.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
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
            BuyButton(product: widget.product)
          ],
        ),
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
    return Expanded(
      child: Column(
        children: [
          FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget();
              } else {
                final unit = snapshot.data;
                return Text(
                  '${convertCurrency(num.parse(widget.product.price.toString()))} / ${unit!.unitName!}',
                  textAlign: TextAlign.center,
                  style: tilePrice.copyWith(color: Colors.blue),
                );
              }
            },
            future: ProductService().getProductUnitById(widget.product.unitId!),
          ),
          Expanded(
            child: SizedBox(
                width: double.infinity,
                child: GetX<CartController>(
                  builder: (controller) {
                    bool isInCart = controller.listCart
                        .any((e) => e.productId == widget.product.id);
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                      child: isInCart
                          ? QuantityControl(widget.product.id!)
                          : FilledButton(
                              onPressed: () => controller.addToCart(CartItem(
                                productId: widget.product.id!,
                                quantity: 1,
                                price: widget.product.priceAfterDiscount,
                              )),
                              child: const Text("Add to Cart"),
                            ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
