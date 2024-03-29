import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CustomReadmore extends StatelessWidget {
  const CustomReadmore({required this.text,this.color,this.fontWeight,this.fontsize,  super.key});
  final String text;
  final Color? color;
  final double? fontsize;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
        text,
        trimLines: 2,
        colorClickableText: colorPrimary,
        trimMode: TrimMode.Line,
        trimCollapsedText: ' See more',
        trimExpandedText: ' See less',
        style: TextStyle(
          fontWeight: fontWeight?? FontWeight.w400,
          color: color?? borderColor,
          fontSize:fontsize??  getFontSize(14),
        ),
        lessStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: colorPrimary,
          fontSize:getFontSize(14),
        ),
        moreStyle: TextStyle(
         fontWeight: FontWeight.w600,
          color: colorPrimary,
          fontSize:getFontSize(14),
        ));
  }
}
