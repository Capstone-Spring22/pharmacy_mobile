import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/main.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';
import 'package:pharmacy_mobile/views/drawer/widgets/auth_button_row.dart';
import 'package:pharmacy_mobile/views/user/widget/info_card.dart';
import 'package:pharmacy_mobile/widgets/user_avatar.dart';

import 'widget/address_card.dart';

class UserScreen extends GetView<UserController> {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (userController.isLoggedIn.value &&
          controller.user.value is PharmacyUser &&
          controller.detailUser.value is DetailUser) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const UserAvatar().animate().flipH(),
                    controller.user.value!.name == null
                        ? AutoSizeText(
                            "Đặt tên >",
                            style: context.textTheme.headlineMedium!.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              shadows: [
                                const Shadow(
                                  color: Colors.blue,
                                  offset: Offset(0, -5),
                                )
                              ],
                              color: Colors.transparent,
                            ),
                          )
                        : AutoSizeText(
                            controller.user.value!.name!,
                            style: context.textTheme.headlineMedium!.copyWith(
                              decorationColor: Colors.blue,
                              shadows: [
                                const Shadow(
                                  color: Colors.blue,
                                  offset: Offset(0, -5),
                                )
                              ],
                              color: Colors.transparent,
                            ),
                          ),
                    for (int i = 0; i < _buildUserCard(context).length; i++)
                      _buildUserCard(context)[i]
                          .animate()
                          .slideY(delay: Duration(milliseconds: 10 * i))
                          .fadeIn(delay: Duration(milliseconds: 10 * i))
                  ],
                ),
              ),
            ),
          ),
        );
      } else {
        return const Scaffold(
          body: Center(
            child: AuthButtonRow(),
          ),
        );
      }
    });
  }

  List<Widget> _buildUserCard(BuildContext context) {
    final user = controller.user.value!;
    final userDetail = controller.detailUser.value!;
    return [
      InfoCard(
        icon: Icons.phone,
        text: user.phoneNo.toString(),
        color: const Color(0xff8d7aee),
      ),
      InfoCard(
        icon: Icons.email,
        text: user.email.toString(),
        color: const Color(0xfff468b7),
      ),
      InfoCard(
        icon: Icons.cake,
        text: userDetail.dob!.convertToDate,
        color: const Color(0xffffc85b),
      ),
      InfoCard(
        icon: Icons.shopify_outlined,
        text: "${userController.point} Điểm mua hàng",
        color: const Color.fromARGB(255, 17, 228, 123),
      ),
      GestureDetector(
        onTap: () => Get.toNamed('/order_history'),
        child: const InfoCard(
          icon: Icons.list_alt,
          text: "Đơn hàng",
          color: Color(0xff5dd1d3),
        ),
      ),
      const AddressCard(),
    ];
  }
}
