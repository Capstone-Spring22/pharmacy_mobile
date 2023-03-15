import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/product_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/screens/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/screens/product_detail/product_detail.dart';

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   builder: (context, snapshot) {
    //     return AnimatedSwitcher(
    //       duration: const Duration(milliseconds: 300),
    //       child: snapshot.connectionState == ConnectionState.waiting
    //           ? LoadingWidget(size: 50)
    //           : Builder(
    //               builder: (context) {
    //                 final res = snapshot.data;
    //                 return GridView.count(
    //                   crossAxisCount: 2,
    //                   shrinkWrap: true,
    //                   physics: const NeverScrollableScrollPhysics(),
    //                   childAspectRatio: .6,
    //                   children: res!
    //                       .map(
    //                         (e) => OpenContainer(
    //                           closedElevation: 0,
    //                           tappable: false,
    //                           closedBuilder: (context, action) => Padding(
    //                             padding: const EdgeInsets.all(20),
    //                             child: ProductTile(
    //                               fn: () => action(),
    //                               product: e,
    //                             ),
    //                           ),
    //                           openBuilder: (context, action) =>
    //                               ProductDetailScreen(e),
    //                         ),
    //                       )
    //                       .toList(),
    //                 );
    //               },
    //             ),
    //     );
    //   },
    //   future: ProductService().getProducts(1, 10),
    // );
    return GetX<ProductController>(
      builder: (controller) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isFinishLoading.value
              ? Builder(
                  builder: (context) {
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: .6,
                      children: controller.products
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
                              openBuilder: (context, action) =>
                                  ProductDetailScreen(e),
                            ),
                          )
                          .toList(),
                    );
                  },
                )
              : LoadingWidget(size: 50),
        );
      },
    );
  }
}
