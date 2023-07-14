import 'dart:ffi';
import 'dart:io';

import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/models/ProviderCategory.dart';
import 'package:bookthera_customer/models/book_sessoin.dart';
import 'package:bookthera_customer/models/focus_model.dart';
import 'package:bookthera_customer/models/session_model.dart';
import 'package:bookthera_customer/models/time_slot.dart';
import 'package:bookthera_customer/network/NetworkUtils.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/screens/home/dashboard.dart';
import 'package:bookthera_customer/screens/sessions/audioVideosCalls/call.dart';
import 'package:bookthera_customer/utils/AppWidgets.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/helper.dart';
import 'package:bookthera_customer/utils/paypalPaymentService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookthera_customer/utils/helper.dart' as hp;

import '../../../models/payment_card.dart';
import '../../../utils/datamanager.dart';
import 'order_success.dart';
import 'payment_screen.dart';

enum SesstionType { Video, Audio }

class BookSesstionProvider extends ChangeNotifier {
  bool isLoading = false;
  List<TimeSlot> timeslots = [];
  List<int> weekendDays = [DateTime.saturday];
  List<TimeSlot> customDates = [];
  List<Slots> slotsList = [];
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';

  //// foucs list
  List<FocusModel> foucsList = [];
  String? selectedFocus;

  //// image
  File? image;

  //// sesstion type
  SesstionType sesstionType = SesstionType.Video;

  //// intensionsController
  TextEditingController intensionsController = TextEditingController();

  //// session info
  SesssionModel? selectedSesssion;
  String providerId = '';

  //// card details
  List<PaymentCard> paymentCards = Datamanager().userCards;
  String? username, cardNum, expiry, cvv;
  bool saveCard = false;
  bool isShowCardFrom = false;

  TextEditingController userController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  //// total price
  double total = 0.0;

  //// book sessoin id
  String? bookSessionId;

  updateIsShowCardForm() {
    isShowCardFrom = !isShowCardFrom;
    notifyListeners();
  }

  getTotal() {
    isShowCardFrom = paymentCards.isEmpty ? true : false;
    if (selectedSesssion != null) {
      total = selectedSesssion!.price + Datamanager().serviceFee;
    }
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

  setPrimaryCard(PaymentCard paymentCard) {
    paymentCards.forEach((element) {
      element.isPrimary = '0';
      if (element.id == paymentCard.id) {
        paymentCard.isPrimary = '1';
      }
    });
    notifyListeners();
  }

  updateSaveCard() {
    saveCard = !saveCard;
    notifyListeners();
  }

  setSesstionType(SesstionType type) {
    sesstionType = type;
    notifyListeners();
  }

  setImage(File file) {
    image = file;
    notifyListeners();
  }

  setLoader(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  setSelectedFocus(String id) {
    foucsList.forEach((element) {
      element.isSelected = false;
    });
    selectedFocus = id;
    notifyListeners();
  }

  getDateSlots(DateTime dateTime) {
    if (timeslots.isEmpty) {
      return;
    }
    selectedDate = dateTime;
    slotsList.clear();
    switch (dateTime.weekday) {
      case DateTime.monday:
        slotsList.addAll(
            timeslots.firstWhere((element) => element.type == 'monday').slots);
        break;
      case DateTime.tuesday:
        slotsList.addAll(
            timeslots.firstWhere((element) => element.type == 'tuesday').slots);
        break;
      case DateTime.wednesday:
        slotsList.addAll(timeslots
            .firstWhere((element) => element.type == 'wednesday')
            .slots);
        break;
      case DateTime.thursday:
        slotsList.addAll(timeslots
            .firstWhere((element) => element.type == 'thursday')
            .slots);
        break;
      case DateTime.friday:
        slotsList.addAll(
            timeslots.firstWhere((element) => element.type == 'friday').slots);
        break;
      case DateTime.sunday:
        slotsList.addAll(timeslots
            .firstWhere((element) => element.type == 'thursday')
            .slots);
        break;
      default:
    }
    customDates.forEach(
      (element) {
        if (element.date != null) {
          DateTime day = element.date!;
          if (day.day == dateTime.day &&
              day.month == dateTime.month &&
              day.year == dateTime.year) {
            slotsList.clear();
            slotsList.addAll(element.slots);
          }
        }
      },
    );
    notifyListeners();
  }

  doCallGetProviderTimeSlot(String providerId) {
    setLoader(true);
    callGetProvidersTimeSlots(providerId).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else if (value is List<TimeSlot>) {
        timeslots = value;
        customDates.clear();
        slotsList.clear();
        weekendDays.clear();
        weekendDays.add(DateTime.saturday);
        timeslots.forEach((element) {
          switch (element.type) {
            case 'monday':
              if (!element.status) {
                weekendDays.add(DateTime.monday);
              }
              break;
            case 'tuesday':
              if (!element.status) {
                weekendDays.add(DateTime.tuesday);
              }
              break;
            case 'wednesday':
              if (!element.status) {
                weekendDays.add(DateTime.wednesday);
              }
              break;
            case 'thursday':
              if (!element.status) {
                weekendDays.add(DateTime.thursday);
              }
              break;
            case 'friday':
              if (!element.status) {
                weekendDays.add(DateTime.friday);
              }
              break;
            case 'sunday':
              if (!element.status) {
                weekendDays.add(DateTime.sunday);
              }
              break;
            default:
              customDates.add(element);
          }
        });
      }
    });
  }

