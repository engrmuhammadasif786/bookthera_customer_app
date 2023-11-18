import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
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
  Widget? prefixWidget;


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
      this.prefixWidget,
      this.textInputType = TextInputType.text,
      this.fillColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(getSize(5.89)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 11.77,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
      child: TextField(
        controller: textEditingController,
        obscureText: isSecure,
        showCursor: showCurser,
        readOnly: readOnly,
        autofocus: autofocus,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        // textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
              fontSize: getFontSize(15),
              fontWeight: FontWeight.w400,
              color: Colors.black54),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefix: Padding(
            padding: getPadding(right: 8),
            child: prefixWidget,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.025),
              borderSide: BorderSide(color: Colors.grey)),
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.width * 0.025),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.width * 0.025),
            borderSide: const BorderSide(color: Colors.grey, width: 0),
          ),
          contentPadding: contentPadding,
          filled: true,
          hintText: hint,
          labelText:label?? hint,
          hintStyle: TextStyle(
              fontSize: getFontSize(13),
              fontWeight: FontWeight.w400,
              color: Colors.black54),
        ),
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }
}
