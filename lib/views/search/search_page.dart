import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/helpers/loading.dart';
import 'package:pharmacy_mobile/views/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/views/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/views/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/services/product_service.dart';
import 'package:pharmacy_mobile/views/search/widget/search_item.dart';
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
                          const Center(
                            child: Text("Nhập tên thuốc cần tìm"),
                          ),
                        if (controller.searchCtl.value.isNotEmpty)
                          Expanded(
                            child: FutureBuilder(
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const LoadingWidget(
                                    size: 40,
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text("Không tìm thấy sản phẩm"),
                                  );
                                } else {
                                  final list = snapshot.data;

                                  return ListView.builder(
                                    itemCount: list!.length,
                                    itemBuilder: (context, index) {
                                      final item = list[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: SearchItem(item: item),
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
