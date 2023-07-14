import 'dart:ffi';

import 'package:bookthera_customer/models/book_sessoin.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'widgets/feed_back_success.dart';

class SessionProvider with ChangeNotifier {
  bool isLoading = false;
  List<BookSession> sessionList = [];
  List<BookSession> upcomming = [];
  List<BookSession> completed = [];
  List<BookSession> rejectedList = [];

  setLoader(bool stauts) {
    isLoading = stauts;
    notifyListeners();
  }

  doCallGetSessoins() {
    sessionList.clear();
    upcomming.clear();
    completed.clear();
    rejectedList.clear();
    setLoader(true);
    callGetSessions().then((value) {
      if (value is String) {
        toast(value);
      } else if (value is List<BookSession>) {
        sessionList = value;
        for (var i = 0; i < sessionList.length; i++) {
          switch (sessionList[i].status) {
            case 'completed':
              completed.add(sessionList[i]);
              break;
            case 'cancelled':
              rejectedList.add(sessionList[i]);
              break;
            default:
              upcomming.add(sessionList[i]);
              break;
          }
        }
      }
      setLoader(false);
    });
  }

  doCallUpdateBookSession(Map body, String id, {bool isCancel = false}) {
    setLoader(true);
    callUpdateBookSession(body, id).then((value) {
      if (value is String) {
        toast(value);
      } else if (value is BookSession) {
        // true
        if (isCancel) {
          upcomming.removeWhere((element) => element.sId == id);
          rejectedList.add(value);
        } else {
          int index = upcomming.indexWhere((element) => element.sId == id);
          upcomming[index] = value;
        }
      }
      setLoader(false);
    });
  }

  doCallCreateReview(BuildContext context, Map body) {
    setLoader(true);
    callCreateReivew(body).then((value) {
      if (value is String) {
        toast(value);
      } else if (value) {
        // true
        showDialog(context: context, builder: (context) => FeedbackSuccess());
      }
      setLoader(false);
    });
  }

  Future<dynamic> doCallGetAgoraToken(String channel,String sessionId) async{
    String role = 'audience';
    String userId=getStringAsync(USER_ID);
    // int uid = int.parse(userId.substring(userId.length-5),radix: 16);
    String token='';
    setLoader(true);
    await callGetAgoraToken(channel,role,userId,sessionId).then((value) {
      if (value is String) {
        token = value;
        print("Token retrieved: $token");
      }
      setLoader(false); 
    });
    return token;
  }
}
