import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';

class HorizontalList extends StatefulWidget {
  const HorizontalList(this.ctl, {super.key});

  final CartController ctl;

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final item = widget.ctl.listCart[index];
    return SizedBox(
      height: Get.height * .2,
      key: UniqueKey(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HorizontalCardPager(
            initialPage: index,
            onPageChanged: (page) {
              if (page.toString().endsWith(".0")) {
                setState(() {
                  index = page.toInt();
                });
              }
            },
            items: widget.ctl.listCart.map((e) {
              final item = productController.getProductById(e.pid);
              return ImageCarditem(
                item.imageModel!.imageURL!,
                h: Get.width * 0.25,
                w: Get.width * 0.25,
                context: context,
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AutoSizeText(
              "${productController.getProductById(item.pid).name} - ${item.quantity} - ${convertCurrency(item.price)}",
            ),
          )
        ],
      ),
    );
  }
}

class ImageCarditem extends CardItem {
  final String image;

  double h;
  double w;

  BuildContext context;

  ImageCarditem(this.image,
      {required this.h, required this.w, required this.context});

  @override
  Widget? buildWidget(double diffPosition) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: context.theme.primaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: CachedNetworkImage(
          width: h,
          height: w,
          imageUrl: image,
          placeholder: (context, url) => LoadingWidget(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
