import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/screens/camera/camera.dart';
import 'package:pharmacy_mobile/screens/chat/chat.dart';
import 'package:pharmacy_mobile/screens/drawer/drawer.dart';
import 'package:pharmacy_mobile/screens/home/home.dart';
import 'package:pharmacy_mobile/screens/nav_hub/nav_items/nav_home.dart';
import 'package:pharmacy_mobile/screens/store/store.dart';
import 'package:pharmacy_mobile/screens/user/user.dart';

class NavBarHub extends GetView<AppController> {
  const NavBarHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const NavHomeItem(),
      body: GetX<AppController>(
        // builder: (_) => ZoomDrawer(
        //   controller: _.cartDrawerController,
        //   menuScreen: const DrawerMenu(),
        //   mainScreen: ColoredBox(
        //     color: Colors.white,
        //     child: ZoomDrawer(
        //       controller: _.menuDrawerController,
        //       menuScreen: const DrawerMenu(),
        //       mainScreen: ColoredBox(
        //         color: Colors.white,
        //         child: AnimatedSwitcher(
        //           duration: const Duration(milliseconds: 300),
        //           child: _switchWidget(controller.pageIndex.value),
        //         ),
        //       ),
        //       borderRadius: 24.0,
        //       showShadow: true,
        //       angle: -12.0,
        //       drawerShadowsBackgroundColor: Colors.grey,
        //       slideWidth: MediaQuery.of(context).size.width * 0.65,
        //     ),
        //   ),
        //   borderRadius: 24.0,
        //   showShadow: true,
        //   angle: -12.0,
        //   isRtl: true,
        //   drawerShadowsBackgroundColor: Colors.grey,
        //   slideWidth: MediaQuery.of(context).size.width * 0.65,
        // ),
        builder: (_) => ZoomDrawer(
          controller: _.cartDrawerController,
          menuScreen: const DrawerMenu(),
          mainScreen: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _switchWidget(controller.pageIndex.value),
          ),
          borderRadius: 24.0,
          showShadow: true,
          angle: -12.0,
          style: DrawerStyle.defaultStyle,
          isRtl: true,
          drawerShadowsBackgroundColor: Colors.grey,
          slideWidth: MediaQuery.of(context).size.width * 0.65,
        ),
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
