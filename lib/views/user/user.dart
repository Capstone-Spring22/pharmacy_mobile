import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/main.dart';
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
          controller.user.value.phoneNo != null) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const UserAvatar(),
                    const SizedBox(height: 20),
                    controller.user.value.name == null
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
                            controller.user.value.name!,
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
                    InfoCard(
                      icon: Icons.phone,
                      text: controller.user.value.phoneNo.toString(),
                    ),
                    InfoCard(
                      icon: Icons.email,
                      text: controller.user.value.email.toString(),
                    ),
                    InfoCard(
                      icon: Icons.cake,
                      text: controller.detailUser.value.dob!.convertToDate,
                    ),
                    const AddressCard(),
                    GestureDetector(
                      onTap: () => Get.toNamed('/order_history'),
                      child: const InfoCard(
                        icon: Icons.list_alt,
                        text: "Đơn hàng",
                      ),
                    )
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
}
