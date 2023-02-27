import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_mobile/screens/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/screens/product_detail/product_detail.dart';
import 'package:pharmacy_mobile/services/product_service.dart';

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Lottie.asset('assets/lottie/capsule_loading.json');
        } else {
          final res = snapshot.data;
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: .8,
            children: res!
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
      },
      future: ProductService().getProducts(1, 10),
    );
  }
}
