import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookthera_provider/models/MessageModel.dart';
import 'package:bookthera_provider/models/Provider.dart';
import 'package:bookthera_provider/models/ProviderCategory.dart';
import 'package:bookthera_provider/models/book_sessoin.dart';
import 'package:bookthera_provider/models/focus_model.dart';
import 'package:bookthera_provider/models/notification_setting.dart';
import 'package:bookthera_provider/models/payment_card.dart';
import 'package:bookthera_provider/models/time_slot.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/reviewModel.dart';
import '../utils/Constants.dart';
import '../utils/datamanager.dart';
import 'NetworkUtils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<dynamic> callLogin(Map request) async {
  Map res =
      await postRequest('api/v1/login', body: request, aAuthRequired: false);
  if (res['success']) {
    // save token
    await setValue(TOKEN, res['token']);
    Map<String, dynamic>? decodedToken =
        JwtDecoder.decode(getStringAsync(TOKEN));
    if (decodedToken != null) {
      await setValue(EXPIRATION_TOKEN_TIME, decodedToken['exp']);
    }

    // save user info
    Map data = res['data'];
    await saveUserData(data);
  } else if (res['message'] != null) {
    return res['message'];
  } else {
    return false;
  }
  return true;
}

Future<dynamic> callSaveFcmToken(Map request) async {
  Map res = await postRequest('api/v1/fcm-token', body: request);
  if (res['success']) {
    // token saved succcessfully
  }
}

Future<dynamic> callProfile() async {
  FirebaseMessaging.instance.getToken().then((fcmToken) {
      print({"fcmToken": fcmToken});
      callSaveFcmToken({"fcmToken": fcmToken ?? ''});
  });
  Map res = await getRequest('api/v1/me');
  if (res['success']) {
    // save token
    await setValue(TOKEN, res['token']);
    Map<String, dynamic>? decodedToken =
        JwtDecoder.decode(getStringAsync(TOKEN));
    if (decodedToken != null) {
      await setValue(EXPIRATION_TOKEN_TIME, decodedToken['exp']);
    }

    // save user info
    Map data = res['user'];
    await saveUserData(data);
  } else if (res['message'] != null) {
    return res['message'];
  } else {
    return false;
  }
  return true;
}

Future<dynamic> callRegister(Map request) async {
  Map res =
      await postRequest('api/v1/register', body: request, aAuthRequired: false);
  if (res['success']) {
    // save token
    await setValue(TOKEN, res['token']);
    Map<String, dynamic>? decodedToken =
        JwtDecoder.decode(getStringAsync(TOKEN));
    if (decodedToken != null) {
      await setValue(EXPIRATION_TOKEN_TIME, decodedToken['exp']);
    }

    // save user info
    Map data = res['data'];
    await saveUserData(data);
  } else if (res['message'] != null) {
    return res['message'];
  } else {
    return false;
  }
  return true;
}

Future<dynamic> callGoogleSignin(Map request) async {
  Map res = await postRequest('api/v1/google-signin',
      body: request, aAuthRequired: false);
  if (res['success']) {
    // save token
    await setValue(TOKEN, res['token']);
    Map<String, dynamic>? decodedToken =
        JwtDecoder.decode(getStringAsync(TOKEN));
    if (decodedToken != null) {
      await setValue(EXPIRATION_TOKEN_TIME, decodedToken['exp']);
    }

    // save user info
    Map data = res['data'];
    await saveUserData(data);
  } else if (res['message'] != null) {
    return res['message'];
  } else {
    return false;
  }
  return true;
}

Future<void> saveUserData(Map<dynamic, dynamic> data) async {
  await setValue(USER_ID, data['_id']);
  await setValue(FIRST_NAME, data['fname']);
  await setValue(LAST_NAME, data['lname']);
  await setValue(USER_ROLE, data['role']);
  await setValue(isLoggedIn, true);

  Datamanager().isLoggedIn = true;
  Datamanager().firstName = data['fname'] ?? "";
  Datamanager().lastName = data['lname'] ?? "";
  Datamanager().userName = data['uname'] ?? "";
  Datamanager().email = data['email'] ?? "";
  Datamanager().role = data['role'] ?? '';
  Datamanager().phone = data['phone'] ?? '';
  if (data['avatar'] != null) {
    Datamanager().profile = data['avatar']['url'];
  }
  Datamanager().recentSearch =
      data['recentSearch'] != null ? data['recentSearch'] : [];
  if (data['billings'] != null) {
    Datamanager().userCards =
        (data['billings'] as List).map((e) => PaymentCard.fromJson(e)).toList();
  }
  if (data['sessions'] != null) {
    Datamanager().bookSessions =
        (data['sessions'] as List).map((e) => BookSession.fromJson(e)).toList();
  }
  if (data['notificationSettings'] != null) {
    Datamanager().notificationSetting =
        NotificationSetting.fromJson(data['notificationSettings']);
  }
  Datamanager().popularSearch = await callPopularSearch() ?? [];
}

