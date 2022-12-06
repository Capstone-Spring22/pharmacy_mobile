import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GenderSelect extends StatefulWidget {
  const GenderSelect({super.key, required this.isMale, required this.callback});
  final bool isMale;
  final Function(bool) callback;

  @override
  State<GenderSelect> createState() => _GenderSelectState();
}

class _GenderSelectState extends State<GenderSelect> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => widget.callback(true),
          child: Container(
            height: 100.w,
            width: 100.w,
            decoration: BoxDecoration(
              color: widget.isMale ? Colors.transparent : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: widget.isMale ? Colors.blue : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.male,
                  size: 50.w,
                  color: widget.isMale ? Colors.blue : Colors.black,
                ),
                Text(
                  "Male",
                  style: context.textTheme.labelLarge!.copyWith(
                    color: widget.isMale ? Colors.blue : Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => widget.callback(false),
          child: Container(
            height: 100.w,
            width: 100.w,
            decoration: BoxDecoration(
              color: widget.isMale ? Colors.grey[200] : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: widget.isMale ? Colors.transparent : Colors.pink),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.female,
                  size: 50.w,
                  color: widget.isMale ? Colors.black : Colors.pink,
                ),
                Text(
                  "Female",
                  style: context.textTheme.labelLarge!.copyWith(
                    color: widget.isMale ? Colors.black : Colors.pink,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
