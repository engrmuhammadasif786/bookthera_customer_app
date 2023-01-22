import 'package:bookthera_customer_1/utils/resources/Colors.dart';
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
  CustomButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.titletxtColor = Colors.white,
    this.borderRadius=25.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color?? colorPrimary,
        padding: EdgeInsets.only(top: 12, bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: color??colorPrimary,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.normal, color:titletxtColor),
      ),
      onPressed: onPressed,
    );
  }
}
