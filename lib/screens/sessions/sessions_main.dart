import 'package:bookthera_customer/components/custom_loader.dart';
import 'package:bookthera_customer/screens/sessions/empty_sessions.dart';
import 'package:bookthera_customer/screens/sessions/session_provider.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import 'session_cell.dart';

class SessionsMain extends StatefulWidget {
  @override
  State<SessionsMain> createState() => _SessionsMainState();
}

class _SessionsMainState extends State<SessionsMain> {
  // const SessionsMain({super.key});
  List<SessoinTab> sessionTabs = [
    SessoinTab(index: 0, title: 'Upcoming'),
    SessoinTab(index: 1, title: 'Completed'),
    SessoinTab(index: 2, title: 'Cancelled')
  ];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {context.read<SessionProvider>().doCallGetSessoins();});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SessionProvider sessionProvider=Provider.of<SessionProvider>(context,listen: true);
    return Stack(
      children: [
        if(sessionProvider.sessionList.isNotEmpty && sessionProvider.isLoading) LinearProgressIndicator(color: colorPrimary,minHeight: 2,),
        CustomLoader(
          isLoading: sessionProvider.sessionList.isEmpty && sessionProvider.isLoading,
          child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.06,
                    margin: EdgeInsets.symmetric(
                        vertical: size.height * 0.02, horizontal: size.width * 0.05),
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 5,
                              spreadRadius: 2,
                              color: Colors.black.withOpacity(0.1))
                        ]),
                    child: TabBar(
                        indicator: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        labelStyle: TextStyle(
                            fontSize: size.width * 0.037,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500),
                        unselectedLabelStyle: TextStyle(
                            fontSize: size.width * 0.037, fontFamily: 'Roboto'),
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.white,
                        tabs: List.generate(
                            sessionTabs.length,
                            (index) => Tab(
                                  child: Text(
                                    sessionTabs[index].title,
                                    style: TextStyle(
                                        fontSize: getFontSize(14), fontWeight: FontWeight.w500),
                                  ),
                                ))),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      ListView.builder(
                          itemCount: sessionProvider.upcomming.length,
                          itemBuilder: (context, index) {
                            return SessionCell(bookSession: sessionProvider.upcomming[index],);
                          }),
                    ListView.builder(
                          itemCount: sessionProvider.completed.length,
                          itemBuilder: (context, index) {
                            return SessionCell(bookSession: sessionProvider.completed[index],);
                          }),
                    ListView.builder(
                          itemCount: sessionProvider.rejectedList.length,
                          itemBuilder: (context, index) {
                            return SessionCell(bookSession: sessionProvider.rejectedList[index],);
                          }),
                    ]),
                  ),
                  
                ],
              )),
        ),
      ],
    );
  }
}

class SessoinTab {
  int index;
  String title;
  SessoinTab({this.index = 0, this.title = ''});
}
