import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharmacy_mobile/controllers/app_controller.dart';

class RoundedSearchInput extends GetView<AppController> {
  final TextEditingController textController;
  final String hintText;
  final Color color;
  final bool enable;
  const RoundedSearchInput(
      {required this.textController,
      required this.hintText,
      Key? key,
      required this.color,
      required this.enable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode fcNode = FocusNode();
    if (enable) {
      fcNode.requestFocus();
    }
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1)),
      ]),
      child: TextField(
        focusNode: fcNode,
        enabled: enable,
        controller: textController,
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500]!,
          ),
          suffixIcon: enable
              ? IconButton(
                  onPressed: () => textController.text = "",
                  icon: const Icon(Icons.clear),
                  color: textController.text.isEmpty
                      ? Colors.grey[500]!
                      : Colors.red,
                )
              : null,
          filled: true,
          fillColor: color,
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(45.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(45.0)),
          ),
        ),
      ),
    );
  }
}
