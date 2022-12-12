import 'package:cnav/cnav.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';

class NavHomeItem extends StatelessWidget {
  const NavHomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AppController>(builder: (ctl) {
      return CNav(
        iconSize: 30.0,
        margin: const EdgeInsets.all(20),
        borderRadius: const Radius.circular(10),
        selectedColor: const Color(0xff040307),
        strokeColor: const Color(0x30040307),
        unSelectedColor: const Color(0xffacacac),
        backgroundColor: Colors.white,
        elevation: 5,
        isFloating: true,
        items: const [
          CNavItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          CNavItem(
            icon: Icon(
              FontAwesomeIcons.store,
              size: 25,
            ),
            title: Text("Stores"),
          ),
          CNavItem(
            icon: Icon(
              FontAwesomeIcons.camera,
              size: 25,
            ),
            title: Text("Scan"),
          ),
          CNavItem(
            icon: Icon(Icons.notifications),
            title: Text("Notifications"),
          ),
          CNavItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text("User"),
          ),
        ],
        currentIndex: ctl.pageIndex.value,
        onTap: (index) => ctl.setPage(index),
      );
    });
  }

  int _switchPage(int index) {
    return index;
  }
}
