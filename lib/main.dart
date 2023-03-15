import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/constrains/text.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/controllers/notification_controller.dart';
import 'package:pharmacy_mobile/controllers/product_controller.dart';
import 'package:pharmacy_mobile/debug/screen.dart';
import 'package:pharmacy_mobile/firebase_options.dart';
import 'package:pharmacy_mobile/screens/address/address.dart';
import 'package:pharmacy_mobile/screens/alarm/alarm_picker.dart';
import 'package:pharmacy_mobile/screens/checkout/checkout.dart';
import 'package:pharmacy_mobile/screens/nav_hub/nav_bar_hub.dart';
import 'package:pharmacy_mobile/screens/setting/setting.dart';
import 'package:pharmacy_mobile/screens/signin/signin.dart';
import 'package:pharmacy_mobile/screens/signup/signup.dart';

import 'controllers/user_controller.dart';
import 'screens/introduction/intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await AndroidAlarmManager.initialize();
  await dotenv.load(fileName: "dotenv");

  //init app controller
  initController();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

void initController() {
  Get.put(AppController());
  Get.put(UserController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(NotificationController());

  //TODO: remove debug controller
  // Get.put(MyController());
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
          // theme: themeLight,
          // darkTheme: themeDark,
          theme: FlexThemeData.light(
            useMaterial3: true,
            scheme: FlexScheme.aquaBlue,
          ),
          translations: ApplicationText(),
          locale: const Locale('en', 'US'),
          defaultTransition: Transition.cupertino,
          title: 'Pharmacy App',
          // initialRoute: '/demo',
          initialRoute: '/intro',
          getPages: [
            GetPage(name: '/intro', page: () => const IntroductionScreen()),
            GetPage(
              name: '/signin',
              page: () {
                Get.put(SignupController());
                return const SignInScreen();
              },
            ),
            GetPage(
              name: '/signup',
              page: () => const SignUpScreen(),
            ),
            GetPage(
              name: '/address',
              page: () {
                Get.put(AddressController());
                return const AddressSelectionScreen();
              },
            ),
            GetPage(
              name: '/checkout',
              page: () => const CheckoutScreen(),
            ),
            GetPage(
              name: '/navhub',
              page: () => const NavBarHub(),
            ),
            GetPage(
              name: '/setting',
              page: () => const SettingPage(),
            ),
            GetPage(
              name: '/demo',
              page: () => const DebugScreen(),
            ),
            GetPage(
              name: '/reminder_picker',
              page: () => const AlarmPicker(),
            ),
          ],
        );
      },
    );
  }
}
