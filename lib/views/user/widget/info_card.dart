import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.theme.primaryColor),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: AutoSizeText(
            text,
            maxLines: 1,
            style: context.textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
