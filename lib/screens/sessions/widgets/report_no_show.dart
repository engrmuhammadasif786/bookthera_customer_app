import 'dart:io';

import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/screens/home/dashboard.dart';
import 'package:bookthera_customer/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/resources/Colors.dart';

class ReportNoShow extends StatelessWidget {
  const ReportNoShow({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(14),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  color: Colors.black.withOpacity(0.1))
            ]),
        child: Report(size: size),
      ),
    );
  }
}

class Report extends StatelessWidget {
  const Report({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/icons/ic_report.png'),
            ),
            Text(
              'Report No Show',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
            ),
            Text(
              '04:54',
              style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
              child: SizedBox(
                  width: size.width * 0.5,
                  child: CustomButton(
                      borderRadius: 10,
                      title: 'Report',
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => ReportSuccess(
                                  size: size,
                                ));
                      })),
            )
          ],
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.cancel_outlined,
              color: errorColor,
            ))
      ],
    );
  }
}

class ReportSuccess extends StatelessWidget {
  const ReportSuccess({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(14),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  color: Colors.black.withOpacity(0.1))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset(
                'assets/icons/ic_check.png',
                height: 124,
                width: 124,
                color: colorPrimary,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Reported No Show',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                )),
            Text(
              'Provider has been reported as No Show.\nPayment has been refunded and should appear\nin 5-7 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
              child: SizedBox(
                  width: size.width * 0.5,
                  child: CustomButton(
                      color: colorAccent,
                      borderRadius: 10,
                      title: 'Got It',
                      onPressed: () {
                        pushAndRemoveUntil(context, Dashboard(), false);
                      })),
            )
          ],
        ),
      ),
    );
  }
}
