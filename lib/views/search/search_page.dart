import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/views/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/views/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/views/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/views/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

import '../home/widgets/search.dart';

class SearchScreen extends GetView<AppController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: 500.milliseconds);
    final textCtl = TextEditingController();
    textCtl.addListener(() {
      debouncer(() {
        controller.searchCtl.value = textCtl.text;
      });
    });
    return OpenContainer(
      closedColor: context.theme.canvasColor,
      closedElevation: 0,
      closedBuilder: (context, action) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RoundedSearchInput(
            enable: false,
            hintText: "search_home".tr,
            textController: textCtl,
            color: Colors.transparent,
          ),
        );
      },
      openBuilder: (context, action) {
        return Scaffold(
          drawer: const MenuDrawer(),
          endDrawer: const CartDrawer(),
          appBar: PharmacyAppBar(
            leftWidget: PharmacyBackButton(
              fn: () {
                textCtl.clear();
                controller.searchCtl.value = "";
              },
            ),
            midText: "Tìm kiếm thuốc",
            rightWidget: const CartButton(),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: RoundedSearchInput(
                    enable: true,
                    hintText: "Tìm kiếm thuốc",
                    textController: textCtl,
                    color: Colors.transparent,
                  ),
                ),
                Obx(() {
                  return Expanded(
                    child: Column(
                      children: [
                        if (controller.searchCtl.value.isEmpty)
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: .6,
                              children: productController.trending
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
                          ),
                        if (controller.searchCtl.value.isNotEmpty)
                          Expanded(
                            child: FutureBuilder(
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingWidget(
                                    size: 40,
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text("Không tìm thấy sản phẩm"),
                                  );
                                } else {
                                  final list = snapshot.data;
                                  Get.log(list!.length.toString());
                                  return ListView.builder(
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      final item = list[index];

                                      return ListTile(
                                        leading: CachedNetworkImage(
                                          imageUrl: item.imageModel!.imageURL!,
                                          height: Get.height * .2,
                                          width: Get.width * .2,
                                          placeholder: (context, url) =>
                                              LoadingWidget(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        title: Text(item.name!),
                                        subtitle: Text(
                                          item.price!.convertCurrentcy(),
                                        ),
                                        onTap: () => Get.toNamed(
                                          '/product_detail',
                                          preventDuplicates: false,
                                          arguments: item.id,
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              future: ProductService().getListProductByName(
                                appController.searchCtl.value,
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
