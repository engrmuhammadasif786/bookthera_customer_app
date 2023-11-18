import 'dart:io';

import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/custom_textfields.dart';
import '../../../utils/resources/Colors.dart';
import '../../provider/book_session/book_session_provider.dart';
import '../../provider/widgets/sessions_button.dart';

class EditSession extends StatefulWidget {
  EditSession(
      {super.key,
      this.intensions='',
      this.sesstionType = SesstionType.Video});

  SesstionType sesstionType;
  String intensions='';
  
  @override
  State<EditSession> createState() => _EditSessionState();
}

class _EditSessionState extends State<EditSession> {
  TextEditingController intensionsController=TextEditingController();
  @override
  void initState() {
    super.initState();
    intensionsController.text=widget.intensions;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
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
      child: Padding(
         padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: getPadding(bottom: 11.0, top: 32),
                  child: Text('Session Intentions *',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(14),
                          color: textColorPrimary)),
                ),
                CustomTextField(
                  textEditingController: intensionsController,
                  maxLines: 8,
                  hint: 'Write text here...',
                  label: '',
                  onChanged: (value) {
                    widget.intensions=value;
                  },
                ),
                Padding(
                  padding: getPadding(top: 8),
                  child: Text('Session Type',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(14),
                          color: textColorPrimary)),
                ),
                Padding(
                  padding: getPadding(top: 13.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SessionButton(
                              color: widget.sesstionType == SesstionType.Video
                                  ? colorPrimary
                                  : null,
                              isOutlined:
                                  widget.sesstionType != SesstionType.Video,
                              outlinedBorderColor:
                                  widget.sesstionType != SesstionType.Video
                                      ? colorPrimary
                                      : borderColor,
                              title: 'Video',
                              onPressed: () {
                                setState(() {
                                  widget.sesstionType = SesstionType.Video;
                                });
                              })),
                      SizedBox(
                        width: 11,
                      ),
                      Expanded(
                          child: SessionButton(
                              color: widget.sesstionType == SesstionType.Audio
                                  ? colorPrimary
                                  : null,
                              isOutlined:
                                  widget.sesstionType != SesstionType.Audio,
                              outlinedBorderColor:
                                  widget.sesstionType != SesstionType.Audio
                                      ? colorPrimary
                                      : borderColor,
                              title: 'Call Only',
                              onPressed: () {
                                setState(() {
                                  widget.sesstionType = SesstionType.Audio;
                                });
                              })),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
                    child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                            borderRadius: 10,
                            title: 'Save changes',
                            onPressed: () {
                              Map body={};
                              body['intensions']=widget.intensions;
                              body['type']=widget.sesstionType==SesstionType.Video?'video':'audio';
                              Navigator.of(context).pop(body);
                            })),
                  ),
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
        ),
      ),
    );
  }
}
