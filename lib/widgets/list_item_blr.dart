import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/screens/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/screens/product_detail/product_detail.dart';

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //   padding: const EdgeInsets.only(top: 0),
    //   physics: const NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) {
    //     return OpenContainer(
    //       closedElevation: 0,
    //       tappable: false,
    //       closedBuilder: (context, action) {
    //         return Padding(
    //           padding: const EdgeInsets.all(20),
    //           child: ProductTile(
    //             fn: () => action(),
    //             product: listProducts[index],
    //           ),
    //         );
    //       },
    //       openBuilder: (context, action) {
    //         return ProductDetailScreen(listProducts[index]);
    //       },
    //     );
    //     // return const Padding(
    //     //   padding: EdgeInsets.all(20.0),
    //     //   child: ProductTile(),
    //     // );
    //   },
    //   itemCount: listProducts.length,
    // );
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: .8,
      children: listProducts
          .map(
            (e) => OpenContainer(
              closedElevation: 0,
              tappable: false,
              closedBuilder: (context, action) => Padding(
                padding: const EdgeInsets.all(20),
                child: ProductTile(
                  fn: () => action(),
                  product: e,
                ),
              ),
              openBuilder: (context, action) => ProductDetailScreen(e),
            ),
          )
          .toList(),
    );
  }
}