getUserData() {
  Datamanager().isLoggedIn = getBoolAsync(isLoggedIn);
  Datamanager().firstName = getStringAsync(FIRST_NAME);
  Datamanager().lastName = getStringAsync(LAST_NAME);
  Datamanager().email = getStringAsync(USER_EMAIL);
  Datamanager().role = getStringAsync(USER_ROLE);
}

Future<dynamic> callForgotPassword(Map request) async {
  Map res = await postRequest('api/v1/forgot-password',
      body: request, aAuthRequired: false);
  if (res['success']) {
    return res['message'];
  } else {
    return false;
  }
}

Future<dynamic> callResetPassword(Map request) async {
  Map res = await postRequest('api/v1/reset-password',
      body: request, aAuthRequired: false);
  if (res['success']) {
    // save token
    await setValue(TOKEN, res['token']);
    Map<String, dynamic>? decodedToken =
        JwtDecoder.decode(getStringAsync(TOKEN));
    if (decodedToken != null) {
      await setValue(EXPIRATION_TOKEN_TIME, decodedToken['exp']);
    }

    // save user info
    Map data = res['data'];
    await saveUserData(data);
  } else if (res['message'] != null) {
    return res['message'];
  } else {
    return false;
  }
  return true;
}

Future<dynamic> logout() async {
  // await clearSharedPref();
  if (await isNetworkAvailable()) {
    Datamanager().isLoggedIn = false;
    Datamanager().firstName = '';
    Datamanager().lastName = '';
    Datamanager().email = '';
    Datamanager().role = '';

    await removeKey(TOKEN);
    await removeKey(USER_ID);
    await removeKey(FIRST_NAME);
    await removeKey(LAST_NAME);
    await removeKey(USER_PROFILE);
    await setValue(isLoggedIn, false);
  } else {
    toast(errorInternetNotAvailable);
    return false;
  }
  return true;
}

