import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/product_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/views/home/widgets/product_tile.dart';

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ProductController>(
      builder: (controller) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isFinishLoading.value
              ? Builder(
                  builder: (context) {
                    return Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: .6,
                          children: controller.products
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: ProductTile(
                                    fn: () => Get.toNamed(
                                      '/product_detail',
                                      preventDuplicates: false,
                                      arguments: e.id,
                                    ),
                                    product: e,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        Container(
                          height: Get.height * .1,
                        )
                      ],
                    );
                  },
                )
              : LoadingWidget(size: 50),
        );
      },
    );
  }
}
