
import 'package:bookthera_customer/models/book_sessoin.dart';
import 'package:bookthera_customer/models/notification_setting.dart';
import 'package:bookthera_customer/models/payment_card.dart';
import 'package:bookthera_customer/utils/Constants.dart';

class Datamanager {

  static final Datamanager _singleton = Datamanager._internal();

  factory Datamanager() {
    return _singleton;
  }

  Datamanager._internal();

  bool isLoggedIn = false;
  int userId=0;
  String firstName='';
  String lastName='';
  String userName='';
  String phone='';
  String email='';
  String role='';
  double serviceFee = 0.0; 
  bool isRecordVideo = false;
  String layoutChoice='simple'; 
  String profile=placehorder;
  List recentSearch=[];
  List popularSearch=[];
  String adminId = '63c3daaebf21b0526cbeb97d';
  List<PaymentCard> userCards=[];
  List<BookSession> bookSessions=[];
  NotificationSetting? notificationSetting;

  //// filter data
  bool onlineOnly = false;
  int filter1Index = -1;
  int filter2Index = -1;
  int filter3Index = -1;
  int filter4Index = -1;

  bool isDashboardFirstLoad=false;
  bool isSessionsFirstLoad=false;
}
