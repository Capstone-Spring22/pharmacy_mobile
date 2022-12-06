import 'package:flutter/material.dart';
import 'package:get/get.dart';

final primaryColor = Colors.black.withOpacity(0.6);
const secondaryColor = Color(0xff6D28D9);
const accentColor = Color(0xffffffff);
const backgroundColor = Color(0xffffffff);
const errorColor = Color(0xffEF4444);

class PasswordInput extends StatefulWidget {
  final String text;
  final TextEditingController textEditingController;

  const PasswordInput(
      {required this.textEditingController, required this.text, Key? key})
      : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool pwdVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
            child: TextFormField(
              style: context.textTheme.bodyMedium!
                  .copyWith(color: Colors.black.withOpacity(0.7)),
              controller: widget.textEditingController,
              obscureText: !pwdVisibility,
              decoration: InputDecoration(
                label: Text(widget.text),
                labelStyle: TextStyle(color: primaryColor),
                filled: true,
                fillColor: accentColor,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: secondaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: InkWell(
                  onTap: () => setState(
                    () => pwdVisibility = !pwdVisibility,
                  ),
                  child: Icon(
                    pwdVisibility
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey.shade400,
                    size: 18,
                  ),
                ),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  const TextInput(
      {Key? key,
      required this.inputController,
      required this.text,
      this.kbType = TextInputType.emailAddress})
      : super(key: key);
  final TextEditingController inputController;
  final String text;
  final TextInputType kbType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1)),
        ]),
        child: TextField(
          controller: inputController,
          onChanged: (value) {},
          keyboardType: kbType,
          style: context.textTheme.bodyMedium,
          decoration: InputDecoration(
            label: Text(text),
            labelStyle: TextStyle(color: primaryColor),
            filled: true,
            fillColor: accentColor,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: errorColor, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
      ),
    );
  }
}
