import 'package:bookthera_customer_1/components/custom_readmore.dart';
import 'package:bookthera_customer_1/models/Provider.dart';
import 'package:bookthera_customer_1/models/session_model.dart';
import 'package:bookthera_customer_1/screens/inbox/chat_screen.dart';
import 'package:bookthera_customer_1/screens/provider/book_session/book_session_main.dart';
import 'package:bookthera_customer_1/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer_1/screens/provider/provider_detail.dart';
import 'package:bookthera_customer_1/screens/provider/widgets/sessions_button.dart';
import 'package:bookthera_customer_1/utils/resources/Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../utils/helper.dart';

class SessionTabCell extends StatelessWidget {
  const SessionTabCell({super.key,required this.sesssionModel,this.venderName='',this.providerId=''});
  final SesssionModel sesssionModel;
  final String venderName;
  final String providerId;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    var isPromotion = sesssionModel.isPromotion;
    var name = sesssionModel.name;
    var description = sesssionModel.description;
    var isAudio = sesssionModel.isAudio;
    var isVideo = sesssionModel.isVideo;
    var isChat = sesssionModel.isChat;
    var isBook = sesssionModel.isBook;
    var price = sesssionModel.price.toStringAsFixed(2);
    var length = sesssionModel.length;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              isDarkMode(context)
                  ? BoxShadow()
                  : BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10.0,
                      spreadRadius: 2,
                      offset: Offset(1, 1),
                    ),
            ],
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isPromotion)
            Container(
              width: 87,
              height: 27,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/icons/promotion_bar.png'))
              ),
              alignment: Alignment.center,
              child: Text('Promotion',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(venderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    )),
                Spacer(),
                Text('\$$price',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorPrimary,
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(isVideo=='true')
                  Icon(
                    Icons.videocam,
                    size: 20,
                    color: colorPrimary,
                  ),
                  SizedBox(width: 3),
                  if(isAudio=='true')
                  Icon(
                    Icons.mic,
                    size: 20,
                    color: colorPrimary,
                  ),
                  Spacer(),
                  Text(
                    "$length minutes",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: colorPrimary,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
            CustomReadmore(text: description!),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  if(isChat=='true')
                  Expanded(child: SessionButton(
                    isOutlined: true,
                    title: 'Chat Now', onPressed: (){
                      push(context, ChatScreen(senderId: providerId, senderName: venderName));
                    })),
                    if(isChat=='true')
                  SizedBox(width: 11,),
                  if(isBook=='true')
                  Expanded(child: SessionButton(title: 'Book Appointment', onPressed: (){
                    
                    context.read<BookSesstionProvider>().selectedSesssion=sesssionModel;
                    context.read<BookSesstionProvider>().providerId=providerId;
                    push(context, BookSessionMain(providerId:providerId ,));
                  })),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
