import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../../../utils/helper.dart';

class buildTitleRow extends StatelessWidget {
  final String titleValue;
  final Function? onClick;
  final bool? isViewAll;

  const buildTitleRow({
    Key? key,
    required this.titleValue,
    this.onClick,
    this.isViewAll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleValue,
                style: TextStyle(color: isDarkMode(context) ? Colors.white : Color(0xFF000000), fontFamily: "Poppinsm", fontSize: getFontSize(18))),
            isViewAll!
                ? Container()
                : GestureDetector(
                    onTap: () {
                      onClick!.call();
                    },
                    child: Text('see all >>', style: TextStyle(color: colorPrimary, fontFamily: "Poppinsm",fontSize: getFontSize(14),fontWeight: FontWeight.w600)),
                  ),
          ],
        ),
      ),
    );
  }
}