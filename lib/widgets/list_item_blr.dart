import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/product_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/models/main_cate.dart';
import 'package:pharmacy_mobile/models/product.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
import 'package:pharmacy_mobile/views/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/widgets/detail_content.dart';

class ListItemBuilder extends StatelessWidget {
  const ListItemBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ProductController>(
      builder: (controller) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: controller.isFinishLoading.value
              ? FutureBuilder(
                  future: Future.wait([
                    ProductService().fetchHomePageProduct(1),
                    ProductService().fetchCategories(),
                    ProductService().fetchHomePageProduct(2),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: LoadingWidget(
                        size: 60,
                      ));
                    } else {
                      final listHotItems =
                          snapshot.data![0] as List<PharmacyProduct>;
                      final listFastSell =
                          snapshot.data![2] as List<PharmacyProduct>;
                      final listCategory =
                          snapshot.data![1] as List<MainCategory>;
                      return Column(
                        children: [
                          DetailContent(
                            haveDivider: false,
                            title: "Sản phẩm bán chạy",
                            content: SizedBox(
                              height: Get.height * .38,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: listHotItems.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, hotItemIndex) =>
                                    SizedBox(
                                  width: Get.width * .45,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProductTile(
                                      fn: () => Get.toNamed(
                                        '/product_detail',
                                        preventDuplicates: false,
                                        arguments:
                                            listHotItems[hotItemIndex].id,
                                      ),
                                      product: listHotItems[hotItemIndex],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DetailContent(
                            haveDivider: false,
                            title: "Sản phẩm mới",
                            content: SizedBox(
                              height: Get.height * .38,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: listFastSell.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, fastSellingIndex) =>
                                    SizedBox(
                                  width: Get.width * .45,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProductTile(
                                      fn: () => Get.toNamed(
                                        '/product_detail',
                                        preventDuplicates: false,
                                        arguments:
                                            listFastSell[fastSellingIndex].id,
                                      ),
                                      product: listFastSell[fastSellingIndex],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          for (var category in listCategory)
                            if (category.noOfProducts != 0)
                              DetailContent(
                                haveDivider: false,
                                title: category.categoryName!,
                                content: FutureBuilder(
                                  builder: (context, snapCateProduct) {
                                    if (snapCateProduct.connectionState ==
                                        ConnectionState.waiting) {
                                      return const LinearProgressIndicator();
                                    } else {
                                      final listCateProduct = snapCateProduct
                                          .data as List<PharmacyProduct>;
                                      return SizedBox(
                                        height: Get.height * .38,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: listCateProduct.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder:
                                              (context, productIndex) =>
                                                  SizedBox(
                                            width: Get.width * .45,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ProductTile(
                                                fn: () => Get.toNamed(
                                                  '/product_detail',
                                                  preventDuplicates: false,
                                                  arguments: listCateProduct[
                                                          productIndex]
                                                      .id,
                                                ),
                                                product: listCateProduct[
                                                    productIndex],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  future: ProductService()
                                      .fetchProductsByMainCate(category.id!),
                                ),
                              ),
                          Container(
                            height: Get.height * .1,
                          )
                        ],
                      );
                    }
                  },
                )
              : LoadingWidget(size: 50),
        );
      },
    );
  }
}
