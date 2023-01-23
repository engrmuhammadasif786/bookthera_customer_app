import 'package:bookthera_customer/components/custom_readmore.dart';
import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/models/book_sessoin.dart';
import 'package:bookthera_customer/screens/sessions/audioVideosCalls/call.dart';
import 'package:bookthera_customer/screens/provider/book_session/book_session_main.dart';
import 'package:bookthera_customer/screens/provider/provider_detail.dart';
import 'package:bookthera_customer/screens/provider/widgets/sessions_button.dart';
import 'package:bookthera_customer/screens/sessions/session_provider.dart';
import 'package:bookthera_customer/screens/sessions/widgets/edit_session.dart';
import 'package:bookthera_customer/screens/sessions/widgets/rate_sheet.dart';
import 'package:bookthera_customer/screens/sessions/widgets/report_no_show.dart';
import 'package:bookthera_customer/screens/sessions/widgets/session_cancel_sheet.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../utils/helper.dart';

enum SessionTabConst { Upcoming, Completed, Cancelled }

class SessionCell extends StatelessWidget {
  SessionCell({super.key, required this.bookSession});
  final BookSession bookSession;
  SessionTabConst sessionTabConst = SessionTabConst.Upcoming;
  @override
  Widget build(BuildContext context) {
    switch (bookSession.status) {
      case 'completed':
        sessionTabConst = SessionTabConst.Completed;
        break;
      case 'cancelled':
        sessionTabConst = SessionTabConst.Cancelled;
        break;
      default:
        sessionTabConst = SessionTabConst.Upcoming;
        break;
    }
    var size = MediaQuery.of(context).size;
    var uname = '';
    var fname = '';
    var lname = '';
    bool isVideo = false;
    bool isAudio = false;
    var sessionName = '';
    var sessionDes = '';
    String date;
    dynamic profile = AssetImage("assets/images/placeholder.jpg");

    if (bookSession.providerData != null) {
      uname = bookSession.providerData!.uname!;
      fname = bookSession.providerData!.fname!.characters.first + '.';
      lname = bookSession.providerData!.lname!;
      if (bookSession.providerData!.avatar != null) {
        profile = NetworkImage(bookSession.providerData!.avatar!.url!);
      }
    }

    if (bookSession.type == 'video') {
      isVideo = true;
    } else {
      isAudio = true;
    }

    if (bookSession.sessionData != null) {
      sessionName = bookSession.sessionData!.name!;
      sessionDes = bookSession.sessionData!.description!;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  isDarkMode(context)
                      ? BoxShadow()
                      : BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.0,
                          spreadRadius: 2,
                          offset: Offset(1, 1),
                        ),
                ],
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sessionTabConst != SessionTabConst.Completed)
                  SizedBox(
                    height: 46,
                  )
                else
                  SizedBox(
                    height: 8,
                  ),
                Row(
                  children: [
                    Container(
                      height: 65,
                      width: 65,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: profile)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(uname,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                              Icon(
                                isAudio ? Icons.mic : Icons.videocam,
                                size: 20,
                                color: colorPrimary,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                isVideo ? "Video Call" : "Audio Call",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: colorPrimary,
                                    fontSize: 13),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              if (sessionTabConst == SessionTabConst.Upcoming)
                                GestureDetector(
                                  onTap: () {
                                    onEdit(context);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: colorPrimary,
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 18,
                                  color: borderColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('$lname ${fname}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: textColorPrimary)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 18,
                                color: borderColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(bookSession.date!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textColorPrimary)),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                Icons.schedule,
                                size: 18,
                                color: borderColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(bookSession.time!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: textColorPrimary)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(sessionName,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColorPrimary)),
                SizedBox(
                  height: 10,
                ),
                CustomReadmore(
                  text: sessionDes,
                  fontsize: 13,
                  fontWeight: FontWeight.w400,
                  color: borderColor,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text('Intentions',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColorPrimary)),
                    SizedBox(
                      width: 5,
                    ),
                    if (sessionTabConst == SessionTabConst.Upcoming)
                      GestureDetector(
                        onTap: () {
                          onEdit(context);
                        },
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: colorPrimary,
                        ),
                      )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(bookSession.intensions!,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: borderColor)),
                if (sessionTabConst == SessionTabConst.Upcoming)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: SessionButton(
                                isOutlined: true,
                                title: 'Cancel',
                                onPressed: () {
                                  onCancel(context);
                                })),
                        SizedBox(
                          width: 11,
                        ),
                        Expanded(
                            flex: 2,
                            child: SessionButton(
                                title: 'Join session',
                                onPressed: () {
                                  push(
                                      context,
                                      AudioVideoScreen(
                                        channelName: bookSession.channelName!,
                                      ));
                                })),
                      ],
                    ),
                  )
                else if (sessionTabConst == SessionTabConst.Completed)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        push(
                            context,
                            RateSheet(
                              providerId: bookSession.providerId!,
                            ));
                      },
                      child: Text(
                        'Leave a Review!',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                            color: colorPrimary,
                            fontSize: 15),
                      ),
                    ),
                  ),
                if (sessionTabConst == SessionTabConst.Cancelled)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text('Cancellation Reason',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorPrimary)),
                      SizedBox(
                        height: 10,
                      ),
                      CustomReadmore(text: bookSession.cancellationReasion!),
                    ],
                  )
              ],
            ),
          ),
          if (sessionTabConst != SessionTabConst.Completed)
            Row(
              children: [
                Container(
                  width: size.width * 0.55,
                  height: 30,
                  margin: EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/session_bar.png'))),
                  alignment: Alignment.center,
                  child: Text('No Show reported by provider!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                if (sessionTabConst == SessionTabConst.Cancelled)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.block,
                                size: 14,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Cancelled by',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: borderColor,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          Text('Provider',
                              style: TextStyle(
                                fontSize: 13,
                                color: colorPrimary,
                                fontWeight: FontWeight.w600,
                              ))
                        ],
                      ),
                    ),
                  )
              ],
            ),
        ],
      ),
    );
  }

  void onEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return EditSession(
          intensions: bookSession.intensions!,
        );
      },
    ).then((value) {
      if (value is Map) {
        context
            .read<SessionProvider>()
            .doCallUpdateBookSession(value, bookSession.sId!);
      }
    });
  }

  void onCancel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (context) {
        return SessionCancelSheet();
      },
    ).then((value) {
      if (value is Map) {
        context
            .read<SessionProvider>()
            .doCallUpdateBookSession(value, bookSession.sId!, isCancel: true);
      }
    });
  }
}
