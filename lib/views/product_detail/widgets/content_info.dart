import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentInfo extends StatelessWidget {
  const ContentInfo({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(color: context.theme.primaryColor),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0xfff6f5f8),
                spreadRadius: 10,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            AutoSizeText(content),
          ],
        ),
      ),
    );
  }
}
