import 'package:bookthera_customer_1/models/HomeConversationModel.dart';
import 'package:bookthera_customer_1/screens/inbox/chat_provider.dart';
import 'package:bookthera_customer_1/screens/inbox/chat_screen_view.dart';
import 'package:bookthera_customer_1/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../components/custom_appbar.dart';
import '../../utils/resources/Colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key,required this.senderId,required this.senderName});
  final String senderId;
  final String senderName;
  @override
  Widget build(BuildContext context) {
    String subTitle='';
    ChatProvider chatProvider=context.watch<ChatProvider>();
    if (chatProvider.isTyping) {
      subTitle='Typing...';
    }else if (chatProvider.isReceiverOnline){
      subTitle='Online';
    }else{
      if (chatProvider.lastSeen.isNotEmpty) {
        subTitle=setLastSeen(DateTime.parse(chatProvider.lastSeen).millisecondsSinceEpoch);
      }
    }

    return Scaffold(
      appBar: CustomAppbar(
        titleWidget: ListTile(
          
          subtitle: Text( subTitle,
          style: primaryTextStyle(
              color: textColorPrimary, size: 16, weight: FontWeight.w300)),
          title: Text(senderName,
          style: primaryTextStyle(
              color: textColorPrimary, size: 20, weight: FontWeight.w500)),
        ),
      ),
      body: ChatScreenView(senderId: senderId,),
    );
  }
}