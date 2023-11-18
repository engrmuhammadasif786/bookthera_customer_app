import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/models/ConversationModel.dart';
import 'package:bookthera_customer/models/HomeConversationModel.dart';
import 'package:bookthera_customer/screens/inbox/chat_provider.dart';
import 'package:bookthera_customer/screens/inbox/chat_screen_view.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../utils/datamanager.dart';
import '../../utils/resources/Colors.dart';

class FeedbackInbox extends StatefulWidget {
  const FeedbackInbox({super.key});

  @override
  State<FeedbackInbox> createState() => _FeedbackInboxState();
}

class _FeedbackInboxState extends State<FeedbackInbox> {

  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().messagesByIdList.clear();
  }

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
                        context.read<ChatProvider>().messagesByIdList.clear();
                      },
                      indicatorColor: colorPrimary,
                      indicatorWeight: 5,
                      labelColor: colorPrimary,
                      unselectedLabelColor: Color(0xff9394a1),
                      labelStyle: TextStyle(
                          fontSize: getFontSize(15),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppinsr'),
                      unselectedLabelStyle: TextStyle(
                          fontSize: getFontSize(15),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppinsr'),
                      labelPadding: getPadding(right: 20, left: 20),
                      tabs: [
                        Tab(
                          child: Text(
                            'Report Bug',
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