Future<UserCredential> signInWithGoogle() async {
  await setValue(isGoogleSignin, true);
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<dynamic> callPopularSearch() async {
  Map res = await getRequest('api/v1/get-popular-seach');
  if (res['success']) {
    if (res['data'] != null) {
      List data = [];
      res['data'].forEach((v) {
        data.add(v['name']);
      });
      return data;
    }
  }
}

Future<dynamic> callGetProvidersByCategory() async {
  Map res = await getRequest('api/v1/provider-categories');
  if (res['success']) {
    List data = <ProviderCategory>[];
    if (res['data'] != null) {
      res['data'].forEach((v) {
        data.add(new ProviderCategory.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetProvidersByFavourite() async {
  Map res = await getRequest('api/v1/provider-favourites');
  if (res['success']) {
    List data = <ProviderModel>[];
    if (res['results'] != null) {
      res['results'].forEach((v) {
        data.add(new ProviderModel.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callProviderLikeUnlike(String providerId) async {
  Map res = await getRequest('api/v1/like-provider?id=$providerId');
  if (res['success']) {
    return true;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetProviderById(String providerId) async {
  Map res = await getRequest('api/v1/provider?id=$providerId');
  if (res['success']) {
    if (res['data'] != null) {
      return ProviderModel.fromJson(res['data']);
    }
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetProviders(
    {String price = '',
    String reviewsCount = '',
    bool isAudio = true,
    bool isVideo = true,
    bool isChat = true,
    bool isBook = true,
    bool promotion = true,
    bool onlineOnly = false}) async {
  String path =
      'api/v1/get-providers?isAudio=$isAudio&isVideo=$isVideo&promotion=$promotion&isChat=$isChat&isBook=$isBook';
  if (price.isNotEmpty) {
    path = path + "&price=$price";
  }
  if (reviewsCount.isNotEmpty) {
    path = path + "&reviewsCount=$reviewsCount";
  }
  Map res = await getRequest(path);
  if (res['success']) {
    List data = <ProviderModel>[];
    if (res['results'] != null) {
      res['results'].forEach((v) {
        data.add(new ProviderModel.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetProvidersSearch(String q) async {
  String userId = await getStringAsync(USER_ID);
  Map res = await getRequest('api/v1/search-providers?q=$q&id=$userId');
  if (res['success']) {
    List data = <ProviderModel>[];
    if (res['results'] != null) {
      res['results'].forEach((v) {
        data.add(new ProviderModel.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetProvidersTimeSlots(String providerId) async {
  Map res = await getRequest('api/v1/get-timeSlot?providerId=$providerId');
  if (res['success']) {
    List<TimeSlot> timeSlots = [];
    if (res['data'] is List) {
      List data = res['data'];
      if (data.isNotEmpty) {
        data.first['timeSlots'].forEach((v) {
          timeSlots.add(new TimeSlot.fromJson(v));
        });
      }
    }
    return timeSlots;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetFocus() async {
  Map res = await getRequest('api/v1/get-focus');
  if (res['success']) {
    List data = <FocusModel>[];
    if (res['data'] != null) {
      res['data'].forEach((v) {
        data.add(new FocusModel.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetCreateBookSession(
    Map<dynamic, dynamic> body, File? image) async {
  MultipartRequest multipartRequest =
      await getMultiPartRequest('api/v1/create-bookSession');

  List keys = body.keys.toList();
  for (var i = 0; i < keys.length; i++) {
    multipartRequest.fields[keys[i]] = body[keys[i]];
  }
  print(multipartRequest.fields);
  multipartRequest.headers.addAll(await buildTokenHeader());

  if (image != null)
    multipartRequest.files
        .add(await MultipartFile.fromPath('profilePic', image.path));

  Response response = await Response.fromStream(await multipartRequest.send());
  Map<String, dynamic> res = jsonDecode(response.body);
  if (res['success']) {
    return res['data']['_id'];
  } else {
    toast(res['message']);
  }
}

Future<dynamic> callUpdateBookSession(Map body, String id) async {
  Map res = await putRequest('api/v1/update-bookSession?id=$id', body: body);
  if (res['success']) {
    if (res['data'] != null) {
      return BookSession.fromJson(res['data']);
    }
  } else {
    return res['message'];
  }
}

Future<dynamic> callStripeTokenApi(Map body) async {
  Response response = await post(Uri.parse('https://api.stripe.com/v1/tokens'),
      headers: {'Authorization': 'Bearer $stripeSecretKey'}, body: body);
  Map data = jsonDecode(response.body);
  if (data['id'] == null) {
    toast(data['error']['message']);
  } else {
    return data['id'];
  }
}

Future<dynamic> callStripePaymentIntent(Map body) async {
  Response response = await post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {'Authorization': 'Bearer $stripeSecretKey'},
      body: body);
  Map data = jsonDecode(response.body);
  print(data);
  if (data['id'] == null) {
    toast(data['error']['message']);
  } else {
    return data['id'];
  }
}

Future<dynamic> callStripeConfirmPaymentIntent(String id, Map body) async {
  Response response = await post(
      Uri.parse('https://api.stripe.com/v1/payment_intents/$id/confirm'),
      headers: {'Authorization': 'Bearer $stripeSecretKey'},
      body: body);
  Map data = jsonDecode(response.body);
  print(data);
  if (data['id'] == null) {
    toast(data['error']['message']);
    return false;
  } else {
    return data['status'] == 'succeeded';
  }
}

Future<dynamic> callGetSessions() async {
  Map res =
      await getRequest('api/v1/get-bookSession?id=${getStringAsync(USER_ID)}');
  if (res['success']) {
    List data = <BookSession>[];
    if (res['data'] != null) {
      res['data'].forEach((v) {
        data.add(new BookSession.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callCreateReivew(Map body) async {
  Map res = await postRequest('api/v1/create-review', body: body);
  if (res['success']) {
    return true;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetMessages() async {
  Map res = await getRequest('api/v1/get-all-last-messages');
  if (res['success']) {
    List data = <MessageModel>[];
    if (res['results'] != null) {
      res['results'].forEach((v) {
        data.add(new MessageModel.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetMessagesById(String senderId) async {
  Map res = await getRequest('api/v1/get-messages-by-id?id=$senderId');
  if (res['success']) {
    List data = <MessageModel>[];
    if (res['results'] != null) {
      res['results'].forEach((v) {
        data.insert(0, new MessageModel.fromJson(v));
      });
    }
    return data;
  } else {
    return res['message'];
  }
}

Future<dynamic> callUpdateProfile(
    Map<dynamic, dynamic> body, File? image) async {
  MultipartRequest multipartRequest =
      await getMultiPartRequest('api/v1/update-profile');

  List keys = body.keys.toList();
  for (var i = 0; i < keys.length; i++) {
    multipartRequest.fields[keys[i]] = body[keys[i]];
  }

  multipartRequest.headers.addAll(await buildTokenHeader());

  if (image != null)
    multipartRequest.files
        .add(await MultipartFile.fromPath('avatar', image.path));

  Response response = await Response.fromStream(await multipartRequest.send());
  Map<String, dynamic> res = jsonDecode(response.body);
  if (res['success']) {
    // save user info
    Map data = res['data'];
    await saveUserData(data);
    return true;
  } else {
    toast(res['message']);
  }
}

bool trustSelfSigned = true;

HttpClient getHttpClient() {
  HttpClient httpClient = new HttpClient()
    ..connectionTimeout = const Duration(seconds: 10)
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);

  return httpClient;
}

callUploadMedia(File image, Function(double) onSendPresss) async {
  MultipartRequest multipartRequest =
      await getMultiPartRequest('api/v1/upload-video');

  // final httpClient = getHttpClient();
  // final request =
  //     await httpClient.postUrl(Uri.parse(mBaseUrl + 'api/v1/upload-video'));

  multipartRequest.headers.addAll(await buildTokenHeader());
  // multipartRequest.headers.forEach((key, value) {
  //   request.headers.set(key, value);
  // });

  multipartRequest.files
      .add(await MultipartFile.fromPath('mediaFiles', image.path));

  Response response = await Response.fromStream(await multipartRequest.send());
  Map<String, dynamic> res = jsonDecode(response.body);
  print(res);
  if (res['success']) {
    print(res['data']);
    return res['data'][0];
  } else {
    toast(res['message']);
  }

  // var streamRresponse = multipartRequest.finalize();
  // int _received = 0;
  // int _total = multipartRequest.contentLength;
  // print('total: $_total');
  // Stream<List<int>> streamUpload = streamRresponse.transform(
  //   new StreamTransformer.fromHandlers(
  //     handleData: (data, sink) {
  //       sink.add(data);

  //       _received = data.length;
  //       double persent = _received / _total;
  //       onSendPresss(persent);
  //     },
  //     handleError: (error, stack, sink) {
  //       throw error;
  //     },
  //     handleDone: (sink) {
  //       sink.close();
  //       // UPLOAD DONE;
  //     },
  //   ),
  // );

  // await request.addStream(streamUpload);

  // final httpResponse = await request.close();

  // var statusCode = httpResponse.statusCode;

  // if (statusCode ~/ 100 != 2) {
  //   throw Exception(
  //       'Error uploading file, Status code: ${httpResponse.statusCode}');
  // } else {
  //   String response = await readResponseAsString(httpResponse);
  //   Map<String, dynamic> res = jsonDecode(response);
  //   print(res);
  //   if (res['success']) {
  //     print(res['data']);
  //     return res['data'][0];
  //   } else {
  //     toast(res['message']);
  //   }
  // }
}

Future<String> readResponseAsString(HttpClientResponse response) {
  var completer = new Completer<String>();
  var contents = new StringBuffer();
  response.transform(utf8.decoder).listen((String data) {
    contents.write(data);
  }, onDone: () => completer.complete(contents.toString()));
  return completer.future;
}

Future<dynamic> callUpdatePassword(Map request) async {
  Map res = await postRequest('api/v1/change-password', body: request);
  if (res['success']) {
    return true;
  } else {
    return res['message'];
  }
}

Future<dynamic> callCreateCard(Map request) async {
  Map res = await postRequest('api/v1/create-card', body: request);
  if (res['success']) {
    return PaymentCard.fromJson(res['data']);
  } else {
    return res['message'];
  }
}

Future<dynamic> callUpdateCard(Map request, String id) async {
  Map res = await putRequest('api/v1/update-card?id=$id', body: request);
  if (res['success']) {
    return true;
  } else {
    return res['message'];
  }
}

Future<dynamic> callDeleteCard(String id) async {
  Map res = await deleteRequest('api/v1/delete-card?id=$id');
  if (res['success']) {
    return true;
  } else {
    return res['message'];
  }
}

Future<dynamic> callUpdateNotifications(Map request) async {
  Map res =
      await putRequest('api/v1/update-notifications-settings', body: request);
  if (res['success']) {
    return NotificationSetting.fromJson(res['data']);
  } else {
    return res['message'];
  }
}

Future<dynamic> callContactUs(Map request) async {
  Map res = await postRequest('api/v1/contact-us', body: request);
  if (res['success']) {
    return true;
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetReviews() async {
  Map res = await getRequest('api/v1/get-review');
  if (res['success']) {
    if (res['data'] != null) {
      List<ReviewModel> data = [];
      res['data'].forEach((v) {
        data.add(ReviewModel.fromJson(v));
      });
      return data;
    }
  } else {
    return res['message'];
  }
}

Future<dynamic> callGetAgoraToken(String channel, String role, int uid) async {
  Map res = await getRequest('rtc/$channel/$role/uid/$uid');
  if (res['rtcToken'] != null) {
    return res['rtcToken'];
  } else {
    if (res['message'] != null) {
      toast(res['message']);
    }
  }
}
