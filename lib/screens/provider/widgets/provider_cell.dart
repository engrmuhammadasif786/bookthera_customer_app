import 'dart:io';

import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/screens/provider/provider_detail.dart';
import 'package:bookthera_customer/screens/provider/provider_provider.dart';
import 'package:bookthera_customer/utils/AppWidgets.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/resources/Images.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../utils/helper.dart';

class ProviderCell extends StatefulWidget {
  const ProviderCell({super.key, this.width, required this.provider});
  final double? width;
  final ProviderModel provider;

  @override
  State<ProviderCell> createState() => _ProviderCellState();
}

class _ProviderCellState extends State<ProviderCell> {
  
  @override
  Widget build(BuildContext context) {
    bool isVideo=false;
    dynamic imageProvider;
    if (widget.provider.mediaFiles.isNotEmpty) {
       if (widget.provider.mediaFiles.first.thumbnail!=null) {
        imageProvider=widget.provider.mediaFiles.first.thumbnail!.url;
        isVideo=true;
      }else{
        imageProvider=widget.provider.mediaFiles.first.url;
      }   
    }
    return Padding(
      padding: getPadding(left: 16,right: 16,top: 8,bottom: 8),
      child: GestureDetector(
        onTap: () {
          push(context, ProviderDetail(provider: widget.provider,onBack: (isFav) {
              if(widget.provider.isFavourite!=isFav)
                setState(() {
                  widget.provider.isFavourite=isFav;   
                });
          },));
        },
        child: Container(
          width: widget.width ?? getSize(307),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(getSize(15)),
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
            mainAxisSize: MainAxisSize.min,
            children: [
                CachedNetworkImage(
                   width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  imageUrl: imageProvider??providerMediaPlaceholder,
                  placeholder: (context, url) => placeholderWidget(),
                  imageBuilder: (context,image) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        image: DecorationImage(
                            image: image,
                            fit: BoxFit.cover),
                      ),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            splashRadius: 1,
                            onPressed: () {
                              context.read<ProviderProvider>().doCallProviderLikeUnlike(widget.provider.sId!,isShowLoader: widget.provider.isFavourite!);
                              setState(() {
                                widget.provider.isFavourite=!widget.provider.isFavourite!;
                              });
                            },
                            icon: Icon(
                              Icons.favorite,
                              color:widget.provider.isFavourite!?colorPrimary:  Colors.white,
                              size: getSize(32),
                            ),
                          ),
                          if(isVideo)
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: getSize(32),
                              width: getSize(32),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white.withOpacity(0.4)),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.play_arrow,
                                color: colorPrimary,
                              ),
                            ),
                          ),
                          if(widget.provider.introSession!)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 7),
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: getSize(32),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/icons/intro_bar.png'),
                                      fit: BoxFit.contain)),
                              alignment: Alignment.center,
                              child: Text(
                                'Offers \$5 Intro Session',
                                style: TextStyle(
                                    fontFamily: "Poppinssr",
                                    color: Colors.white,
                                    fontSize: getFontSize(15),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              
              Container(
                margin: EdgeInsets.fromLTRB(15, 8, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.provider.venderName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Poppinssm",
                              letterSpacing: 0.5,
                              fontSize: getFontSize(16.8),
                              fontWeight: FontWeight.w600,
                              color: Color(0xff000000),
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.circle,
                          color:widget.provider.onlineStatus!? Color(0XFF3dae7d):Colors.grey,
                          size: getSize(13),
                        ),
                        Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: getSize(20),
                              color: Color(0xffFFB206),
                            ),
                            SizedBox(width: 3),
                            Text(
                                widget.provider.reviewsCount != 0
                                    ? '${(widget.provider.reviewsSum! / widget.provider.reviewsCount!).toStringAsFixed(1)}'
                                    : 0.toString(),
                                style: TextStyle(
                                  fontFamily: "Poppinssr",
                                  letterSpacing: 0.5,
                                  fontSize: getFontSize(13.6),
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff000000),
                                )),
                            SizedBox(width: 3),
                            Text(
                                '(${widget.provider.reviewsCount!.toStringAsFixed(1)})',
                                style: TextStyle(
                                  fontFamily: "Poppinssr",
                                  letterSpacing: 0.5,
                                  fontSize: getFontSize(13.6),
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff666666),
                                )),
                          ],
                        ),
                      ],
                    ),
                    if(widget.provider.tagLine!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(widget.provider.tagLine!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: "Poppinssr",
                                fontSize: getFontSize(14),
                                fontWeight: FontWeight.w400,
                                color: Color(0xff555353),
                              )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(widget.provider.isVideoSession!)
                          Icon(
                            Icons.videocam,
                            size: getSize(20),
                            color: colorPrimary,
                          ),
                          SizedBox(width: 3),
                          if(widget.provider.isVideoSession!)
                          Text('Video',
                              style: TextStyle(
                                fontFamily: "Poppinssr",
                                letterSpacing: 0.5,
                                fontSize: getFontSize(10.48),
                                fontWeight: FontWeight.w500,
                                color: colorPrimary,
                              )),
                          SizedBox(width: 14),
                          if(widget.provider.isAudioSession!)
                          Icon(
                            Icons.mic,
                            size: getSize(20),
                            color: colorPrimary,
                          ),
                          SizedBox(width: 3),
                          if(widget.provider.isAudioSession!)
                          Text('Audio',
                              style: TextStyle(
                                fontFamily: "Poppinssr",
                                letterSpacing: 0.5,
                                fontSize: getFontSize(10.48),
                                fontWeight: FontWeight.w500,
                                color: colorPrimary,
                              )),
                          Spacer(),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Starting from ",
                              style: TextStyle(
                                fontSize: getFontSize(12),
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                              children: [
                                TextSpan(
                                  text: "\$${widget.provider.startFromPrice}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: getFontSize(14)),
                                ),
                              ],
                            ),
                          ),
                        
                        ],
                      ),
                    )
                  
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  
  }
}
