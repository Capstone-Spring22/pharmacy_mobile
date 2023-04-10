import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/controllers/cart_controller.dart';
import 'package:pharmacy_mobile/controllers/user_controller.dart';
import 'package:pharmacy_mobile/models/pharmacy_user.dart';
import 'package:pharmacy_mobile/views/camera/camera.dart';
import 'package:pharmacy_mobile/views/home/widgets/cart_btn.dart';
import 'package:pharmacy_mobile/views/home/widgets/drawer_btn.dart';
import 'package:pharmacy_mobile/views/home/widgets/option_row.dart';
import 'package:pharmacy_mobile/views/home/widgets/scroll_to_top.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
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
          expandedBody: const CameraScreen(),
          fullyStretchable: true,
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: DrawerButtonNoNeu(),
          ),
          appBarColor: const Color(0xFFFFFFFF),
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
          headerExpandedHeight: 0.5,
          title: Image.asset(
            'assets/icons/icon.png',
            height: Get.height * .07,
          ),
          headerWidget: headerWidget(context),
          body: const [ListItemBuilder()],
        ),
      ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PharmacyAppBar(
          leftWidget: const DrawerButton(),
          midText: "title".tr,
          rightWidget: const CartButton(),
          // titleStyle:
          //     context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
        ),
        GetBuilder<UserController>(
          builder: (userCtl) {
            String txt = "";
            if (userCtl.user == PharmacyUser().obs) {
              txt = setWelcomeText();
            } else {
              txt = "${setWelcomeText()}, ${userCtl.user.value.name}";
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                animatedTexts: [
                  TypewriterAnimatedText(
                    txt,
                    textStyle: context.textTheme.headlineSmall!.copyWith(
                      color: context.theme.primaryColor,
                    ),
                  )
                ],
              ),
            );
          },
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
