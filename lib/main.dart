import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';
import 'package:pharmacy_mobile/screens/signin/signin.dart';
import 'package:pharmacy_mobile/screens/signup/signup.dart';

import 'screens/introduction/intro.dart';

void main() => runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(), // Wrap your app
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: themeLight,
          darkTheme: themeDark,
          title: 'Pharmacy App',
          initialRoute: '/intro',
          getPages: [
            GetPage(name: '/intro', page: () => const IntroductionScreen()),
            GetPage(
              name: '/signin',
              page: () => const SignInScreen(),
              transition: Transition.cupertino,
            ),
            GetPage(
              name: '/signup',
              page: () => const SignUpScreen(),
              transition: Transition.cupertino,
            ),
          ],
          home: child,
        );
      },
      child: const IntroductionScreen(),
    );
  }
}
