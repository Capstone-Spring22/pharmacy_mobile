import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OptionBox extends StatelessWidget {
  const OptionBox(
      {super.key,
      required this.color,
      required this.image,
      required this.text,
      required this.func});

  final Color color;
  final String image;
  final String text;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      style: NeumorphicStyle(
        color: context.theme.canvasColor,
        lightSource: LightSource.top,
      ),
      onPressed: func,
      child: SizedBox(
        width: 90.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: color,
                  child: Image.asset(image),
                ),
              ),
            ),
            AutoSizeText(
              text,
              maxLines: 2,
              style: const TextStyle(fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}
