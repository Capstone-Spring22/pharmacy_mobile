import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_mobile/constrains/text.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/controllers/chat_controller.dart';
import 'package:pharmacy_mobile/controllers/notification_controller.dart';
import 'package:pharmacy_mobile/controllers/product_controller.dart';
import 'package:pharmacy_mobile/debug/screen.dart';
import 'package:pharmacy_mobile/firebase_options.dart';
import 'package:pharmacy_mobile/views/address/address.dart';
import 'package:pharmacy_mobile/views/alarm/alarm_picker.dart';
import 'package:pharmacy_mobile/views/browse_products/browse_product.dart';
import 'package:pharmacy_mobile/views/chat/chat.dart';
import 'package:pharmacy_mobile/views/checkout/checkout.dart';
import 'package:pharmacy_mobile/views/error/error.dart';
import 'package:pharmacy_mobile/views/nav_hub/nav_bar_hub.dart';
import 'package:pharmacy_mobile/views/product_detail/product_detail.dart';
import 'package:pharmacy_mobile/views/setting/setting.dart';
import 'package:pharmacy_mobile/views/signin/signin.dart';
import 'package:pharmacy_mobile/views/signup/signup.dart';
import 'package:pharmacy_mobile/views/user/user.dart';

import 'controllers/user_controller.dart';
import 'views/introduction/intro.dart';
import 'views/message/message.dart';
import 'views/order_detail/order_detail.dart';
import 'views/order_history/order.dart';
import 'views/order_success/order_success.dart';
import 'views/vnpay/vnpay.dart';

extension PriceConvert on num {
  String convertCurrentcy() {
    return NumberFormat.currency(locale: 'vi', symbol: 'đ').format(this);
  }
}

extension DateToDateFormat on DateTime {
  String get convertToDate {
    return DateFormat.yMMMMd('vi_VN').format(this);
  }
}

extension DateFormatter on String {
  String get convertToDate {
    return DateFormat.yMMMMd('vi_VN').format(DateTime.parse(this));
  }

  String get convertToOriginalPhone {
    return replaceFirst("+84", "0");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return ErrorScreen(errorDetails: errorDetails);
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  await GetStorage.init();
  FirebaseFirestore.instance.settings.persistenceEnabled;
  await AndroidAlarmManager.initialize();
  await dotenv.load(fileName: "dotenv");
  await initializeDateFormatting('vi_VN', null);

  //init app controller
  initController();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.white, // status bar color
    statusBarIconBrightness: Brightness.dark,
  ));

  // FlutterError.onError = (FlutterErrorDetails details) {
  //   List<String> errorList = [
  //     'There are multiple heroes that share the same tag within a subtree',
  //     'Invalid argument(s): No host specified in URI 123',
  //     'EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE',
  //   ];

  //   if (details.exception is FlutterError &&
  //       errorList.any((e) => details.exception.toString().contains(e))) {
  //     // Do nothing to hide the exception
  //   } else {
  //     // Print the exception to the console
  //     Get.log(
  //         'Error: ${errorList.any((e) => details.exception.toString().contains(e))}');
  //     FlutterError.dumpErrorToConsole(details);
  //   }
  // };

  runApp(const MyApp());
}

void initController() {
  Get.put(AppController());
  Get.put(UserController());
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(NotificationController());
  Get.put(AddressController());
  Get.put(ChatController());

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
          locale: const Locale('vn', 'VN'),
          defaultTransition: Transition.cupertino,
          title: 'Better Health',
          initialRoute: '/intro',
          unknownRoute: GetPage(
            name: '/navhub',
            page: () => const NavBarHub(),
          ),
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
              name: '/order_detail',
              page: () => const OrderDetail(),
            ),
            GetPage(
              name: '/browse_product',
              page: () => const BrowseProductScreen(),
            ),
            GetPage(
              name: '/order_history',
              page: () => const OrderScreen(),
            ),
            GetPage(
              name: '/chat',
              page: () => const ChatScreen(),
            ),
            GetPage(
              name: '/message',
              page: () => const MessageScreen(),
            ),
            GetPage(
              name: '/user',
              page: () => const UserScreen(),
            ),
            GetPage(
              name: '/product_detail',
              preventDuplicates: false,
              page: () => const ProductDetailScreen(),
            ),
            GetPage(
              name: '/address',
              page: () {
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
              name: '/order_success',
              page: () => const OrderSuccessScreen(),
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
              name: '/vnpay',
              page: () => const VNPayScreen(),
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
