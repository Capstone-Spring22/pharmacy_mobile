import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

class PharmacyAppBar extends StatelessWidget implements PreferredSizeWidget {
  PharmacyAppBar(
      {super.key,
      required this.leftWidget,
      required this.midText,
      required this.rightWidget,
      this.titleStyle});
  final Widget leftWidget;
  final String midText;
  final Widget rightWidget;
  TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          leftWidget,
          Expanded(
            child: AutoSizeText(
              textAlign: TextAlign.center,
              midText,
              maxLines: 1,
              style: titleStyle ?? context.textTheme.headlineMedium,
            ),
          ),
          rightWidget
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.h);
}
