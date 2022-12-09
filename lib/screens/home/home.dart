import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pharmacy_mobile/screens/home/widgets/option_box.dart';
import 'package:pharmacy_mobile/screens/home/widgets/search.dart';
import 'package:pharmacy_mobile/widgets/appbar.dart';
import 'package:pharmacy_mobile/widgets/scroll_behavior.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    box.write("isFirst", false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFCFF),
        appBar: PharmacyAppBar(
          leftWidget: NeumorphicButton(
            style: const NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              color: Colors.white,
              shape: NeumorphicShape.flat,
            ),
            onPressed: () {},
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          midText: "Home Screen",
          rightWidget: NeumorphicButton(
            style: const NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
              color: Colors.white,
              shape: NeumorphicShape.flat,
            ),
            onPressed: () {},
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
          ),
          titleStyle:
              context.textTheme.headlineMedium!.copyWith(fontSize: 30.h),
        ),
        body: ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: AutoSizeText(
                      "Place your order select \npharmacy recive it",
                      style: TextStyle(
                        fontSize: 24.h,
                        color: Colors.black.withOpacity(.8),
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: RoundedSearchInput(
                      hintText: "Type here to search",
                      textController: TextEditingController(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OptionBox(
                          color: Colors.blue[100]!.withOpacity(.5),
                          image: "assets/images/Pill.png",
                          text: "Claim and prescription",
                        ),
                        OptionBox(
                          color: Colors.yellow[100]!.withOpacity(1),
                          image: "assets/images/Image.png",
                          text: "Product picture",
                        ),
                        OptionBox(
                          color: Colors.green[100]!.withOpacity(.7),
                          image: "assets/images/UserFocus.png",
                          text: "Pharmacist assistant",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
