import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/neumorphic_iconbutton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    box.write("isFirst", false);
    return SafeArea(
      child: Scaffold(
        appBar: PharmacyAppBar(
          leftWidget: NeumorphicIconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            fn: () => print("he"),
          ),
          midText: "Home Screen",
          rightWidget: NeumorphicIconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            // fn: () => Get.to(const QrScannerWidget()),
            fn: () => Get.toNamed('/intro'),
          ),
          titleStyle:
              context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
        ),
      ),
    );
  }
}
