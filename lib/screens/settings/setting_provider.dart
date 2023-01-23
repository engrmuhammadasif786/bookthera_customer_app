import 'dart:io';

import 'package:bookthera_customer/models/book_sessoin.dart';
import 'package:bookthera_customer/models/payment_card.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/screens/settings/notifications_setting.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/notification_setting.dart';
import '../../models/reviewModel.dart';

class SettingProvider with ChangeNotifier {
  bool isLoading = false;
  bool isOldPasswordVisible = false;
  bool isPasswordVisible = false;
  bool isConPasswordVisible = false;
  bool isShowCardFrom = false;
  bool isSaveChanges = false;

  NotificationSetting? notificationsSetting;
  List<NotificationsObj> pushNotifications = [
    NotificationsObj(
        key: 'alert_5_before_session',
        title: 'Alert 5 minutes before sessions'),
    NotificationsObj(
        key: 'alert_provider_joined_session',
        title: 'Alert for provider joined session'),
    NotificationsObj(key: 'rating_reminder', title: 'Rating reminders'),
    NotificationsObj(key: 'new_messages', title: 'New messages')
  ];

  List<NotificationsObj> emailNotifications = [
    NotificationsObj(
        key: 'alert_5_before_session',
        title: 'Alert 5 minutes before sessions'),
    NotificationsObj(
        key: 'alert_provider_joined_session',
        title: 'Alert for provider joined session'),
    NotificationsObj(key: 'rating_reminder', title: 'Rating reminders'),
    NotificationsObj(key: 'new_messages', title: 'New messages')
  ];

  List<PaymentCard> paymentCards = Datamanager().userCards;
  List<BookSession> bookSessions = Datamanager().bookSessions;
  String? username, cardNum, expiry, cvv;

  List<ReviewModel> reviewsList=[];
  
  initNotifications() {
    notificationsSetting=Datamanager().notificationSetting;
    setSaveChanges(false);
    if (notificationsSetting != null &&
        notificationsSetting!.pushJson != null) {
      List jsonKeys = notificationsSetting!.pushJson!.keys.toList();
      for (var i = 0; i < jsonKeys.length; i++) {
        String key = jsonKeys[i];
        String value = notificationsSetting!.pushJson![key];
        pushNotifications.forEach((element) {
          if (element.key == key) {
            element.isTrue = value == '1' ? true : false;
          }
        });
      }
    }else{
      pushNotifications.forEach((element) {element.isTrue=true;});
    }

    if (notificationsSetting != null &&
        notificationsSetting!.emailJson != null) {
      List jsonKeys = notificationsSetting!.emailJson!.keys.toList();
      for (var i = 0; i < jsonKeys.length; i++) {
        String key = jsonKeys[i];
        String value = notificationsSetting!.emailJson![key];
        emailNotifications.forEach((element) {
          if (element.key == key) {
            element.isTrue = value == '1' ? true : false;
          }
        });
      }
    }else{
      emailNotifications.forEach((element) {element.isTrue=true;});
    }
  }

