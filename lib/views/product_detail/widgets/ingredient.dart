import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/models/ingredients.dart';

class IngredientsText extends StatelessWidget {
  const IngredientsText({super.key, required this.ingre});

  final List<IngredientModel> ingre;

  @override
  Widget build(BuildContext context) {
    // return AutoSizeText(
    //   "${ingre.ingredientName} ($contentString ${ingre.unitName})",
    //   style: const TextStyle(color: Colors.blue),
    // );
    String text = "";
    for (var element in ingre) {
      String contentString = element.content.toString();
      if (contentString.endsWith(".0")) {
        contentString = contentString.substring(0, contentString.length - 2);
      }
      text +=
          "${element.ingredientName} ($contentString ${element.unitName}), ";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
            const AutoSizeText(
              "Thành Phần:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            AutoSizeText(
              text,
              style:
                  context.textTheme.titleMedium!.copyWith(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
