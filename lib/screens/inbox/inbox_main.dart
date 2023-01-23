import 'package:bookthera_customer/models/MessageModel.dart';
import 'package:bookthera_customer/screens/inbox/chat_provider.dart';
import 'package:bookthera_customer/screens/provider/widgets/search_field.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/helper.dart' as hp;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../utils/resources/Colors.dart';
import 'chat_screen.dart';

class InboxMain extends StatefulWidget {
  const InboxMain({super.key});

  @override
  State<InboxMain> createState() => _InboxMainState();
}

class _InboxMainState extends State<InboxMain> {
  List<MessageModel> messageList = [];
  String q='';
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatProvider>().doCallGetMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: true);
    onSearch(q);
    return CustomLoader(
      isLoading: chatProvider.isLoading,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: CustomSearchField(
              isShowFavourite: false,
              isFilter: false,
              onChanged: (value){
                setState(() {
                  q=value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: messageList.length,
                itemBuilder: (context, index) =>
                    inboxCell(context, messageList[index])),
          )
        ],
      ),
    );
  }

  inboxCell(BuildContext context, MessageModel messageModel) {
    var senderId = '';
    var senderUname = '';
    dynamic senderProfile = AssetImage("assets/images/placeholder.jpg");
    var lastmessage = '';
    var sentTime = '';
    Widget doneStatus = Container();
    lastmessage = messageModel.message!;
    sentTime = hp.setLastSeen(messageModel.sentAt!.millisecondsSinceEpoch);
    if (messageModel.senderId == getStringAsync(USER_ID)) {
      senderId = messageModel.receiverId!;
      senderUname = messageModel.receiver!.uname!;
      if (messageModel.receiver!.avatar!.url!.isNotEmpty) {
        senderProfile = NetworkImage(messageModel.receiver!.avatar!.url!);
      }
      if (messageModel.seen!) {
        doneStatus = Icon(
          Icons.done_all,
          size: 16,
          color: colorPrimary,
        );
      } else if (messageModel.delivered!) {
        doneStatus = Icon(
          Icons.done_all,
          size: 16,
        );
      } else {
        doneStatus = Icon(
          Icons.done,
          size: 16,
        );
      }
    } else {
      senderId = messageModel.senderId!;
      senderUname = messageModel.sender!.uname!;
      if (messageModel.sender!.avatar!.url!.isNotEmpty) {
        senderProfile = NetworkImage(messageModel.sender!.avatar!.url!);
      }
    }

    return GestureDetector(
      onTap: () {
        hp.push(
            context,
            ChatScreen(
              senderId: senderId,
              senderName: senderUname,
            ));
      },
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.only(bottom: 13),
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
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 13),
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    height: 65,
                    width: 65,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: senderProfile)),
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        color: messageModel.isUserOnline
                            ? onlineStatus
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          senderUname,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        sentTime,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: borderColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastmessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: !messageModel.seen!
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              color: !messageModel.seen!
                                  ? Colors.black
                                  : borderColor),
                        ),
                      ),
                      doneStatus
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSearch(String query) {
    messageList.clear();
    context.read<ChatProvider>().messagesList.forEach((element) {
      String senderFname = '';
      String senderLname = '';
      String senderUname = '';
      if (element.senderId == getStringAsync(USER_ID)) {
        senderFname = element.receiver!.fname!;
        senderLname = element.receiver!.lname!;
        senderUname = element.receiver!.uname!;
      } else {
        senderFname = element.sender!.fname!;
        senderLname = element.sender!.lname!;
        senderUname = element.sender!.uname!;
      }
      print({senderFname, senderLname, senderUname, query});
      if ((senderFname.contains(query) ||
          senderLname.contains(query) ||
          senderUname.contains(query)) && element.bugSuggestionType=='normal') {
        messageList.add(element);
      }
    });
    setState(() {});
  }
}
