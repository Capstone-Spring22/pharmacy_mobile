import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/screens/drawer/widgets/auth_button_row.dart';
import 'package:pharmacy_mobile/screens/user/widget/info_card.dart';
import 'package:pharmacy_mobile/widgets/user_avatar.dart';

import 'widget/address_card.dart';

class UserScreen extends GetView<UserController> {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (userController.isLoggedIn.value) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const UserAvatar(),
                  controller.user.value.name == null
                      ? AutoSizeText(
                          "Set Name and Info",
                          style: context.textTheme.headlineSmall!.copyWith(
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
                          style: context.textTheme.headlineSmall!.copyWith(
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
                    text: DateFormat.yMMMMd().format(DateTime.parse(
                        controller.detailUser.value.dob.toString())),
                  ),
                  const AddressCard(),
                  GestureDetector(
                    onTap: () => Get.toNamed('/order_history'),
                    child: const InfoCard(
                      icon: Icons.list_alt,
                      text: "Order History",
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
  }
}
