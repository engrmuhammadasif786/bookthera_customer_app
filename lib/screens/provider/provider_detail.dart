import 'dart:io';

import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/screens/auth/LoginScreen.dart';
import 'package:bookthera_customer/screens/inbox/FullScreenVideoViewer.dart';
import 'package:bookthera_customer/screens/provider/provider_provider.dart';
import 'package:bookthera_customer/screens/provider/sessions_tab.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/resources/Images.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../utils/helper.dart';
import '../inbox/chat_screen.dart';
import 'review_tab.dart';
import 'about_me.dart';

class ProviderDetail extends StatefulWidget {
  ProviderDetail({super.key,this.providerId,this.fromDynamicLink=false, this.provider,this.onBack});
  ProviderModel? provider;
  String? providerId;
  bool fromDynamicLink;
  Function(bool)? onBack;

  @override
  State<ProviderDetail> createState() => _ProviderDetailState();
}

class _ProviderDetailState extends State<ProviderDetail> {
  bool fav = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if(widget.provider!=null){
        fav=widget.provider!.isFavourite!;
      }
      context
          .read<ProviderProvider>()
          .doCallGetProviderById(widget.providerId ?? widget.provider!.sId!,fromDynamicLink: widget.fromDynamicLink).then((value) {
            setState(() {
              widget.provider=value;
              fav=widget.provider!.isFavourite??false;
            });
          });    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.provider==null){
      return Material(
        child: Center(child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colorPrimary,
        ),),
      );
    }
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    ProviderProvider provider=context.watch<ProviderProvider>();
    dynamic imageProvider;
    bool isVideo = false;
    String videoTag = '';
    dynamic profileImage;
    String videoUrl = '';
    if (widget.provider!.mediaFiles.isNotEmpty) {
      if (widget.provider!.mediaFiles.first.thumbnail != null) {
        imageProvider = widget.provider!.mediaFiles.first.thumbnail!.url;
        isVideo = true;
        videoTag = widget.provider!.mediaFiles.first.publicId!;
        videoUrl = widget.provider!.venderProfile!.url!;
      } else {
        imageProvider = widget.provider!.mediaFiles.first.url;
      }
    }
    if (widget.provider!.venderProfile != null) {
      if (imageProvider==null) {
        imageProvider=widget.provider!.venderProfile!.url!;
      }
      profileImage = NetworkImage(widget.provider!.venderProfile!.url!);
    } else {
      if (imageProvider==null) {
        imageProvider=providerMediaPlaceholder;
      }
      profileImage = AssetImage("assets/images/placeholder.jpg");
    }
    var onDynamicLink = nb.getStringAsync(TOKEN)==''? (){
      return push(context, LoginScreen(isBackButton: true,));  
    }:null;
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          body: Stack(children: [
            Hero(
              tag: videoTag,
              child: GestureDetector(
                onTap: () {
                  if (videoUrl.isNotEmpty) {
                    push(
                        context,
                        FullScreenVideoViewer(
                            videoUrl: widget.provider!.mediaFiles.first.url!,
                            heroTag: videoTag));
                  }
                },
                child: Container(
                    height: getSize(338),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageProvider??sampleImage),
                          fit: BoxFit.cover),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.white38,
                            blurRadius: 25.0,
                            offset: Offset(0.0, 0.75))
                      ],
                    ),
                    width: _width * 1,
                    alignment: Alignment.center,
                    child: isVideo
                        ? Container(
                            height: getSize(64),
                            width: getSize(64),
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.4)),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.play_arrow,
                              color: colorPrimary,
                              size: getSize(44),
                            ),
                          )
                        : null),
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                  // top: _height * 0.033,
                  // left: _width * 0.03,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: getMargin(top: kToolbarHeight/1.3,left: 16),
                        padding: getPadding(all: 8),
                        child: Image.asset(
                          'assets/images/arrow_back.png',
                          height: 33,
                          width: 33,
                          // color: imageProvider==null?colorPrimary:null,
                        ),
                      ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                height: _height * 0.69,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30))),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 41,
                                width: 41,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image:
                                        DecorationImage(image: profileImage,fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Text(widget.provider!.venderName!,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color: isDarkMode(context)
                                                    ? Color(0xffFFFFFF)
                                                    : Color(0xff2A2A2A))),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.circle,
                                          color: widget.provider!.onlineStatus!
                                              ? Color(0XFF3dae7d)
                                              : Colors.grey,
                                          size: 13,
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 20,
                                              color: Color(0xffFFB206),
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                                widget.provider!.reviewsCount != 0
                                                    ? '${(widget.provider!.reviewsSum! / widget.provider!.reviewsCount!).toStringAsFixed(1)}'
                                                    : 0.toString(),
                                                style: TextStyle(
                                                  fontFamily: "Poppinssr",
                                                  letterSpacing: 0.5,
                                                  color: Color(0xff000000),
                                                )),
                                            SizedBox(width: 3),
                                            Text(
                                                '(${widget.provider!.reviewsCount!.toStringAsFixed(1)})',
                                                style: TextStyle(
                                                  fontFamily: "Poppinssr",
                                                  letterSpacing: 0.5,
                                                  color: Color(0xff666666),
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 230),
                                        child: Text(
                                          widget.provider!.tagLine!,
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontFamily: "Poppinsr",
                                              letterSpacing: 0.5,
                                              color: Color(0xff313131)),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                            Row(
                              children: [
                                  IconButton(
                                  splashColor: Colors.transparent,
                                  splashRadius: 1,
                                  onPressed: () {
                                    if(onDynamicLink!=null) onDynamicLink(); else 
                                    {
                                      context.read<ProviderProvider>().doCallProviderLikeUnlike(widget.provider!.sId!);
                                      setState(() {
                                        fav=!fav;
                                      });
                                      if(widget.onBack!=null) widget.onBack!(fav);
                                    }
                                  },
                                  icon: Icon(
                                    fav? Icons.favorite:Icons.favorite_outline,
                                    color:colorPrimary,
                                    size: getSize(32),
                                  ),
                                ),
                                if (widget.provider!.introSession!)
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: 32,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icons/intro_bar.png'),
                                          fit: BoxFit.contain)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Offers \$${widget.provider!.introPrice} Intro Session',
                                    style: TextStyle(
                                        fontFamily: "Poppinssr",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                    
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color(0xFFADB3BC).withOpacity(0.4),
                                  width: 5.0),
                            ),
                          ),
                        ),
                        TabBar(
                            indicatorColor: colorPrimary,
                            indicatorWeight: 5,
                            labelColor: colorPrimary,
                            unselectedLabelColor: Color(0xFFADB3BC),
                            labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Poppinsr'),
                            unselectedLabelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppinsr'),
                            labelPadding:
                                EdgeInsets.only(right: 20, left: 20),
                            tabs: [
                              Tab(
                                child: Text(
                                  'Services',
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'About',
                                ),
                              ),
                              Tab(
                                child: Text(
                                  'Reviews',
                                ),
                              )
                            ]),
                      ],
                    ),
                    if(context.watch<ProviderProvider>().isLoading) LinearProgressIndicator(color: colorPrimary,minHeight: 2,),
                    Expanded(
                      child: TabBarView(children: [
                        SessionsTab(providerModel: widget.provider!,onAction: onDynamicLink),
                        AboutMeTab(
                          providerModel: widget.provider!,
                        ),
                        ReviewsTab(
                          providerModel: widget.provider!,
                        )
                      ]),
                    )
                  ],
                ),
              ),
            )
          ]),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            extendedPadding: getPadding(left: 10,right: 12),
            onPressed: (){
              if(onDynamicLink!=null) onDynamicLink(); else push(context, ChatScreen(senderId: widget.provider!.owner!, senderName: widget.provider!.venderName!));
              
          }, label: Text('Chat'),icon: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                      height: getSize(30),
                      width: getSize(30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image:
                              DecorationImage(image: profileImage,fit: BoxFit.cover)),
                    ),
              Icon(
                  Icons.circle,
                  color: widget.provider!.onlineStatus!
                      ? Color(0XFF3dae7d)
                      : Colors.grey,
                  size: 13,
                )
            ],
          ),),
        ));
  }
}
