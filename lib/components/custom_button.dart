import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final String title;
  final Color titletxtColor;
  Color? color;
  double width;
  void Function()? onPressed;
  double borderRadius;
  bool isOutlined;
  CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.isOutlined=false,
    this.titletxtColor = Colors.white,
    this.borderRadius=25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isOutlined?OutlinedButton(
  style: OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(getSize(borderRadius)),
      side: BorderSide(
        color: color ?? colorPrimary,
      ),
    ),
  ),
  onPressed: onPressed,
  child: Text(
    title,
    style: TextStyle(
      fontSize: getFontSize(15),
      fontWeight: FontWeight.w500,
      color: color,
    ),
  ),
)
: ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color?? colorPrimary,
        padding: getPadding(top: 12, bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(getSize(borderRadius)),
          side: BorderSide(
            color: color??colorPrimary,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontSize: getFontSize(15), fontWeight: FontWeight.w500, color:titletxtColor),
      ),
      onPressed: onPressed,
    );
  }
}
