import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key, required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: color,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            title: AutoSizeText(
              text,
              maxLines: 1,
              style: context.textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}
