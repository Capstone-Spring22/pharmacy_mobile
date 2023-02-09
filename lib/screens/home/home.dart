import 'package:auto_size_text/auto_size_text.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/helpers/qr_scanner.dart';
import 'package:pharmacy_mobile/screens/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/screens/home/widgets/drawer_btn.dart';
import 'package:pharmacy_mobile/screens/home/widgets/option_row.dart';
import 'package:pharmacy_mobile/screens/home/widgets/scroll_to_top.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pharmacy_mobile/widgets/list_item_blr.dart';

import '../search/search_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    box.write("isFirst", false);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: ScrollToTop(
        child: DraggableHome(
          expandedBody: const QrScannerWidget(),
          fullyStretchable: true,
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: DrawerButtonNoNeu(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GetX<CartController>(builder: (cartCtrl) {
                return Badge(
                  isLabelVisible: cartCtrl.listCart.isNotEmpty,
                  label: Text(cartCtrl.listCart.length.toString()),
                  child: const CartButtonNoNeu(),
                );
              }),
            )
          ],
          // appBarColor: const Color(0xFFFAFCFF),
          // backgroundColor: const Color(0xFFFAFCFF),
          headerExpandedHeight: 0.5,
          title: AutoSizeText(
            "title".tr,
            maxLines: 1,
            style: context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
          ),
          headerWidget: headerWidget(context),

          body: const [ListItemBuilder()],
        ),
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    String welcomeText = setWelcomeText();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PharmacyAppBar(
          leftWidget: const DrawerButton(),
          midText: "title".tr,
          rightWidget: const CartButton(),
          titleStyle:
              context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: AnimatedTextKit(
            totalRepeatCount: 1,
            animatedTexts: [
              TypewriterAnimatedText(
                "$welcomeText, User",
                textStyle: context.textTheme.headlineSmall!,
              )
            ],
          ),
        ),
        const SearchScreen(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: OptionButtonRow(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_downward),
            Text(
              'scroll_down'.tr,
              style: context.textTheme.bodySmall,
            ),
          ],
        )
      ],
    );
  }

  String setWelcomeText() {
    final time = DateTime.now();
    if (time.hour >= 5 && time.hour <= 11) {
      return "welcome_morning".tr;
    } else if (time.hour > 11 && time.hour <= 16) {
      return "welcome_noon".tr;
    } else {
      return "welcome_night".tr;
    }
  }
}
