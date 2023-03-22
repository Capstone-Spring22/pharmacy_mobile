import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ContentInfo extends StatelessWidget {
  const ContentInfo({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        AutoSizeText(content),
      ],
    );
  }
}
