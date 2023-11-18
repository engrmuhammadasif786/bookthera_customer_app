import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';


class CustomTextFormFieldUp extends StatelessWidget {
  CustomTextFormFieldUp(
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
      this.focusNode,
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
          style: TextStyle(fontSize: getFontSize(16),fontWeight: FontWeight.w500, color: Color(0xff989898)),
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
            floatingLabelAlignment: FloatingLabelAlignment.start,
            contentPadding:contentPadding?? getPadding(left: 16, right: 16),
            hintText:  hintText,
            labelText:label?? hintText,
            // labelStyle: TextStyle(color: Colors.white),
            // hintStyle: TextStyle(color: Colors.white),
            floatingLabelStyle: TextStyle(color: colorPrimary),
            prefixIcon:prefixIcon,
            suffixIcon: suffixIcon,
            prefixIconConstraints: BoxConstraints(minWidth: getSize(48)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide:
                    BorderSide(color: colorPrimary, width: 2.0)),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).errorColor),
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(5.0),
            ),
          )),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}