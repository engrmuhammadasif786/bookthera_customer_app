import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookthera_customer/models/MessageModel.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/Provider.dart';
import '../../utils/Constants.dart';

class ChatProvider with ChangeNotifier {
  bool isLoading = false;
  bool isSubLoading = false;
  List<MessageModel> messagesList = [];
  List<MessageModel> messagesByIdList = [];
  late WebSocketChannel channel;
  ScrollController scrollController = ScrollController();
  List mediaFile=[];
  List onlineUsers = [];
  String receiverId = '';
  bool isTyping = false;
  bool isReceiverOnline = false;
  bool isViewChat = true;
  bool isViewFeedback = true;
  String lastSeen = '';
  Timer? timer;
  double persent=0.0;
  int filter1Index=0;
  setLoader(bool status) {
    isLoading = status;
    notifyListeners();
  }

  updateFilterIndex(value){
    filter1Index=value;
  }

  setSubLoader(bool status) {
    isSubLoading = status;
    notifyListeners();
  }

  updateViewChat(bool status) {
    isViewChat = status;
    notifyListeners();
  }

  updateViewFeedback(bool status) {
    isViewFeedback = status;
    notifyListeners();
  }

  void connectSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse(socketUrl + "?token=${getStringAsync(TOKEN)}"),
    );
    channel.stream.listen(
      (event) {
        dynamic body = jsonDecode(event);
        print(body);
        switch (body['type']) {
          case 'connection':
            break;
          case 'onlineUsers':
            onlineUsers = body['data'];
            
            break;
          case 'onlineStatus':
            Map data = body['data'];
            String userId = data['userId'];
            if (userId == receiverId) {
              if (data['status'] == 'online') {
                isReceiverOnline = true;
              } else {
                lastSeen = data['lastSeen'];
                isReceiverOnline = false;
              }
            }
            messagesList.forEach((element) {
              String otherUser = element.senderId != getStringAsync(USER_ID)
                  ? element.senderId!
                  : element.receiverId!;
              if (userId == otherUser) {
                element.isUserOnline = true;
              } else {
                element.isUserOnline = false;
              }
            });
            notifyListeners();
            break;
          case 'messageTyping':
            Map data = body['data'];
            getTypingStatus(data['senderId'], data['status']);
            break;
          case 'message':
            if (body['success']) {
              MessageModel newMessage = MessageModel.fromJson(body['data']);
              int index = messagesByIdList
                  .indexWhere((element) => element.id == newMessage.id);
              if (index != -1) {
                messagesByIdList[index] = newMessage;
              } else {
                messagesByIdList.add(newMessage);
                if (!newMessage.seen!) {
                  setSeenStatus();
                }
                scrollDown();
              }

              index = messagesList.indexWhere((element) =>
                  element.senderId == receiverId ||
                  element.receiverId == receiverId);
              if (index != -1) {
                messagesList[index] = messagesByIdList.last;
              }

              // if (newMessage.senderId != getStringAsync(USER_ID) && !isViewChat) {
              //   if (!newMessage.seen!) {
              //     messagesList.add(newMessage);
              //   }
              // }
              index = messagesList.indexWhere((element) => element.senderId==newMessage.senderId,);
              if (index==-1) {
                messagesList.add(newMessage);
              }else{
                messagesList[index]=newMessage;
              }
              notifyListeners();
            }
            break;
          case 'error':
            // toast(body['message']);
            log(body['message']);
            break;
          default:
        }
      },
      onDone: () {
        connectSocket();
      },
    );
    getUndeliveredMessages();
    getOnlineUser();
  }

  // undeliverd messages
  getUndeliveredMessages() {
    Map payload = {};
    payload['type'] = 'get-undelivered-messages';
    channel.sink.add(jsonEncode(payload));
  }

  // get users who are online
  isUserOnline(String userId) {
    print({userId,onlineUsers});
    return onlineUsers.contains(userId);
  }

  // get online users after get response update local user status
  getOnlineUser() {
    Map payload = {};
    payload['type'] = 'get-online-users';
    channel.sink.add(jsonEncode(payload));
  }

  // update last seen message
  setSeenStatus() {
    messagesByIdList.forEach((element) {
      if (element.senderId != getStringAsync(USER_ID)) {
        if (!element.seen!) {
          Map payload = {
            'type': "read-message",
            'payload': {'messageId': element.id}
          };
          channel.sink.add(jsonEncode(payload));
        }
      }
    });
  }

  // check if the user is online
  checkOnlineStatus({List? usersList}) {
    print(usersList);
    Map data = {'payload': {}};
    data['type'] = 'check-online-users';
    data['payload']['userIds'] = usersList ?? [receiverId];
    channel.sink.add(jsonEncode(data));
  }

  // update typing status
  updateTypingStatus(String status) {
    Map data = {"payload": {}};
    data['type'] = 'message-typing';
    data['payload']['receiverId'] = receiverId;
    data['payload']['status'] = status;
    channel.sink.add(jsonEncode(data));
  }

  // get typing status
  getTypingStatus(String senderId, String status) {
    if (senderId == receiverId) {
      if (status == '1') {
        isTyping = true;
      } else {
        isTyping = false;
      }
      notifyListeners();
    }
  }

  void sortMessage({String date = "-1"}) {
  bool ascending = date == "-1";

  messagesList.sort((a, b) {
    if (ascending) {
      return a.createdAt!.isAfter(b.createdAt!) ? -1 : 1;
    } else {
      return b.createdAt!.isAfter(a.createdAt!) ? -1 : 1;
    }
  });
  notifyListeners();
}

  doCallGetMessages() {
    setLoader(true);
    callGetMessages().then((value) {
      if (value is String) {
        toast(value);
      } else if (value is List<MessageModel>) {
        messagesList = value;
      }
      homeUsersStatusChecker();
      setLoader(false);
    });
  }

  void homeUsersStatusChecker() {
    timer=Timer.periodic(Duration(seconds: 3), (timer) {
      List usersList = [];
      messagesList.forEach((element) {
        if (element.senderId != getStringAsync(USER_ID)) {
          usersList.add(element.senderId);
        } else {
          usersList.add(element.receiverId);
        }
      });
      if (usersList.isNotEmpty) {
        checkOnlineStatus(usersList: usersList);
      }
    });  
    
  }

  cancelTimer(){
    if (timer!=null) {
      timer!.cancel();
    }
  }

  Future<void> doCallGetMessagesById(String? senderId,String bugSuggestionType)async {
    receiverId = senderId??getStringAsync(USER_ID);
    setLoader(true);
    await callGetMessagesById(receiverId).then((value) {
      if (value is String) {
        return toast(value);
      } else if (value is List<MessageModel>) {
        switch (bugSuggestionType) {
          case 'bug':
            messagesByIdList = value.where((element) => element.bugSuggestionType=='bug').toList();
            break;
          case 'suggestion':
            messagesByIdList = value.where((element) => element.bugSuggestionType=='suggestion').toList();
            break;
          default:
            messagesByIdList = value;
        }
      }
      setSeenStatus(); // read message status update
      checkOnlineStatus(); // check whether receiver is online
      setLoader(false);
    });
  }

  Future<dynamic> doCallMediaUpload(File file) async {
    setSubLoader(true);
    await callUploadMedia(file,(value){
      print(value);
      persent=value;
      notifyListeners();
    }).then((value) async {
      mediaFile.clear();
      mediaFile.add(value);
      setSubLoader(false);
    });
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent +
            scrollController.position.maxScrollExtent * 0.1,
        duration: Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  doCallCreateTicket(Map body){
    setLoader(true);
    callCreateTicket(body).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      }
    });
  }
}
