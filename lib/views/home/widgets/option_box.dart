import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/constrains/theme.dart';

class OptionBox extends StatelessWidget {
  const OptionBox(
      {super.key,
      required this.color,
      required this.Iconcolor,
      required this.icon,
      required this.text,
      required this.func});

  final Color color;
  final Color Iconcolor;
  final IconData icon;
  final String text;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      style: NeumorphicStyle(
        color: color,
        lightSource: LightSource.top,
      ),
      onPressed: func,
      child: SizedBox(
        // color: color,
        // width: 90.w,
        height: Get.height * .1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: Iconcolor,
              size: Get.height * .06,
            ),
            Expanded(
              child: AutoSizeText(
                text,
                maxLines: 1,
                style: detailPrice.copyWith(
                  fontSize: 18,
                  color: context.theme.primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
