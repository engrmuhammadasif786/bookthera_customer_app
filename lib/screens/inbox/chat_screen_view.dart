import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bookthera_customer/components/custom_loader.dart';
import 'package:bookthera_customer/components/dots_animation.dart';
import 'package:bookthera_customer/models/MessageModel.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/dots_indicator/DotsIndicator.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/resources/Images.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/HomeConversationModel.dart';
import '../../models/MessageData.dart';
import '../../models/Provider.dart';
import '../../utils/helper.dart' as hp;
import 'FullScreenImageViewer.dart';
import 'FullScreenVideoViewer.dart';
import 'chat_provider.dart';

class ChatScreenView extends StatefulWidget {
  final String senderId;
  final String bugSuggestionType;
  const ChatScreenView({Key? key, required this.senderId,this.bugSuggestionType='normal'}) : super(key: key);

  @override
  _ChatScreenViewState createState() => _ChatScreenViewState();
}

class _ChatScreenViewState extends State<ChatScreenView> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _messageController = TextEditingController();
  bool emojiShowing = false;
  FocusNode messageFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<ChatProvider>()
          .doCallGetMessagesById(widget.senderId,widget.bugSuggestionType)
          .then((value) {
            Future.delayed(Duration(seconds: 1)).then((value) => context.read<ChatProvider>().scrollDown());
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: true);
    var size = MediaQuery.of(context).size;
    return Builder(builder: (BuildContext innerContext) {
      return GestureDetector(
        onTap: () {
          hideKeyboard(context);
          if (emojiShowing) {
            setState(() {
              emojiShowing = false;
            });
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if(chatProvider.isSubLoading || chatProvider.isLoading) Align(alignment: Alignment.topCenter, child: LinearProgressIndicator(color: colorPrimary,minHeight: 2,)),
            chatProvider.messagesByIdList.isEmpty
                ? Padding(
                    padding: getPadding(all: 8.0),
                    child: Center(
                        child: hp.showEmptyState(
                            'No Messages Yet',
                            'Send a new message and it will show '
                                'up here')),
                  )
                : ListView.builder(
                    controller: context.read<ChatProvider>().scrollController,
                    itemCount: chatProvider.messagesByIdList.length,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.12),
                    itemBuilder: (BuildContext context, int index) {
                      return buildMessage(
                          chatProvider.messagesByIdList[index], chatProvider.isTyping&& index==chatProvider.messagesByIdList.length-1);
                    }),
            bottomTextfield(context),
          ],
        ),
      );
    });
  }

  void keyboardHandling(BuildContext context) {
    if (emojiShowing) {
      setState(() {
        emojiShowing = false;
      });
      showKeyboard(context, messageFocus);
    } else {
      hideKeyboard(context);
      setState(() {
        emojiShowing = true;
      });
    }
  }

  Widget bottomTextfield(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 5,
                    spreadRadius: 2,
                    color: Colors.black.withOpacity(0.1))
              ]),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: _onCameraClick,
                icon: Image.asset(
                  'assets/icons/ic_attach.png',
                  height: 27,
                  width: 27,
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: ShapeDecoration(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(360),
                              ),
                              borderSide: BorderSide(style: BorderStyle.none)),
                          color: hp.isDarkMode(context)
                              ? Colors.grey.shade700
                              : Colors.grey.shade200,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: _messageController,
                                onTap: () {
                                  showKeyboard(context, messageFocus);
                                  setState(() {
                                    emojiShowing = false;
                                  });
                                },
                                focusNode: messageFocus,
                                onChanged: (value) {
                                  if (value.characters.length > 0) {
                                    context
                                        .read<ChatProvider>()
                                        .updateTypingStatus('1');
                                  } else {
                                    context
                                        .read<ChatProvider>()
                                        .updateTypingStatus('0');
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: textFieldFillColor,
                                  contentPadding: getPadding(top: 14,bottom: 14,left: 18,right: 18),
                                  hintText: 'Type a message',
                                  hintStyle: TextStyle(color: borderColor,fontSize: getFontSize(18),fontWeight: FontWeight.w400),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        keyboardHandling(context);
                                      },
                                      icon: Icon(
                                        !emojiShowing
                                            ? Icons.sentiment_satisfied_alt
                                            : Icons.keyboard,
                                        color: lightBlack,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(57),
                                      ),
                                      borderSide:
                                          BorderSide(style: BorderStyle.none)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(57),
                                      ),
                                      borderSide:
                                          BorderSide(style: BorderStyle.none)),
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                                maxLines: 5,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                              ),
                            ),
                          ],
                        ),
                      ))),
              Container(
                margin: EdgeInsets.only(left: 16),
                decoration:
                    BoxDecoration(color: colorPrimary, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: IconButton(
                    icon: Image.asset(
                      'assets/icons/ic_send.png',
                      height: 27,
                      width: 27,
                    ),
                    onPressed: () async {
                      if (_messageController.text.isNotEmpty) {
                        context.read<ChatProvider>().updateTypingStatus('0');
                        if (emojiShowing) {
                          setState(() {
                            emojiShowing = false;
                          });
                          showKeyboard(context, messageFocus);
                        }
                        _sendMessage(_messageController.text, null);
                        _messageController.clear();
                        context.read<ChatProvider>().checkOnlineStatus();
                        setState(() {});
                      }
                    }),
              )
            ],
          ),
        ),
        _emojiPicker()
      ],
    );
  }

  Widget buildSubTitle() {
    // String text = friend.active ? 'Active now' : 'Last seen on {}'.tr(args: ['${setLastSeen(friend.lastOnlineTimestamp.seconds)}']);
    return Text('Active now', style: TextStyle(color: Colors.grey.shade200));
  }

  _emojiPicker() {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
          height: 250,
          child: EmojiPicker(
            textEditingController: _messageController,
            config: Config(
              columns: 9,
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 32 *
                  (defaultTargetPlatform == TargetPlatform.iOS ? 1.10 : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              bgColor: Colors.white,
              indicatorColor: colorPrimary,
              iconColor: Colors.grey,
              iconColorSelected: colorPrimary,
              backspaceColor: colorPrimary,
              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              // showRecentsTab: true,
              recentsLimit: 28,
              replaceEmojiOnLimitExceed: false,
              noRecents: const Text(
                'No Recents',
                style: TextStyle(fontSize: 20, color: Colors.black26),
                textAlign: TextAlign.center,
              ),
              loadingIndicator: const SizedBox.shrink(),
              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          )),
    );
  }

  _onCameraClick() {
    ChatProvider chatProvider = context.read<ChatProvider>();
    final action = CupertinoActionSheet(
      message: Text(
        'Send media',
        style: TextStyle(fontSize: getFontSize(18)),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('Choose image from gallery',style: TextStyle(fontSize: getFontSize(18),fontWeight: FontWeight.w500),),
          isDefaultAction: false,
          onPressed: () {
            onUploadImage();
          },
        ),
        CupertinoActionSheetAction(
          child: Text('Choose video from gallery',style: TextStyle(fontSize: getFontSize(18),fontWeight: FontWeight.w500),),
          isDefaultAction: false,
          onPressed: () {
            onUploadVideo();
          },
        ),
        // CupertinoActionSheetAction(
        //   child: Text('Take a picture'),
        //   isDestructiveAction: false,
        //   onPressed: () async {
        //     Navigator.pop(context);
        //     XFile? image =
        //         await _imagePicker.pickImage(source: ImageSource.camera);
        //     if (image != null) {
        //       // Url url = await _fireStoreUtils.uploadChatImageToFireStorage(File(image.path), context);
        //       // _sendMessage('', url, '');
        //     }
        //   },
        // ),
        // CupertinoActionSheetAction(
        //   child: Text('Record video'),
        //   isDestructiveAction: false,
        //   onPressed: () async {
        //     Navigator.pop(context);
        //     XFile? recordedVideo =
        //         await _imagePicker.pickVideo(source: ImageSource.camera);
        //     if (recordedVideo != null) {
        //       // ChatVideoContainer videoContainer = await _fireStoreUtils.uploadChatVideoToFireStorage(File(recordedVideo.path), context);
        //       // _sendMessage('', videoContainer.videoUrl, videoContainer.thumbnailUrl);
        //     }
        //   },
        // )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
          style: TextStyle(fontSize: getFontSize(18),fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget buildMessage(MessageModel messageData, bool isTyping) {
    if (messageData.senderId == getStringAsync(USER_ID)) {
      return myMessageView(messageData);
    } else {
      return remoteMessageView(messageData, isTyping);
    }
  }

  Widget myMessageView(MessageModel messageData) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: _myMessageContentWidget(messageData)),
          // displayCircleImage(messageData.senderProfilePictureURL, 35, false)
        ],
      ),
    );
  }

  Widget _myMessageContentWidget(MessageModel messageData) {
    var mediaUrl = '';
    Widget doneStatus = Container();
    if (messageData.mediaFile != null) {
      if (messageData.mediaFile!.mediaType == 'image') {
        mediaUrl = messageData.mediaFile!.url!;
      } else if (messageData.mediaFile!.mediaType == 'video') {
        mediaUrl = messageData.mediaFile!.url!;
        if (messageData.mediaFile!.thumbnail != null) {
          mediaUrl = messageData.mediaFile!.thumbnail!.url!;
        }
      }
    }
    if (messageData.seen!) {
      doneStatus = Icon(
        Icons.done_all,
        size: getSize(16),
        color: colorPrimary,
      );
    } else if (messageData.delivered!) {
      doneStatus = Icon(
        Icons.done_all,
        size: getSize(16),
      );
    } else {
      doneStatus = Icon(
        Icons.done,
        size: getSize(16),
      );
    }
    if (mediaUrl.isNotEmpty) {
      return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 200,
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(alignment: Alignment.center, children: [
                    GestureDetector(
                      onTap: () {
                        if (messageData.mediaFile!.mediaType == 'image') {
                          hp.push(
                              context,
                              FullScreenImageViewer(
                                imageUrl: mediaUrl,
                              ));
                        }
                      },
                      child: Hero(
                        tag: mediaUrl,
                        child: CachedNetworkImage(
                          memCacheHeight: 200,
                          // memCacheWidth: 50,
                          imageUrl: mediaUrl,
                          placeholder: (context, url) =>
                              Image.asset('assets/images/img_placeholder'
                                  '.png'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/error_image'
                                  '.png'),
                        ),
                      ),
                    ),
                    messageData.mediaFile!.mediaType == 'video'
                        ? FloatingActionButton(
                            mini: true,
                            heroTag: messageData.id,
                            backgroundColor: colorAccent,
                            onPressed: () {
                              hp.push(
                                  context,
                                  FullScreenVideoViewer(
                                    heroTag: messageData.id!,
                                    videoUrl: messageData.mediaFile!.url!,
                                  ));
                            },
                            child: Icon(
                              Icons.play_arrow,
                              color: hp.isDarkMode(context)
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          )
                  ]),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      hp.setLastSeen(
                          messageData.sentAt!.millisecondsSinceEpoch),
                      style: TextStyle(
                          color: borderColor,
                          fontSize: getFontSize(13),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    doneStatus
                  ],
                )
              ],
            ),
          ));
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          maxWidth: 200,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          spreadRadius: 2,
                          color: Colors.black.withOpacity(0.1))
                    ]),
                child: Text(
                  mediaUrl.isEmpty ? messageData.message! : '',
                  textAlign: TextAlign.left,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: textColorPrimary,
                      fontSize: getFontSize(16),
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    hp.setLastSeen(messageData.sentAt!.millisecondsSinceEpoch),
                    style: TextStyle(
                        color: borderColor,
                        fontSize: getFontSize(13),
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  doneStatus
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  Widget remoteMessageView(MessageModel messageData, bool isTyping) {
    dynamic senderProfile = AssetImage("assets/images/placeholder.jpg");
    if (messageData.sender != null) {
      if (messageData.sender!.avatar!=null) {
        senderProfile = NetworkImage(messageData.sender!.avatar!.url!);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Stack(
              alignment: Directionality.of(context) == TextDirection.ltr
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              children: <Widget>[
                Container(
                  height: getSize(35),
                  width: getSize(35),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: senderProfile)),
                ),
                Positioned.directional(
                    textDirection: Directionality.of(context),
                    end: 1,
                    bottom: 1,
                    child: Container(
                      width: getSize(8),
                      height: getSize(8),
                      decoration: BoxDecoration(
                          // color: homeConversationModel.members.firstWhere((element) => element.userID == messageData.senderID).active
                          //     ? Colors.green
                          //     : Colors.grey,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: hp.isDarkMode(context)
                                  ? Color(0xFF303030)
                                  : Colors.white,
                              width: 1)),
                    ))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsetsDirectional.only(start: 12.0),
              child: _remoteMessageContentWidget(messageData, isTyping)),
        ],
      ),
    );
  }

  Widget _remoteMessageContentWidget(MessageModel messageData, bool isTyping) {
    var mediaUrl = '';
    if (messageData.mediaFile != null) {
      if (messageData.mediaFile!.mediaType == 'image') {
        mediaUrl = messageData.mediaFile!.url!;
      } else if (messageData.mediaFile!.mediaType == 'video') {
        if (messageData.mediaFile!.thumbnail != null) {
          mediaUrl = messageData.mediaFile!.thumbnail!.url!;
        }
      }
    }
    if (isTyping) {
      return Container(
        decoration: BoxDecoration(
            color: colorPrimary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
        child: Padding(
          padding: getPadding(all: 12.0),
          child: JumpingDots(),
        ),
      );
    }
    if (mediaUrl.isNotEmpty) {
      return ConstrainedBox(
          constraints: BoxConstraints(minWidth: 50, maxWidth: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(alignment: Alignment.center, children: [
                  GestureDetector(
                    onTap: () {
                      if (messageData.mediaFile!.mediaType == 'image') {
                        hp.push(
                            context,
                            FullScreenImageViewer(
                              imageUrl: mediaUrl,
                            ));
                      }
                    },
                    child: Hero(
                      tag: mediaUrl,
                      child: CachedNetworkImage(
                              memCacheHeight: 200,
                              // memCacheWidth: 50,
                              imageUrl: mediaUrl,
                              placeholder: (context, url) =>
                                  Image.asset('assets/images/img_placeholder'
                                      '.png'),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/images/error_image'
                                      '.png'),
                            ),
                    ),
                  ),
                  messageData.mediaFile!.mediaType == 'video'
                      ? FloatingActionButton(
                          mini: true,
                          heroTag: messageData.id,
                          backgroundColor: colorAccent,
                          onPressed: () {
                            hp.push(
                                context,
                                FullScreenVideoViewer(
                                  heroTag: messageData.id!,
                                  videoUrl: messageData.mediaFile!.url!,
                                ));
                          },
                          child: Icon(
                            Icons.play_arrow,
                            color: hp.isDarkMode(context)
                                ? Colors.black
                                : Colors.white,
                          ),
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        )
                ]),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                hp.setLastSeen(messageData.sentAt!.millisecondsSinceEpoch),
                style: TextStyle(
                    color: borderColor,
                    fontSize: getFontSize(13),
                    fontWeight: FontWeight.w400),
              ),
            ],
          ));
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 50,
          maxWidth: 200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: colorPrimary,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              child: Padding(
                padding: getPadding(all: 12.0),
                child: Text(
                  mediaUrl.isEmpty ? messageData.message! : '',
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              hp.setLastSeen(messageData.sentAt!.millisecondsSinceEpoch),
              style: TextStyle(
                  color: borderColor,
                  fontSize: getFontSize(13),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
    }
  }

  _sendMessage(String content, Map? mediaFile) async {
    ChatProvider chatProvider = context.read<ChatProvider>();
    Map data = {'payload': {}};
    data['type'] = 'send-message';
    data['payload']['receiverId'] = widget.senderId;
    data['payload']['message'] = content;
    data['payload']['bugSuggestionType'] = widget.bugSuggestionType;
    if (mediaFile != null) {
      data['payload']['mediaFile'] = mediaFile;
      if (mediaFile['mediaType'] == 'image') {
        data['payload']['message'] = '${Datamanager().firstName} sent an image';
      } else if (mediaFile['mediaType'] == 'video') {
        data['payload']['message'] = '${Datamanager().firstName} sent an video';
      }
    }
    chatProvider.channel.sink.add(jsonEncode(data));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  _onPrivateChatSettingsClick() {
    final action = CupertinoActionSheet(
      message: Text(
        'Chat settings',
        style: TextStyle(fontSize: getFontSize(15)),
      ),
      actions: <Widget>[
        // CupertinoActionSheetAction(
        //   child: Text('Block user'),
        //   onPressed: () async {
        //     Navigator.pop(context);
        //     showProgress(context, 'Blocking user...', false);
        //     bool isSuccessful = await _fireStoreUtils.blockUser(homeConversationModel.members.first, 'block');
        //     hideProgress();
        //     if (isSuccessful) {
        //       Navigator.pop(context);
        //       _showAlertDialog(
        //           context, 'Block', '{} has been blocked.'.tr(args: ['${homeConversationModel.members.first.fullName()}']));
        //     } else {
        //       _showAlertDialog(context, 'Block', 'Couldn\'t block {}'.tr(args: ['${homeConversationModel.members.first.fullName()}']));
        //     }
        //   },
        // ),
        // CupertinoActionSheetAction(
        //   child: Text('Report user'),
        //   onPressed: () async {
        //     Navigator.pop(context);
        //     showProgress(context, 'Reporting user...', false);
        //     bool isSuccessful = await _fireStoreUtils.blockUser(homeConversationModel.members.first, 'report');
        //     hideProgress();
        //     if (isSuccessful) {
        //       Navigator.pop(context);
        //       _showAlertDialog(context, 'Report',
        //           '{} has been blocked and reported.'.tr(args: ['${homeConversationModel.members.first.fullName()}']));
        //     } else {
        //       _showAlertDialog(
        //           context, 'Report', 'Couldn\'t report or block {}'.tr(args: ['${homeConversationModel.members.first.fullName()}']));
        //     }
        //   },
        // ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> onUploadVideo() async {
    Navigator.pop(context);
    XFile? galleryVideo =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (galleryVideo != null) {
      await context
          .read<ChatProvider>()
          .doCallMediaUpload(File(galleryVideo.path));
      List url = context.read<ChatProvider>().mediaFile;
      if (url.isNotEmpty) {
        _sendMessage('', url.first);
      }
    }
  }

  Future<void> onUploadImage() async {
    Navigator.pop(context);
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await context.read<ChatProvider>().doCallMediaUpload(File(image.path));
      List url = context.read<ChatProvider>().mediaFile;
      if (url.isNotEmpty) {
        _sendMessage('', url.first);
      }
    }
  }

  void showKeyboard(context, FocusNode focusNode) =>
      FocusScope.of(context).requestFocus(focusNode);
}
