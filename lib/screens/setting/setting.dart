import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        centerTitle: true,
      ),
      body: GetX<AppController>(
        builder: (ctl) => Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: ctl.isDarkMode.value
                      ? const Icon(
                          Icons.dark_mode,
                          color: Colors.black,
                        )
                      : const Icon(
                          Icons.light_mode,
                          color: Colors.white,
                        ),
                  title: const Text("Switch Theme"),
                  trailing: Switch(
                      value: ctl.isDarkMode.value,
                      onChanged: (v) {
                        ctl.isDarkMode.value = v;
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
