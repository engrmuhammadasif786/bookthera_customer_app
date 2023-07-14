import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:bookthera_customer/screens/auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/utils/Common.dart';
import 'package:bookthera_customer/utils/Constants.dart';

import '../main.dart';


Future<Map<String, String>> buildTokenHeader({bool isPlainTextContent = false, bool aAuthRequired = true}) async {
  String token = getStringAsync(TOKEN);

  Map<String, String> header;

  if (isPlainTextContent) {
    header = {"Accept": "text/plain"};
  } else {
    header = {'Content-Type': "application/json"};
  }
  if (aAuthRequired && token.isNotEmpty) {
    header.putIfAbsent('Authorization', () => 'Bearer $token');
  }

  log(jsonEncode(header));
  return header;
}

Future<Map> postRequest(String endPoint, {Map? body, bool aAuthRequired = true}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  try {
    String url = '$mBaseUrl$endPoint';

    Map<String, String> headers = await buildTokenHeader(aAuthRequired: aAuthRequired);
    Response response = await post(Uri.parse(url), body: body == null ? null : jsonEncode(body), headers: headers).timeout(const Duration(minutes: 5));
    
    log('POST: $url');
    log('Request: $body');

    if (response.statusCode == 401) {
      await refreshToken(aReloadApp: true);
    }else if (response.body.isNotEmpty) {
      log('Status: ${response.statusCode} ${response.body}');
    } else {
      log('Status: ${response.statusCode}: null');
    }
    log('----');
    return jsonDecode(response.body);
  } on TimeoutException catch (e) {
    log("Time out Error : ${e.toString()}");
    throw timeOutMsg;
  } catch (e) {
    log('Error: $e');
    throw e;
  }
}

Future<Map> getRequest(String endPoint, {bool aAuthRequired = true}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  try {
    String url = '$mBaseUrl$endPoint';
    log('GET: $url');

    Map<String, String> headers = await buildTokenHeader(aAuthRequired: aAuthRequired);
    Response response = await get(Uri.parse(url), headers: headers).timeout(const Duration(minutes: 5));

    log('GET: $url');
    if (response.statusCode == 401) {
      await refreshToken(aReloadApp: true);
      getRequest(endPoint);
    }else if (response.body.isNotEmpty) {
      log('Status: ${response.statusCode} ${response.body}');
    } else {
      log('Status: ${response.statusCode}: null');
    }
    log('----');
    return jsonDecode(response.body);
  } on TimeoutException catch (e) {
    log("Time out Error : ${e.toString()}");
    throw timeOutMsg;
  } catch (e) {
    log('Error: $e');
    throw e;
  }
}

Future<Map> deleteRequest(String endPoint, {bool aAuthRequired = true}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  try {
    var url = '$mBaseUrl$endPoint';
    log('DELETE: $url');

    Map<String, String> headers = await buildTokenHeader(aAuthRequired: aAuthRequired);
    Response response = await delete(Uri.parse(url), headers: headers);

    log('DELETE: $url');
    if (response.statusCode == 401) {
      await refreshToken(aReloadApp: true);
      deleteRequest(endPoint);
    }else if (response.body.isNotEmpty) {
      log('Status: ${response.statusCode} ${response.body}');
    } else {
      log('Status: ${response.statusCode}: null');
    }
    log('----');
    return jsonDecode(response.body);
  } catch (e) {
    log('Error: $e');
    throw e;
  }
}

Future<Map> putRequest(String endPoint, {Map? body, bool aAuthRequired = true}) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  try {
    String url = '$mBaseUrl$endPoint';

    Map<String, String> headers = await buildTokenHeader(aAuthRequired: aAuthRequired);
    Response response = await put(Uri.parse(url), body: body == null ? null : jsonEncode(body), headers: headers).timeout(const Duration(minutes: 5));
    
    log('PUT: $url');
    log('Request: $body');

    if (response.statusCode == 401) {
      await refreshToken(aReloadApp: true);
      putRequest(endPoint);
    }else if (response.body.isNotEmpty) {
      log('Status: ${response.statusCode} ${response.body}');
    } else {
      log('Status: ${response.statusCode}: null');
    }
    log('----');
    return jsonDecode(response.body);
  } on TimeoutException catch (e) {
    log("Time out Error : ${e.toString()}");
    throw timeOutMsg;
  } catch (e) {
    log('Error: $e');
    throw e;
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint,{String? method}) async {
  String url = '$mBaseUrl$endPoint';
  return MultipartRequest(method ?? 'POST', Uri.parse(url));
}

Future sendMultiPartRequest(MultipartRequest multiPartRequest) async {
  await multiPartRequest.send().then((res) {
    log(res.statusCode);

    res.stream.transform(utf8.decoder).listen((value) {
      log(jsonDecode(value));
      return jsonDecode(value);
    });
  }).catchError((error) {
    log(error);
    throw error;
  });
}

Future<void> refreshToken({bool? aReloadApp, BuildContext? context}) async {
  log('Refreshing Token $aReloadApp');

  var request = {
    "emailUname": getStringAsync(USER_EMAIL),
    "password": getStringAsync(PASSWORD),
  };
  await callLogin(request).then((res) async {
    log('New token saved');
    if (aReloadApp != null) {
      //
    } else {
      //
    }
  }).catchError((error) {
    log(error);
    if (context != null) {
      // LoginScreen().launch(context);
    } else {
      //
    }
  });
}
