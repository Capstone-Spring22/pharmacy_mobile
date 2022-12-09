import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/screens/nav_hub/nav_bar_hub.dart';
import 'package:pharmacy_mobile/screens/signin/signin.dart';
import 'package:pharmacy_mobile/screens/signup/signup.dart';

import 'screens/introduction/intro.dart';

void main() async {
  await GetStorage.init();
  setStatusBarColor();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

void setStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: themeLight,

          // darkTheme: themeDark,
          defaultTransition: Transition.cupertino,
          title: 'Pharmacy App',
          initialRoute: '/intro',
          getPages: [
            GetPage(name: '/intro', page: () => const IntroductionScreen()),
            GetPage(
              name: '/signin',
              page: () => const SignInScreen(),
            ),
            GetPage(
              name: '/signup',
              page: () => const SignUpScreen(),
            ),
            GetPage(
              name: '/navhub',
              page: () => const NavBarHub(),
            ),
          ],
        );
      },
    );
  }
}