  setLoader(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setSaveChanges(bool status) {
    isSaveChanges = status;
    notifyListeners();
  }

  setToggle(NotificationsObj notificationsObj) {
    notificationsObj.isTrue = !notificationsObj.isTrue;
    setSaveChanges(true);
  }

  setIsShowCardFrom(bool status) {
    isShowCardFrom = status;
    notifyListeners();
  }

  setIsOldPasswordVisible() {
    isOldPasswordVisible = !isOldPasswordVisible;
    notifyListeners();
  }

  setIsPasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  setIsConPasswordVisible() {
    isConPasswordVisible = !isConPasswordVisible;
    notifyListeners();
  }

  setPrimaryCard(PaymentCard paymentCard) {
    paymentCards.forEach((element) {
      element.isPrimary = '0';
      if (element.id == paymentCard.id) {
        paymentCard.isPrimary = '1';
      }
    });
    doCallUpdateCard({'isPrimary': paymentCard.isPrimary}, paymentCard.id!);
    notifyListeners();
  }

  String getCreditCardIcon(PaymentCard paymentCard) {
    String card = '';
    switch (paymentCard.cardType) {
      case 'visa':
        card = 'assets/icons/ic_visa_card.png';
        break;
      case 'mastercard':
        card = 'assets/icons/ic_master_card.png';
        break;
      case 'american-express':
        card = 'assets/icons/ic_american_card.png';
        break;
      default:
        card = 'assets/icons/ic_credit_card.png';
        break;
    }
    return card;
  }

  doCallUpdateProfile(Map body, File? image, BuildContext context) {
    setLoader(true);
    callUpdateProfile(body, image).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else {
        if (value) {
          toast('Profile updated successfully');
          Navigator.of(context).pop(true);
        }
      }
    });
  }

  doCallUpdatePassword(Map body, BuildContext context) {
    setLoader(true);
    callUpdatePassword(body).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else {
        if (value) {
          toast('Password updated successfully');
          setValue(PASSWORD, body['newPassword']);
          Navigator.of(context).pop();
        }
      }
    });
  }

  doCallCreateCard(BuildContext context) {
    String? msg;
    if (username == null) {
      msg = 'Cardholder name is required';
    } else if (cardNum == null) {
      msg = 'Card number is required';
    } else if (expiry == null) {
      msg = 'Exp date is required';
    } else if (!expiry!.contains('/')) {
      msg = 'Invalid Exp date format';
    } else if (cvv == null) {
      msg = 'CVV is required';
    }
    if (msg != null) {
      toast(msg);
      return;
    }
    hideKeyboard(context);
    setLoader(true);
    String expMonth = expiry!.split('/').first;
    String expYear = expiry!.split('/').last;
    Map card = {
      "cardName": username,
      "cardNumber": cardNum,
      "cardExpMonth": expMonth,
      "cardExpYear": expYear,
      "cardCvv": cvv
    };
    setLoader(true);
    callCreateCard(card).then((value) {
      if (value is PaymentCard) {
        paymentCards.add(value);
        isShowCardFrom = false;
      } else {
        toast(value);
      }
      setLoader(false);
    });
  }

  doCallUpdateCard(Map body, String id) {
    callUpdateCard(body, id).then((value) {
      if (value is String) {
        toast(value);
      } else {}
    });
  }

  doCallDeleteCard(String id) {
    setLoader(true);
    callDeleteCard(id).then((value) {
      if (value is String) {
        toast(value);
      } else {
        if (value) {
          Datamanager().userCards.removeWhere((element) => element.id == id);
          paymentCards = Datamanager().userCards;
        }
      }
      setLoader(false);
    });
  }

  doCallUpdateNotification(BuildContext context) {
    setLoader(true);
    Map body = {};
    Map jsonPush = {};
    Map jsonEmail = {};
    pushNotifications.forEach((element) {
      jsonPush[element.key] = element.isTrue ? '1' : "0";
    });

    emailNotifications.forEach((element) {
      jsonEmail[element.key] = element.isTrue ? '1' : "0";
    });
    body['pushJson'] = jsonPush;
    body['emailJson'] = jsonEmail;

    callUpdateNotifications(body).then((value) {
      if (value is NotificationSetting) {
         toast('Notification settings updated successfully');
         Datamanager().notificationSetting=value;
         Navigator.of(context).pop();
      } else {
        toast(value);
      }
      setLoader(false);
    });
  }

  doCallContactUs(String comments,BuildContext context) {
    setLoader(true);
    Map body={};
    body['comments']=comments;
    callContactUs(body).then((value) {
      if (value is String) {
        toast(value);
      } else {
        if (value) {
          toast('Email sent successfully');
          Navigator.of(context).pop();
        }
      }
      setLoader(false);
    });
  }

  doCallGetReviews() {
    setLoader(true);
    callGetReviews().then((value) {
      if (value is List<ReviewModel>) {
        reviewsList=value;
      } else {
       toast(value);
      }
      setLoader(false);
    });
  }
}
