import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/debug/screen.dart';
import 'package:pharmacy_mobile/models/detail_user.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';
import 'package:pharmacy_mobile/views/alarm/alarm.dart';
import 'package:pharmacy_mobile/views/order_history/order.dart';
import 'package:pharmacy_mobile/widgets/user_avatar.dart';

import 'widgets/auth_button_row.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * .05),
                child: const UserAvatar(),
              ),
              GetX<UserController>(
                builder: (controller) => controller.user.value
                            is PharmacyUser &&
                        controller.detailUser.value is DetailUser
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            AutoSizeText(
                              controller.user.value!.name!,
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
                            ),
                            Text(
                              controller.formatPhoneNumber(
                                  controller.user.value!.phoneNo!),
                            ),
                          ],
                        ),
                      )
                    : const AuthButtonRow(),
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white70),
              MenuItem(
                text: 'Thông báo',
                icon: Icons.notifications_outlined,
                onClicked: () => Get.toNamed('/signup'),
              ),
              OpenContainer(
                closedBuilder: (context, action) {
                  return const MenuItem(
                    text: 'Nhắc uống thuốc',
                    icon: Icons.alarm,
                  );
                },
                closedElevation: 0,
                closedColor: Colors.transparent,
                openBuilder: (context, action) {
                  return const AlarmScreen();
                },
              ),
              OpenContainer(
                closedBuilder: (context, action) {
                  return const MenuItem(
                    text: 'Đơn hàng',
                    icon: Icons.list_alt,
                  );
                },
                closedElevation: 0,
                closedColor: Colors.transparent,
                openBuilder: (context, action) {
                  return const OrderScreen();
                },
              ),
              if (kDebugMode)
                OpenContainer(
                  closedBuilder: (context, action) {
                    return const MenuItem(
                      text: 'Debug Screen',
                      icon: Icons.bug_report_sharp,
                    );
                  },
                  closedElevation: 0,
                  closedColor: Colors.transparent,
                  openBuilder: (context, action) {
                    return const DebugScreen();
                  },
                ),
              const Spacer(),
              GetX<UserController>(
                builder: (controller) => controller.isLoggedIn.value
                    ? MenuItem(
                        text: "Đăng xuất",
                        icon: Icons.logout_outlined,
                        onClicked: () => controller.logout(),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onClicked;

  const MenuItem({
    required this.text,
    required this.icon,
    this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text, style: context.textTheme.bodyLarge),
      onTap: onClicked,
    );
  }
}

class SearchFieldDrawer extends StatelessWidget {
  const SearchFieldDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return TextField(
      style: const TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: const TextStyle(color: color),
        prefixIcon: const Icon(
          Icons.search,
          color: color,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
