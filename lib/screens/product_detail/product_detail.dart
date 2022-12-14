import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/screens/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/screens/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/screens/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/back_button.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen(
      {super.key, required this.title, required this.img});

  final String title;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title,maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(),),
      //   centerTitle: true,
      // ),
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      appBar: PharmacyAppBar(
        leftWidget: const PharmacyBackButton(),
        midText: title,
        rightWidget: const CartButton(),
        titleStyle: context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: img,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AutoSizeText(
              title,
              maxLines: 3,
              style: context.textTheme.labelLarge!.copyWith(fontSize: 24),
            ),
          )
        ],
      ),
    );
  }
}
