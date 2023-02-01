import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';


class PhoneTextFormField extends StatelessWidget {
  PhoneTextFormField(
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
      this.onCountryChanged,
      this.validator,this.prefixIcon,this.onSaved,this.keyboardType=TextInputType.text});
  String? Function(PhoneNumber?)? validator;
  TextEditingController controller;
  String? hintText;
  String? label;
  Widget? prefixIcon;
  Widget? suffixIcon;
  TextInputType keyboardType;
  bool obscureText;
  int maxLines;
  EdgeInsets? contentPadding;
  void Function(PhoneNumber?)? onSaved;
  List<TextInputFormatter>? inputFormatters;
  bool isEditable;
  FocusNode? focusNode;
  void Function(Country)? onCountryChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
      child: IntlPhoneField(
        // showCountryFlag: false,
        // dropdownIcon: Icon(
        //     Icons.smartphone,
        //     color: Colors.grey,
        //     size: 16,
        //   ),
        onCountryChanged: onCountryChanged,
        disableLengthCheck: true,
        showDropdownIcon: false,
        flagsButtonPadding: EdgeInsets.only(left: 16),
        pickerDialogStyle: PickerDialogStyle(
          backgroundColor: Colors.white,
          countryNameStyle: TextStyle(fontWeight: FontWeight.w500),
          countryCodeStyle: TextStyle(fontWeight: FontWeight.w500)
        ),
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.next,
          validator: validator,
          controller: controller,
          onChanged: onSaved,
          // style: TextStyle(fontSize: 18.0, color: Colors.black),
          keyboardType: keyboardType,
          cursorColor: colorPrimary,
          obscureText: obscureText,
          inputFormatters: [],
          showCursor: isEditable,
          readOnly: !isEditable,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding:contentPadding?? EdgeInsets.only(left: 16, right: 16),
            hintText:  hintText,
            labelText:label?? hintText,
            // labelStyle: TextStyle(color: Colors.white),
            // hintStyle: TextStyle(color: Colors.white),
            floatingLabelStyle: TextStyle(color: colorPrimary),
            prefixIcon:prefixIcon,
            suffixIcon: suffixIcon,
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