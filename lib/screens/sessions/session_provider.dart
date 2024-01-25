import 'dart:ffi';

import 'package:bookthera_customer/models/book_sessoin.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'widgets/feed_back_success.dart';
import 'widgets/report_no_show.dart';

class SessionProvider with ChangeNotifier {
  bool isLoading = false;
  bool isFirstLoad = false;
  List<BookSession> sessionList = [];
  List<BookSession> upcomming = [];
  List<BookSession> completed = [];
  List<BookSession> rejectedList = [];

  setLoader(bool stauts) {
    isLoading = stauts;
    notifyListeners();
  }

  setIsFirstLoad(bool stauts) {
    isFirstLoad = stauts;
  }

  void updateReviewBy(String id) {
    int index=sessionList.indexWhere((element) => element.sId==id);
    if (index!=-1) {
      sessionList[index].reviewByUser='1';
    }
    notifyListeners();
  }

  doCallGetSessoins() {
    setLoader(true);
    callGetSessions().then((value) {
      if (value is String) {
        toast(value);
      } else if (value is List<BookSession>) {
        if (value.isNotEmpty) {
          upcomming.clear();
          completed.clear();
          rejectedList.clear();
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
                // if (sessionList[i].dateTime != null && sessionList[i].time!=null) {
                //   // Assuming sessionList[i].dateTime is a DateTime object and sessionList[i].time is a String in "HH:mm" format
                //   DateTime combinedDateTime = DateTime(
                //     sessionList[i].dateTime!.year,
                //     sessionList[i].dateTime!.month,
                //     sessionList[i].dateTime!.day,
                //     int.parse(sessionList[i].time!.split(":")[0]),
                //     int.parse(sessionList[i].time!.split(":")[1]),
                //   );

                //   if (combinedDateTime.isBefore(DateTime.now())) {
                //     rejectedList.add(sessionList[i]);
                //   } else {
                //     upcomming.add(sessionList[i]);
                //   }
                // } else{
                //   upcomming.add(sessionList[i]);
                // }
                upcomming.add(sessionList[i]);
                break;
            }
          }
        }
      }
      setLoader(false);
    });
  }

  doCallUpdateBookSession(Map body, String id, {bool isCancel = false,bool isComplete = false}) {
    setLoader(true);
    callUpdateBookSession(body, id).then((value) {
      if (value is String) {
        toast(value);
      } else if (value is BookSession) {
        // true
        if (isCancel) {
          upcomming.removeWhere((element) => element.sId == id);
          rejectedList.add(value);
        } else if(isComplete){
          upcomming.removeWhere((element) => element.sId == id);
          completed.add(value);
        }else {
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
        context.read<SessionProvider>().updateReviewBy(body['sessionId']);
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

  doCallReportNoShow(Map body,BuildContext context){
    if(isLoading)return;
    setLoader(true);
    callReportNoShow(body).then((value) {
      setLoader(false);
      if (value==true) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) => ReportSuccess(
                ));
      } else {
        if (value is String) {
          toast(value);
        }
      }
    });
  }
}
