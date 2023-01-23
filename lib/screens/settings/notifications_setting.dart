import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/screens/settings/setting_provider.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../models/notification_setting.dart';

class NotificationsSetting extends StatefulWidget {
  @override
  State<NotificationsSetting> createState() => _NotificationsSettingState();
}

class _NotificationsSettingState extends State<NotificationsSetting> {
  // const NotificationsSetting({super.key});
  @override
  void initState() {
    super.initState();
   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {context.read<SettingProvider>().initNotifications(); });
  }

  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider=context.watch<SettingProvider>();
    return WillPopScope(
      onWillPop: onWillPopscope,
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'Notifications',
          actions: [
            if(settingProvider.isSaveChanges)
            TextButton(onPressed: (){
              context.read<SettingProvider>().doCallUpdateNotification(context);
            }, child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Save',
          style: primaryTextStyle(
                color: colorPrimary, size: 20, weight: FontWeight.w500)),
            ))
          ],
        ),
        body: CustomLoader(
          isLoading: settingProvider.isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9.0),
                            child: Icon(
                              Icons.notifications,
                              color: colorPrimary,
                              size: 18,
                            ),
                          ),
                          Text(
                            'Push Notifications',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Color(0xffD9D9D9),
                                thickness: 1,
                                height: 16,
                              ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: settingProvider.pushNotifications.length,
                          itemBuilder: (context, index) =>
                              pushCell(settingProvider.pushNotifications[index]))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 9.0),
                            child: Icon(
                              Icons.email,
                              color: colorPrimary,
                              size: 18,
                            ),
                          ),
                          Text(
                            'Email Notifications',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Color(0xffD9D9D9),
                                thickness: 1,
                                height: 16,
                              ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: settingProvider.emailNotifications.length,
                          itemBuilder: (context, index) =>
                              pushCell(settingProvider.emailNotifications[index]))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pushCell(NotificationsObj notificationsObj) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          notificationsObj.title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: textColorPrimary),
        ),
        Switch(
          value: notificationsObj.isTrue,
          onChanged: (value) {
            context.read<SettingProvider>().setToggle(notificationsObj);
          },
          thumbColor: MaterialStateProperty.all(colorAccent),
          trackColor: MaterialStateProperty.all(Color(0xffD9D9D9)),
          inactiveThumbColor: Color(0xffB1B1B1),
        ),
      ],
    );
  }

  Future<bool> onWillPopscope() async {
    if (context.read<SettingProvider>().isSaveChanges) {
      return (await showConfirmDialog(context,
              'Your changes will be discarded if you go back, do you wan to go back?',onAccept: (){
                Navigator.of(context).pop();
              })) ??
          false;
    } else {
      return Future.value(true);
    }
  }
}

class NotificationsObj {
  String key;
  String title;
  bool isTrue;
  NotificationsObj({this.key = '', this.title = '', this.isTrue = true});
}
