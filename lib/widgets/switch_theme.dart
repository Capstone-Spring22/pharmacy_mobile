import 'package:flutter/material.dart';

class SwitchThemeButton extends StatefulWidget {
  const SwitchThemeButton({super.key});

  @override
  State<SwitchThemeButton> createState() => _SwitchThemeButtonState();
}

class _SwitchThemeButtonState extends State<SwitchThemeButton> {
  @override
  Widget build(BuildContext context) {
    // return IconButton(
    //   onPressed: () {
    //     Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    //   },
    //   icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
    // );
    return Container();
  }
}
