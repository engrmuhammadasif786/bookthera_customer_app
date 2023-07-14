import 'dart:isolate';

import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

class CloudRecordingManager {
  String appId = '9c3053c586514d319f2ce2519f252960';
  String bucketName = 'qavaa-bucket';
  String bucketSecretKey = 'hvtN/953sFxZCB0mMO2Bq+vxKhK2NrOTz8i8J+KX';
  String bucketAccessKey = 'GOOGXFAQCNEWX7IAPXZIBPYG';
  String customerId = '64c563cc561948bb80da4fab9289b164';
  String customerCertificate = 'e1aa680f8efe450d8afa97ede669a7bf';
  String agoraApiBaseUrl = 'https://api.agora.io/v1/apps/';

  String resourceid = "";
  String sid = "";

  Future<void> acquireCloudRecording(String channelId, String token) async {
    agoraApiBaseUrl = '${agoraApiBaseUrl}$appId/cloud_recording';
    print('________________________________________________');
    print({channelId, token});
    final apiUrl = '$agoraApiBaseUrl/acquire';
    final body =
        jsonEncode({'cname': channelId, 'uid': "1", 'clientRequest': {}});

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode("$customerId:$customerCertificate"))}',
        },
        body: body);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      resourceid = responseJson['resourceId'];
      startCloudRecording(channelId, token);
    } else {
      throw Exception('Failed to start cloud recording: ${response.body}');
    }
  }

  Future<void> startCloudRecording(String channelId, String token) async {
    if (resourceid.isNotEmpty) return;
    await acquireCloudRecording(channelId, token);
    final apiUrl = '$agoraApiBaseUrl/resourceid/$resourceid/mode/mix/start';
    print(apiUrl);
    final body = jsonEncode({
      'cname': channelId,
      'uid': "1",
      'clientRequest': {
        'token': token,
        "storageConfig": {
          "secretKey": bucketSecretKey,
          "vendor": 6,
          "region": 0,
          "bucket": bucketName,
          "accessKey": bucketAccessKey
        },
        "recordingFileConfig": {
          "avFileType": ["hls", "mp4"]
        }
      }
    });

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode("$customerId:$customerCertificate"))}',
        },
        body: body);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      sid = responseJson['sid'];
    } else {
      throw Exception('Failed to start cloud recording: ${response.body}');
    }
  }

  Future<void> stopCloudRecording(
      String channelId, String token, String sessionId) async {
    final apiUrl =
        '$agoraApiBaseUrl/resourceid/$resourceid/sid/$sid/mode/mix/stop';
    log(apiUrl);

    final response = await http.post(Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode("$customerId:$customerCertificate"))}',
        },
        body: jsonEncode({
          'cname': channelId,
          'uid': "1",
          'clientRequest': {"async_stop": false}
        }));
    if (response.statusCode == 200) {
      resourceid = '';
      sid = '';
      final responseJson = jsonDecode(response.body);
      log(responseJson);
      String? fileName;
      if (responseJson['serverResponse'] != null) {
        if (responseJson['serverResponse']['fileList'] is List) {
          (responseJson['serverResponse']['fileList'] as List)
              .forEach((element) {
            if ((element['fileName'] as String).contains('mp4')) {
              fileName = element['fileName'];
            }
          });
        }
      }
      log('Save file name: https://storage.googleapis.com/${bucketName}/${fileName}');
      if (fileName != null) {
        String fileUrl = 'https://storage.googleapis.com/${bucketName}/${fileName}';

        callUpdateBookSession({"videoRecording": fileUrl}, sessionId);
      }
    } else {
      throw Exception('Failed to stop cloud recording: ${response.body}');
    }
  }
}
