import 'package:bookthera_provider/utils/resources/Colors.dart';
import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
  final bool isSecure;
  final String hint;
  final String? label;
  final TextInputType textInputType;
  final bool showCurser;
  final bool readOnly;
  final Color fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool autofocus;
  final TextEditingController textEditingController;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChanged;
  TextInputAction? textInputAction;
  void Function(String)? onSubmitted;


  CustomTextField(
      {Key? key,
      required this.textEditingController,
      this.hint = '',
      this.textInputAction,
      this.onSubmitted,
      this.isSecure = false,
      this.showCurser = true,
      this.readOnly = false,
      this.prefixIcon,
      this.suffixIcon,
      this.autofocus = false,
      this.maxLines = 1,
      this.contentPadding,
      this.onChanged,
      this.label,
      this.textInputType = TextInputType.text,
      this.fillColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return TextField(
      controller: textEditingController,
      obscureText: isSecure,
      showCursor: showCurser,
      readOnly: readOnly,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.width * 0.025),
            borderSide: BorderSide(color: colorPrimary)),
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.025),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.025),
          borderSide: const BorderSide(color: Colors.grey, width: 0),
        ),
        contentPadding: contentPadding != null
            ? contentPadding!
            : EdgeInsets.symmetric(horizontal: size.width * 0.043,vertical: 12),
        filled: true,
        hintText: hint,
        // labelText:label?? hint,
        hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black54),
      ),
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }
}
