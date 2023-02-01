import 'package:flutter/material.dart';

import '../../../components/custom_button.dart';
import '../../../utils/resources/Colors.dart';

class SentSuccess extends StatelessWidget {
  const SentSuccess({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
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
                  'Message Sent!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0),
                )),
            Text(
              'Your message has been sent successfully!',
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
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      })),
            )
          ],
        ),
      ),
    );
  }
}