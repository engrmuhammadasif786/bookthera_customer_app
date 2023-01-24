import 'package:bookthera_customer/screens/feedback/feedback_main.dart';
import 'package:bookthera_customer/screens/home/home_provider.dart';
import 'package:bookthera_customer/screens/inbox/chat_provider.dart';
import 'package:bookthera_customer/screens/inbox/inbox_main.dart';
import 'package:bookthera_customer/screens/provider/provider_home.dart.dart';
import 'package:bookthera_customer/screens/provider/provider_provider.dart';
import 'package:bookthera_customer/screens/sessions/sessions_main.dart';
import 'package:bookthera_customer/screens/settings/settings_main.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../utils/helper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = context.watch<HomeProvider>().selectedIndex;
    int count = context.watch<ChatProvider>().messagesList.where((element) => !element.seen!).length;
    int feedbackCount= context.watch<ChatProvider>().messagesList.where((element) => element.bugSuggestionType!='normal' && !element.seen!).length;
   return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
            elevation: 2,
            centerTitle: true,
            // leading: Visibility(
            //   visible: selectedIndex == 0,
            //   child: IconButton(
            //       visualDensity: VisualDensity(horizontal: -4),
            //       padding: EdgeInsets.only(right: 5),
            //       icon: Image(
            //         image: AssetImage("assets/icons/menu.png"),
            //         width: 20,
            //         color:
            //             isDarkMode(context) ? Colors.white : appBackground,
            //       ),
            //       onPressed: () {
            //         Scaffold.of(context).openDrawer();
            //       }),
            // ),
            // iconTheme: IconThemeData(color: Colors.blue),
            title: Text(
              selectedIndex == 0
                  ? 'Providers'
                  : selectedIndex == 1
                      ? 'Sessions'
                      : selectedIndex == 2
                          ? 'Feeback'
                          : selectedIndex == 3
                              ? 'Inbox'
                              : 'Settings',
              style: primaryTextStyle(
                  color: textColorPrimary, size: 20, weight: FontWeight.w500),
            ),
            actions: [
              Visibility(
                visible: selectedIndex == 0 &&
                    context.watch<ProviderProvider>().providersList.isNotEmpty,
                child: IconButton(
                    visualDensity: VisualDensity(horizontal: -4),
                    padding: EdgeInsets.only(right: 10),
                    icon: Icon(
                      Icons.grid_view_sharp,
                      color: colorPrimary,
                    ),
                    onPressed: () {
                      context.read<ProviderProvider>().resetProducsList();
                    }),
              ),
              Visibility(
                visible: !Datamanager().isLoggedIn,
                child: TextButton(
                    onPressed: () {},
                    child: Text(selectedIndex == 0 ? 'SignIn' : '',
                        style: TextStyle(
                            fontFamily: "Poppinsm",
                            color: isDarkMode(context)
                                ? appBackground
                                : colorPrimary,
                            fontWeight: FontWeight.w600))),
              )
            ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: colorPrimary,
          unselectedItemColor: textPrimaryColor,
          onTap: (i) async {
            if (i==2) {
              context.read<ChatProvider>().updateViewFeedback(false);
            }
            if (i != 3) {
              context.read<ChatProvider>().cancelTimer();
            }else{
              context.read<ChatProvider>().updateViewChat(false);
            }
            setState(() {
              context.read<HomeProvider>().updateSelectedIndex(i);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/ic_home.png',
                  fit: BoxFit.fitHeight,
                  color: textPrimaryColor,
                  height: 20,
                  width: 20),
              activeIcon: Image.asset('assets/icons/ic_home.png',
                  color: colorPrimary, height: 20, width: 20),
              label: 'Providers',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/icons/ic_calender.png',
                  fit: BoxFit.fitHeight,
                  color: textPrimaryColor,
                  height: 20,
                  width: 20),
              activeIcon: Image.asset('assets/icons/ic_calender.png',
                  color: colorPrimary, height: 20, width: 20),
              label: 'Sessions',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 4,right: 4),
                    child: Image.asset('assets/icons/ic_flag.png',
                        fit: BoxFit.fitHeight,
                        color: textPrimaryColor,
                        height: 22,
                        width: 22),
                  ),
                if (feedbackCount > 0 && context.watch<ChatProvider>().isViewFeedback)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        constraints: BoxConstraints(minHeight: 16,minWidth: 16),
                        alignment: Alignment.center,
                        child: new Text(
                          count.toString(),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              activeIcon: Image.asset('assets/icons/ic_flag.png',
                  color: colorPrimary, height: 22, width: 22),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 4,right: 4),
                    child: Image.asset('assets/icons/ic_chat.png',
                        fit: BoxFit.fitHeight,
                        color: textPrimaryColor,
                        height: 22,
                        width: 22),
                  ),
                  if (count > 0 && context.watch<ChatProvider>().isViewChat)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        constraints: BoxConstraints(minHeight: 16,minWidth: 16),
                        alignment: Alignment.center,
                        child: new Text(
                          count.toString(),
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              activeIcon: Image.asset('assets/icons/ic_chat.png',
                  color: colorPrimary, height: 22, width: 22),
              label: 'Inbox',
            ),
            BottomNavigationBarItem(
              icon: displayCircleImage(Datamanager().profile, 32, false),
              activeIcon:
                  Icon(Icons.settings_outlined, size: 22, color: colorPrimary),
              label: 'Settings',
            ),
          ],
        ),
        body: selectedIndex == 0
            ? ProviderHome()
            : selectedIndex == 1
                ? SessionsMain()
                : selectedIndex == 2
                    ? FeedbackMain()
                    : selectedIndex == 3
                        ? InboxMain()
                        : SettingsMain());
  }

  Widget _buildSearchField() => TextField(
        controller: searchController,
        onChanged: (value) {
          print(value);
        },
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          isDense: true,
          fillColor: isDarkMode(context) ? Colors.grey[700] : Colors.grey[200],
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                searchController.clear();
              }),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(style: BorderStyle.none)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(style: BorderStyle.none)),
          hintText: 'Search',
        ),
      );
}
