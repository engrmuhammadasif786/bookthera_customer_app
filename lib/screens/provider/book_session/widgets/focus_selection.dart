import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../../utils/resources/Colors.dart';
import '../book_session_provider.dart';

class FocusSelection extends StatefulWidget {
  const FocusSelection({super.key});

  @override
  State<FocusSelection> createState() => _FocusSelectionState();
}

class _FocusSelectionState extends State<FocusSelection> {
  
  @override
  Widget build(BuildContext context) {
    BookSesstionProvider bookSesstionProvider =
        Provider.of<BookSesstionProvider>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 32,),
        Text('Topic',
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: getFontSize(18),
          color: textColorPrimary)),
        SizedBox(height: 19,),
        Wrap(
          runSpacing: 5,
          spacing: 5,
          children: bookSesstionProvider.foucsList.map((e) => GestureDetector(
            onTap: () {
              // setState(() {
              //   e.isSelected=!e.isSelected;
              // });
              context.read<BookSesstionProvider>().setSelectedFocus(e.sId!);
            },
            child: _focus(e.title!,isSelected: e.isSelected),
          )).toList())
      ],
    );
  }

  Widget _focus(String category,{bool isSelected=false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color:  isSelected?colorPrimary: Colors.white,
        border: Border.all(width: 2,color: colorPrimary)
      ),
      child: Text(
            '$category',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500,
          fontSize: getFontSize(15),
          color: !isSelected?colorPrimary: Colors.white),
          ),
    );
  }
}