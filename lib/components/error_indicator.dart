import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ErrorIndicator extends StatefulWidget {
  ErrorIndicator({super.key,required this.message,required this.onCancel});
  String message;
  void Function() onCancel;

  @override
  State<ErrorIndicator> createState() => _ErrorIndicatorState();
}

class _ErrorIndicatorState extends State<ErrorIndicator> {
  @override
  Widget build(BuildContext context) {
    return widget.message.isNotEmpty? Container(
      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 9),
      margin: EdgeInsets.only(left: 44,right: 44),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(2.53, 3.53),
            blurRadius: 4.71,
            color: Colors.black.withOpacity(0.1)
          )
        ],
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Icon(Icons.report_problem,color: colorPrimary,size: 16,),
          SizedBox(width: 8,),
          Expanded(child: Text(widget.message,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,color: colorPrimary),)),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.message='';
              });
              widget.onCancel();
            },
            child: Icon(Icons.clear,size: 16,))
        ],
      ),
    ):Container();
  }
}