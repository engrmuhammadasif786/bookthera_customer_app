import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/custom_textfields.dart';
import '../../../utils/resources/Colors.dart';
import '../../provider/widgets/sessions_button.dart';

TextEditingController cancelController = TextEditingController();

class SessionCancelSheet extends StatelessWidget {
  // const SessionCancelSheet({super.key});
  
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 11.0, top: 8),
              child: Row(
                children: [
                  GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                          'assets/images/arrow_back.png',
                          height: getSize(33),
                          width: getSize(33),
                          color: colorPrimary,
                        )),
                  Spacer(flex: 1,),
                  Text('Cancellation Reason',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(18),
                          color: textColorPrimary)),
                Spacer(flex: 2,),
                ],
              ),
            ),
            SizedBox(height: 8,),
            CustomTextField(
              textEditingController: cancelController,
              maxLines: 8,
              hint: 'Type why you want to cancel...',
            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: SessionButton(
                          color: colorPrimary, title: 'Clear', onPressed: () {
                            Navigator.of(context).pop();
                          })),
                  SizedBox(
                    width: 11,
                  ),
                  Expanded(
                      child: SessionButton(
                          isOutlined: true,
                          outlinedBorderColor: colorPrimary,
                          title: 'Confirm & Cancel',
                          onPressed: () {
                            if (cancelController.text.isEmpty) {
                              toast('Cancellation reason is required');
                            }else{
                              Navigator.of(context).pop({'status':'cancelled','cancellationReasion':cancelController.text});
                            }
                          })),
                ],
              ),
            ),
            ],
        ),
      ),
    );
  }
}
