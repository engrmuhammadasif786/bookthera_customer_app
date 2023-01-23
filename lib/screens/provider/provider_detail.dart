import 'dart:io';

import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/screens/inbox/FullScreenVideoViewer.dart';
import 'package:bookthera_customer/screens/provider/provider_provider.dart';
import 'package:bookthera_customer/screens/provider/sessions_tab.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/resources/Images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../utils/helper.dart';
import 'review_tab.dart';
import 'about_me.dart';

class ProviderDetail extends StatefulWidget {
   ProviderDetail({super.key,required this.provider});
  ProviderModel provider;

  @override
  State<ProviderDetail> createState() => _ProviderDetailState();
}

class _ProviderDetailState extends State<ProviderDetail> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {context.read<ProviderProvider>().doCallGetProviderById(widget.provider.sId!).then((value) {
      widget.provider=value;
    });});
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    dynamic imageProvider;
    bool isVideo=false;
    if (widget.provider.mediaFiles.first.thumbnail!=null) {
      imageProvider=widget.provider.mediaFiles.first.thumbnail!.url;
      isVideo=true;
    }else{
      imageProvider=widget.provider.mediaFiles.first.url;
    }
    dynamic profileImage = widget.provider.venderProfile!.url!.isNotEmpty?NetworkImage(widget.provider.venderProfile!.url!) :AssetImage(
                                            "assets/images/placeholder.jpg");
    String videoTag = widget.provider.mediaFiles.first.publicId!;
    String videoUrl = widget.provider.venderProfile!.url!;
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
                  push(context, FullScreenVideoViewer(videoUrl: widget.provider.mediaFiles.first.url!, heroTag: videoTag));  
                  }
                },
                child: Container(
                    height: _height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(imageProvider),fit: BoxFit.cover),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.white38,
                            blurRadius: 25.0,
                            offset: Offset(0.0, 0.75))
                      ],
                    ),
                    width: _width * 1,
                    alignment: Alignment.center,
                    child: isVideo? Container(
                          height: 32,
                          width: 32,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white.withOpacity(0.4)),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_arrow,
                            color: colorPrimary,
                          ),
                        ):null),
              ),
            ),
            Positioned(
                top: _height * 0.033,
                left: _width * 0.03,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/arrow_back.png',
                        height: 33,
                        width: 33,
                      ),
                    ))),
            Positioned(
              top: _height * 0.033,
              right: _width * 0.03,
              child: IconButton(
                onPressed: () {
                  context.read<ProviderProvider>().doCallProviderLikeUnlike(widget.provider.sId!,isShowLoader: widget.provider.isFavourite!);
                  setState(() {
                    widget.provider.isFavourite=!widget.provider.isFavourite!;
                  });
                },
                icon: Icon(
                  Icons.favorite,
                  color:widget.provider.isFavourite!?colorPrimary:  Colors.white,
                  size: 32,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                height: _height * 0.74,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
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
                                    image: DecorationImage(
                                        image:profileImage )),
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
                                        Text(widget.provider.venderName!,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color: isDarkMode(context)
                                                    ? Color(0xffFFFFFF)
                                                    : Color(0xff2A2A2A))),
                                        SizedBox(width: 8,),
                                        Icon(
                                          Icons.circle,
                                          color:widget.provider.onlineStatus=='1'? Color(0XFF3dae7d):Colors.grey,
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
                                                widget.provider
                                                            .reviewsCount !=
                                                        0
                                                    ? '${(widget.provider.reviewsSum! / widget.provider.reviewsCount!).toStringAsFixed(1)}'
                                                    : 0.toString(),
                                                style: TextStyle(
                                                  fontFamily: "Poppinssr",
                                                  letterSpacing: 0.5,
                                                  color: Color(0xff000000),
                                                )),
                                            SizedBox(width: 3),
                                            Text(
                                                '(${widget.provider.reviewsCount!.toStringAsFixed(1)})',
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
                                          widget.provider.tagLine!,
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontFamily: "Poppinsr",
                                              letterSpacing: 0.5,
                                              color: Color(0xFF9091A4)),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if(widget.provider.introSession!)
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
                              'Offers \$${widget.provider.introPrice} Intro Session',
                              style: TextStyle(
                                  fontFamily: "Poppinssr",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
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
                                  color: Color(0xff9394a1).withOpacity(0.4),
                                  width: 5.0),
                            ),
                          ),
                        ),
                        TabBar(
                            indicatorColor: colorPrimary,
                            indicatorWeight: 5,
                            labelColor: colorPrimary,
                            unselectedLabelColor: Color(0xff9394a1),
                            labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Poppinsr'),
                            unselectedLabelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppinsr'),
                            labelPadding: EdgeInsets.only(right: 20, left: 20),
                            tabs: [
                              Tab(
                                child: Text(
                                  'Sessions',
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
                    Expanded(
                      child: CustomLoader(
                        isLoading: context.watch<ProviderProvider>().isLoading,
                        child: TabBarView(children: [
                          SessionsTab(providerModel: widget.provider),
                          AboutMeTab(providerModel: widget.provider,),
                          ReviewsTab(providerModel: widget.provider,)
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
