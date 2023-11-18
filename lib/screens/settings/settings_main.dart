import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/screens/auth/LoginScreen.dart';
import 'package:bookthera_customer/screens/settings/notifications_setting.dart';
import 'package:bookthera_customer/screens/settings/reviews_setting.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart' as nb;

import '../../utils/helper.dart';
import 'account_setting.dart';
import 'billing_setting.dart';
import 'contact_us.dart';

class SettingsMain extends StatefulWidget {
  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  // const SettingsMain({super.key});
  List<SettingModel> settingsList = [];

  @override
  void initState() {
    super.initState();
    settingsList = [
      SettingModel(
        title: 'Account',
        iconData: Icons.person,
        onTap: () {
          push(context, AccountSetting()).then((value) {
            if (value ?? false) {
              setState(() {});
            }
          });
        },
      ),
      SettingModel(
        title: 'Billing',
        iconData: Icons.credit_card,
        onTap: () {
          push(context, BillingSetting());
        },
      ),
      SettingModel(
        title: 'Notification',
        iconData: Icons.notifications,
        onTap: () {
          push(context, NotificationsSetting());
        },
      ),
      SettingModel(
        title: 'Contact Us',
        iconData: Icons.mail,
        onTap: () {
          push(context, ContactUs());
        },
      ),
      SettingModel(
        title: 'Reviews',
        iconData: Icons.star,
        onTap: () {
          push(context, ReviewsSetting());
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: getPadding(top: 32.0, left: 32, right: 32),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Center(
                    child:
                        getCircularImageProvider(NetworkImage(Datamanager().profile), getSize(130), true)),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  start: 0,
                  end: 0,
                  child: FloatingActionButton(
                      backgroundColor: colorPrimary,
                      child: Icon(
                        Icons.camera_alt,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white,
                      ),
                      mini: true,
                      onPressed: () {
                        push(context, AccountSetting()).then((value) {
                          if (value ?? false) {
                            setState(() {});
                          }
                        });
                      }),
                )
              ],
            ),
          ),
          Padding(
            padding: getPadding(top: 8.0),
            child: Text(
              Datamanager().firstName + ' ' + Datamanager().lastName,
              style: TextStyle(fontSize: getFontSize(16), fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: getPadding(top: 4.0),
            child: Text(
              Datamanager().userName,
              style: TextStyle(fontSize: getFontSize(13), fontWeight: FontWeight.w500),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: getPadding(top: 16),
              itemCount: settingsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: settingsList[index].onTap,
                  child: Container(
                    margin: getPadding(right: 16, left: 16, bottom: 12),
                    width: double.infinity,
                    padding: getPadding(all: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(getSize(15)),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 5,
                              spreadRadius: 2,
                              color: Colors.black.withOpacity(0.1))
                        ]),
                    child: Row(
                      children: [
                        Icon(
                      settingsList[index].iconData,
                      color: colorPrimary,
                      size: getSize(22),
                    ),
                        Padding(
                          padding: getPadding(left: 16),
                          child: Text(
                            settingsList[index].title,
                            style: TextStyle(fontSize: getFontSize(16)),
                          ),
                        ),
                        Spacer(),
                        Icon(
                      Icons.chevron_right,
                      color: textColorPrimary,
                    )
                      ],
                    ),
                  ),
                );
              }),
          GestureDetector(
            onTap: () async {
                  if (nb.getBoolAsync(isGoogleSignin)) {
                    await GoogleSignIn().signOut();
                  }
                  logout().then((value) {
                    if (value) {
                      pushAndRemoveUntil(context, LoginScreen(), false);
                    }
                  });
                },
            child: Container(
              margin: EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 32),
              width: double.infinity,
              padding: getPadding(all: 16),
              decoration: BoxDecoration(
                  color: colorPrimary,
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
                  Image.asset('assets/images/img_logout.png',height: getSize(22),width: getSize(22),),
                  Padding(
                    padding: getPadding(left: 16),
                    child: Text(
                      'Logout',
                      style: TextStyle(fontSize: getFontSize(16), color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            '$app_name app $appVersion',
            style: TextStyle(fontSize: getFontSize(13), fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}

class SettingModel {
  IconData iconData;
  String title;
  void Function()? onTap;
  SettingModel({this.iconData = Icons.person, this.onTap, this.title = ''});
}
