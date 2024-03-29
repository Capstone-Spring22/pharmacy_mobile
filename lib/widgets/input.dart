import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Input extends StatelessWidget {
  final TextEditingController inputController;
  final String? title;
  final Function(String)? onChanged;
  final FocusNode? focus;
  final TextInputType? inputType;
  final bool enabled;
  final String? hint;
  final Function(String)? onSubmit;
  final bool centerText;
  final bool readOnly;
  final TextInputAction? inputAction;
  final int? maxLines;
  final bool isFormField;
  final String? Function(String?)? validator;
  final double? horiPadding;
  const Input(
      {Key? key,
      required this.inputController,
      this.title,
      this.onChanged,
      this.focus,
      this.inputType,
      this.enabled = true,
      this.hint,
      this.validator,
      this.isFormField = false,
      this.inputAction,
      this.horiPadding,
      this.maxLines = 1,
      this.centerText = false,
      this.readOnly = false,
      this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horiPadding ?? 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            height: isFormField ? 70 : 50,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
            child: isFormField
                ? TextFormField(
                    textInputAction: inputAction,
                    focusNode: focus,
                    enabled: enabled,
                    textAlign: centerText ? TextAlign.center : TextAlign.left,
                    validator: validator,
                    controller: inputController,
                    onChanged: onChanged,
                    keyboardType: inputType ?? TextInputType.text,
                    style: context.textTheme.bodyLarge,
                    expands: maxLines == null,
                    readOnly: readOnly,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      label: title != null ? Text(title!) : null,
                      labelStyle: context.textTheme.bodyLarge,
                      filled: true,
                      hintText: hint,
                      hintStyle: context.textTheme.labelMedium,
                      fillColor: context.theme.secondaryHeaderColor,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.primaryColor, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.primaryColor, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.error,
                          width: 1.0,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.secondaryHeaderColor,
                            width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  )
                : TextField(
                    textInputAction: inputAction,
                    focusNode: focus,
                    enabled: enabled,
                    textAlign: centerText ? TextAlign.center : TextAlign.left,
                    onSubmitted: onSubmit,
                    controller: inputController,
                    onChanged: onChanged,
                    keyboardType: inputType ?? TextInputType.text,
                    style: context.textTheme.bodyLarge,
                    expands: maxLines == null,
                    readOnly: readOnly,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      label: title != null ? Text(title!) : null,
                      labelStyle: context.textTheme.bodyLarge,
                      filled: true,
                      hintText: hint,
                      hintStyle: context.textTheme.labelMedium,
                      fillColor: context.theme.secondaryHeaderColor,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.primaryColor, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.primaryColor, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.colorScheme.error, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: context.theme.secondaryHeaderColor,
                            width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
