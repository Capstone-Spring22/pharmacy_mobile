import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/screens/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/screens/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/screens/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

import '../home/widgets/search.dart';

class SearchScreen extends GetView<AppController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: context.theme.canvasColor,
      closedElevation: 0,
      closedBuilder: (context, action) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RoundedSearchInput(
            enable: false,
            hintText: "search_home".tr,
            textController: controller.searchCtl.value,
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: RoundedSearchInput(
              enable: true,
              hintText: "search_home".tr,
              textController: TextEditingController(),
              color: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
