import 'package:bookthera_customer/screens/feedback/feedback_inbox.dart';
import 'package:bookthera_customer/screens/feedback/feedback_report.dart';
import 'package:bookthera_customer/screens/feedback/feedback_suggestion.dart';
import 'package:bookthera_customer/utils/helper.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import '../../utils/Constants.dart';
import '../inbox/chat_provider.dart';

class FeedbackMain extends StatelessWidget {
  List<FeedbackClass> feedbackList = [
    FeedbackClass(
        iconData: Icons.flag,
        title: 'Report a Bug',
        feedbackType: FeedbackType.report),
    FeedbackClass(
        iconData: Icons.description,
        title: 'Make a Suggestion',
        feedbackType: FeedbackType.suggestion),
    FeedbackClass(
        iconData: Icons.chat,
        title: 'View Messages',
        feedbackType: FeedbackType.message)
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int feedbackCount= context.watch<ChatProvider>().messagesList.where((element) => element.bugSuggestionType!='normal' && !element.seen! && element.senderId!=nb.getStringAsync(USER_ID)).length;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.2, vertical: 22),
              physics: NeverScrollableScrollPhysics(),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                if (feedbackCount>0) {
                  feedbackList[2].notificationCount=feedbackCount.toString();  
                }else{
                  feedbackList[2].notificationCount=null;
                }
                
                return GestureDetector(
                    onTap: () {
                      if (feedbackList[index].feedbackType ==
                          FeedbackType.report) {
                        push(context, FeedbackReport());
                      } else if (feedbackList[index].feedbackType ==
                          FeedbackType.suggestion) {
                        push(context, FeedbackSuggestion());
                      } else {
                        push(context, FeedbackInbox());
                      }
                    },
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.055),
                          margin: EdgeInsets.only(bottom: 45),
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
                            children: [
                              Icon(
                                feedbackList[index].iconData,
                                size: 40,
                                color: colorPrimary,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  feedbackList[index].title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (feedbackList[index].notificationCount != null)
                          Container(
                            height: 29,
                            width: 29,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorPrimary),
                            alignment: Alignment.center,
                            child: Text(
                              feedbackList[index].notificationCount!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                      ],
                    ),
                  );
              }),
        ],
      ),
    );
  }
}

class FeedbackClass {
  IconData iconData;
  String title;
  String? notificationCount;
  FeedbackType feedbackType;

  FeedbackClass(
      {this.iconData = Icons.flag,
      this.title = '',
      this.notificationCount,
      this.feedbackType = FeedbackType.report});
}

enum FeedbackType { report, suggestion, message }
