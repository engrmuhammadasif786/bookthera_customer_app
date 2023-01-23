import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/models/ConversationModel.dart';
import 'package:bookthera_customer/models/HomeConversationModel.dart';
import 'package:bookthera_customer/screens/inbox/chat_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/datamanager.dart';
import '../../utils/resources/Colors.dart';

class FeedbackInbox extends StatelessWidget {
  const FeedbackInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        elevation: 0,
        title: 'Bug Messages',
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Color(0xff9394a1).withOpacity(0.4),
                            width: 5.0),
                      ),
                    ),
                  ),
                  TabBar(
                      onTap: (value) {
                        // setState(() {
                        //   value = tabController.index;
                        // });
                      },
                      indicatorColor: colorPrimary,
                      indicatorWeight: 5,
                      labelColor: colorPrimary,
                      unselectedLabelColor: Color(0xff9394a1),
                      labelStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppinsr'),
                      unselectedLabelStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppinsr'),
                      labelPadding: EdgeInsets.only(right: 20, left: 20),
                      tabs: [
                        Tab(
                          child: Text(
                            'Repot Bug',
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Suggestion',
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                ChatScreenView(senderId: Datamanager().adminId,bugSuggestionType: 'bug',),
                ChatScreenView(senderId: Datamanager().adminId,bugSuggestionType: 'suggestion',)
              ]),
            )
          ],
        ),
      ),
    );
  }
}
