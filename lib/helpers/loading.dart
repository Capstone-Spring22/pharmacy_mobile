// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({this.size = 30, this.color, super.key});
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.dotsTriangle(
        color: color ?? context.theme.primaryColor, size: size);
  }
}
