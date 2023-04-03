import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/screens/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/screens/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/screens/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/screens/home/widgets/product_tile.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

import '../home/widgets/search.dart';

class SearchScreen extends GetView<AppController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textCtl = TextEditingController();
    textCtl.addListener(() {
      controller.searchCtl.value = textCtl.text;
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
            leftWidget: const PharmacyBackButton(),
            midText: "Search",
            rightWidget: const CartButton(),
            titleStyle:
                context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: RoundedSearchInput(
                    enable: true,
                    hintText: "search_home".tr,
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
                                return ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text("Item $index"),
                                    );
                                  },
                                );
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
