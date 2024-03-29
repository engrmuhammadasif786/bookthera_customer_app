import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class SessionButton extends StatelessWidget {
  final String title;
  final Color titletxtColor;
  Color? color;
  Color outlinedBorderColor;
  double width;
  void Function()? onPressed;
  bool isOutlined;
  SessionButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.titletxtColor = Colors.white,
    this.isOutlined=false,
    this.outlinedBorderColor=borderColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isOutlined?Colors.white: color??colorAccent,
        onPrimary: isOutlined?Colors.white: color??colorAccent,
        padding: getPadding(top: 12, bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(8)),
          side: BorderSide(
            width: 1,
            color:  isOutlined?outlinedBorderColor: Colors.transparent,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontSize: getFontSize(13), fontWeight: FontWeight.w600, color:isOutlined?outlinedBorderColor: titletxtColor),
      ),
      onPressed: onPressed,
    );
  }
}