  bool bookSessionValidator(BuildContext context) {
    hideKeyboard(context);
    bool status = false;
    if (selectedFocus != null &&
        intensionsController.text.isNotEmpty) {
      status = true;
    }
    if (!status) {
      toast('Please fill all required details');
    }
    return status;
  }

  doCallGetFocus() {
    setLoader(true);
    callGetFocus().then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      } else if (value is List<FocusModel>) {
        foucsList = value;
      }
    });
  }

  doCallBookSession(BuildContext context) async{
    setLoader(true);
    Map body = {};
    body['providerId'] = providerId;
    body['sessionId'] = selectedSesssion!.sId;
    body['focusId'] = selectedFocus;
    body['isPromotion'] = selectedSesssion!.isPromotion.toString();
    body['date'] = selectedDate.toString();
    body['time'] = selectedTime;
    body['intensions'] = intensionsController.text;
    body['type'] = sesstionType == SesstionType.Video ? 'video' : 'audio';
    File? selectedImage;
    if(image!=null)
     selectedImage = (isIOS ?await compressImage(image!) : image) as File;
    callGetCreateBookSession(body, selectedImage).then((value) {
      setLoader(false);
      if (value is String) {
        // return string id if true
        bookSessionId = value;
        intensionsController.clear();
        image=null;
        hp.push(context, PaymentScreen());
      }
    });
  }

  doCallUpdateBookSession(BuildContext context, PaymentCard paymentCard,{String paymentIntentId=''}) {
    setLoader(true);
    Map body = {"isPayment": "true","paymentIntentId":paymentIntentId,"captureAmount":total};
    if (saveCard) {
      body['isSaveCard'] = "true";
      if (paymentCard.id != null) {
        body['cardId'] = paymentCard.id;
      } else {
        body['cardName'] = paymentCard.name;
        body['cardNumber'] = paymentCard.number;
        body['cardExpMonth'] = paymentCard.expiryMonth;
        body['cardExpYear'] = paymentCard.expiryYear;
        body['cardCvv'] = paymentCard.cvv;
      }
    }
    if (bookSessionId != null) {
      callUpdateBookSession(body, bookSessionId!).then((value) {
        setLoader(false);
        if (value is String) {
          toast(value);
        } else if (value is BookSession) {
          // true
          pushAndRemoveUntil(context, OrderSuccess(), false);
        }
      });
    }
  }

  saveCardData() {
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
    String expMonth = expiry!.split('/').first;
    String expYear = expiry!.split('/').last;
    PaymentCard card = PaymentCard(
        number: cardNum,
        name: username,
        expiryYear: expYear,
        expiryMonth: expMonth,
        cvv: cvv);

    userController.clear();
    numController.clear();
    expiryController.clear();
    cvvController.clear();

    paymentCards.add(card);
    setPrimaryCard(card);
    updateIsShowCardForm();
  }

  makePaymentStripe(BuildContext context) async {
    if (isShowCardFrom) {
      saveCardData();
    } else {
      if (paymentCards.isEmpty) {
        toast('Please provide a payment card');
        return;
      }
      hideKeyboard(context);
      setLoader(true);
      int paymentCardIndex =
          paymentCards.indexWhere((element) => element.isPrimary == '1');
      // Map card = {
      //   "card[number]": paymentCards[paymentCardIndex].number,
      //   "card[exp_month]": paymentCards[paymentCardIndex].expiryMonth,
      //   "card[exp_year]": paymentCards[paymentCardIndex].expiryYear,
      //   "card[cvc]": paymentCards[paymentCardIndex].cvv,
      // };
      // Map paymentData = {
      //   "amount": (total * 100).toStringAsFixed(0),
      //   "currency": 'usd',
      //   "payment_method_types[]": 'card'
      // };
      // print({card, paymentData});
      try {
        // await callStripePaymentIntent(paymentData).then((id) {
        //   print({"payment_intent": id});
        //   if (id != null) {
        //     callStripeTokenApi(card).then((value) {
        //       if (value != null) {
        //         print({"token": value});
        //         callStripeConfirmPaymentIntent(id, {
        //           'payment_method_data[type]': "card",
        //           "payment_method_data[card[token]]": value
        //         }).then((value) {
        //           setLoader(false);
        //           if (value) {
        //             // payment success
        //             doCallUpdateBookSession(
        //                 context, paymentCards[paymentCardIndex],paymentIntentId:id);
        //           } else {
        //             toast(errorSomethingWentWrong);
        //           }
        //         });
        //       } else {
        //         setLoader(false);
        //       }
        //     });
        //   } else {
        //     setLoader(false);
        //   }
        // });

        PaymentService paymentService =PaymentService();
        dynamic paymentNoun = await paymentService.tokenizeCreditCard(BraintreeCreditCardRequest(cardNumber: paymentCards[paymentCardIndex].number!, expirationMonth: paymentCards[paymentCardIndex].expiryMonth!, expirationYear: paymentCards[paymentCardIndex].expiryYear!, cvv: paymentCards[paymentCardIndex].cvv!,cardholderName: paymentCards[paymentCardIndex].name));
        if (paymentNoun==null) {
          setLoader(false);
          toast(errorSomethingWentWrong);
        }else{
           doCallUpdateBookSession(
                        context, paymentCards[paymentCardIndex],paymentIntentId:paymentNoun);
        }
      } catch (e) {
        toast(errorSomethingWentWrong);
      }
    }
  }
}
