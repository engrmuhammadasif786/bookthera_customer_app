import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';


class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      required this.controller,
      this.hintText,
      this.obscureText=false,
      this.suffixIcon,
      this.maxLines=1,
      this.contentPadding,
      this.inputFormatters,
      this.label,
      this.isEditable=true,
      this.autofocus=false,
      this.focusNode,
      this.prefixWidget,
      this.validator,this.prefixIcon,this.onSaved,this.keyboardType=TextInputType.text});
  String? Function(String?)? validator;
  TextEditingController controller;
  String? hintText;
  String? label;
  Widget? prefixIcon;
  Widget? suffixIcon;
  TextInputType keyboardType;
  bool obscureText;
  int maxLines;
  EdgeInsets? contentPadding;
  void Function(String?)? onSaved;
  List<TextInputFormatter>? inputFormatters;
  bool isEditable;
  FocusNode? focusNode;
  bool autofocus;
  Widget? prefixWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getMargin(top: 16.0, right: 8.0, left: 8.0),
      decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(getSize(5.89)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 11.77,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
      child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.next,
          validator: validator,
          controller: controller,
          onChanged: onSaved,
          autofocus: autofocus,
          style: TextStyle(
            fontSize: getFontSize(16),fontWeight: FontWeight.w500, color: Color(0xff989898)),
          keyboardType: keyboardType,
          cursorColor: colorPrimary,
          obscureText: obscureText,
          obscuringCharacter: '*',
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          showCursor: isEditable,
          readOnly: !isEditable,
          enableInteractiveSelection: isEditable,
          focusNode: focusNode,
          decoration: InputDecoration(
            prefix: Padding(
              padding: getPadding(right: 8),
              child: prefixWidget,
            ),
            // floatingLabelBehavior: FloatingLabelBehavior.always,
            // alignLabelWithHint: false,
            contentPadding:contentPadding??getPadding(all: 16),
            hintText:  hintText,
            labelText:label?? hintText,
            // labelStyle: TextStyle(color: Colors.white),
            // hintStyle: TextStyle(color: Colors.white),
            floatingLabelStyle: TextStyle(color: colorPrimary),
            prefixIcon:prefixIcon,
            suffixIcon: suffixIcon,
            prefixIconConstraints: BoxConstraints(maxWidth: getSize(48)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(size.width * 0.025),
              borderSide: BorderSide(color: colorPrimary)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.width * 0.025),
            borderSide: const BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.width * 0.025),
            borderSide: const BorderSide(color: Colors.grey, width: 0),
          ),
          )),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}