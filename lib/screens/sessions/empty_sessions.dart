import 'package:bookthera_provider/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class EmptySessions extends StatelessWidget {
  const EmptySessions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Image.asset('assets/icons/ic_empty.png'),
        ),
        Text(
          'Your session can be accessed on the\nsessions tab',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColorPrimary,
              fontWeight: FontWeight.w400,
              fontSize: 18.0),
        )
      ],
    );
  }
}