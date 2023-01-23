import 'package:bookthera_provider/components/custom_button.dart';
import 'package:bookthera_provider/network/RestApis.dart';
import 'package:bookthera_provider/screens/auth/LoginScreen.dart';
import 'package:bookthera_provider/screens/settings/notifications_setting.dart';
import 'package:bookthera_provider/screens/settings/reviews_setting.dart';
import 'package:bookthera_provider/utils/Constants.dart';
import 'package:bookthera_provider/utils/datamanager.dart';
import 'package:bookthera_provider/utils/resources/Colors.dart';
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
            padding: const EdgeInsets.only(top: 32.0, left: 32, right: 32),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Center(
                    child:
                        displayCircleImage(Datamanager().profile, 130, true)),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  start: 80,
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
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              Datamanager().firstName + ' ' + Datamanager().lastName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              Datamanager().userName,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 16),
              itemCount: settingsList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 16, left: 16, bottom: 12),
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
                  child: ListTile(
                    minLeadingWidth: 0,
                    onTap: settingsList[index].onTap,
                    title: Text(
                      settingsList[index].title,
                      style: TextStyle(fontSize: 16),
                    ),
                    leading: Icon(
                      settingsList[index].iconData,
                      color: colorPrimary,
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: textColorPrimary,
                    ),
                  ),
                );
              }),
          Container(
            margin: EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 32),
            width: double.infinity,
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
            child: ListTile(
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
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          ),
          Text(
            '$app_name app $appVersion',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
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
