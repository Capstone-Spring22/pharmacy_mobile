import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PharmacyButton extends StatelessWidget {
  const PharmacyButton(
      {super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: AutoSizeText(
        text,
        style: context.textTheme.labelLarge,
      ),
    );
  }
}
