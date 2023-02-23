import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/controller.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/screens/camera/camera.dart';
import 'package:pharmacy_mobile/screens/chat/chat.dart';
import 'package:pharmacy_mobile/screens/drawer/cart_drawer.dart';
import 'package:pharmacy_mobile/screens/drawer/menu_drawer.dart';
import 'package:pharmacy_mobile/screens/home/home.dart';
import 'package:pharmacy_mobile/screens/nav_hub/nav_items/nav_home.dart';
import 'package:pharmacy_mobile/screens/store/store.dart';
import 'package:pharmacy_mobile/screens/user/user.dart';

class NavBarHub extends GetView<AppController> {
  const NavBarHub({super.key});

  @override
  Widget build(BuildContext context) {
    notiController.requestAppPermissions();
    return Scaffold(
      key: controller.drawerKey,
      extendBody: true,
      bottomNavigationBar: const NavHomeItem(),
      drawer: const MenuDrawer(),
      endDrawer: const CartDrawer(),
      body: GetX<AppController>(
        builder: (_) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _switchWidget(controller.pageIndex.value),
          );
        },
      ),
    );
  }

  Widget _switchWidget(int i) {
    switch (i) {
      case 0:
        return const HomeScreen();
      case 1:
        return const StoreScreen();
      case 2:
        return const CameraScreen();
      case 3:
        return const ChatScreen();
      case 4:
        return const UserScreen();
      default:
        return const HomeScreen();
    }
  }
}
