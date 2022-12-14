import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_mobile/screens/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/screens/product_detail/product_detail.dart';

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        const String img =
            "https://cdn.tgdd.vn/Products/Images/10250/181211/dc-ve-sinh-mui-rohto-nose-wash-400ml-2-1.jpg";
        const String name =
            "Bộ dụng cụ vệ sinh mũi Rohto NoseWash hộp 1 bình + 400ml dung dịch";
        return OpenContainer(
          closedElevation: 0,
          tappable: false,
          closedBuilder: (context, action) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ProductTile(fn: () => action()),
            );
          },
          openBuilder: (context, action) {
            return const ProductDetailScreen(title: name, img: img);
          },
        );
        // return const Padding(
        //   padding: EdgeInsets.all(20.0),
        //   child: ProductTile(),
        // );
      },
      itemCount: 10,
    );
  }
}
