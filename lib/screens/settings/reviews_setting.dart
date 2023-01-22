import 'package:bookthera_customer_1/components/custom_appbar.dart';
import 'package:bookthera_customer_1/components/custom_loader.dart';
import 'package:bookthera_customer_1/components/custom_readmore.dart';
import 'package:bookthera_customer_1/screens/provider/widgets/search_field.dart';
import 'package:bookthera_customer_1/screens/settings/setting_provider.dart';
import 'package:bookthera_customer_1/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../models/reviewModel.dart';
import '../../utils/helper.dart';
import '../../utils/resources/Colors.dart';

class ReviewsSetting extends StatefulWidget {
  const ReviewsSetting({super.key});

  @override
  State<ReviewsSetting> createState() => _ReviewsSettingState();
}

class _ReviewsSettingState extends State<ReviewsSetting> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {context.read<SettingProvider>().doCallGetReviews();});
  }

  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider=context.watch<SettingProvider>();
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Reviews',
      ),
      body:CustomLoader(
        isLoading: settingProvider.isLoading,
        child: Column(children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16),
          //   child: CustomSearchField(isShowFavourite: false,isFilter: false,
          //   onSearchTap: () {
              
          //   },
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 16),
                        itemCount: settingProvider.reviewsList.length,
                        itemBuilder: (context, index) {
                          return ReviewsSettingCell(reviewModel: settingProvider.reviewsList[index],);
                        }),
          ),
        ],),
      ),
    );
  }
}

class ReviewsSettingCell extends StatelessWidget {
  const ReviewsSettingCell(
      {super.key,required this.reviewModel });
  final ReviewModel reviewModel;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var uname = '';
    var fname = '';
    var lname = '';
    dynamic profile = AssetImage("assets/images/placeholder.jpg");

    if (reviewModel.reviewToData != null) {
      uname = reviewModel.reviewToData!.venderName!;
      fname = reviewModel.reviewToData!.venderFirstName!;
      lname = reviewModel.reviewToData!.venderLastName!;
      if (reviewModel.reviewToData!.venderProfile!=null) {
        profile = NetworkImage(reviewModel.reviewToData!.venderProfile!);  
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
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
            Row(
              children: [
                Container(
                  height: 68,
                  width: 68,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image:
                              profile)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$fname $lname',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              )),
                          Spacer(),
                          Text(
                            setLastSeen(reviewModel.createdAt!.millisecondsSinceEpoch,dateFormat: defaultDateFormat),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: borderColor,
                                fontSize: 12),
                          ),
                          ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(uname,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: textColorPrimary)),
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                              initialRating: 4,
                              minRating: 1,
                              direction: Axis.horizontal,
                              unratedColor: Colors.grey.withOpacity(0.5),
                              itemSize: 14,
                              itemPadding: EdgeInsets.only(right: 2.0),
                              itemBuilder: (context, number) => Icon(
                                Icons.star,
                                color: Color(0xFFF98600),
                              ),
                              onRatingUpdate: (rating) {
                                // contentRating=rating.toStringAsFixed(0);
                              },
                            ),
                            Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(reviewModel.stars!,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    )),
                      )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text('Public',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColorPrimary)),
            SizedBox(
              height: 10,
            ),
            CustomReadmore(text: reviewModel.publicReview!),
            SizedBox(
              height: 15,
            ),
            Text('Private',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColorPrimary)),
                
            SizedBox(
              height: 10,
            ),
            CustomReadmore(text: reviewModel.privateReview!),
            ],
        ),
      ),
    );
  }
}
