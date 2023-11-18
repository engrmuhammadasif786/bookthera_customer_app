import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_loader.dart';
import '../../../components/custom_textfields.dart';
import '../../../utils/resources/Colors.dart';
import '../session_provider.dart';

class RateSheet extends StatelessWidget {
  RateSheet({super.key,required this.userId,required this.sessionId});
  String userId;
  String sessionId;
  TextEditingController publicFeedback = TextEditingController();
  TextEditingController privateFeedback = TextEditingController();
  String contentRating='';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(title: 'Rate',),
      body: CustomLoader(
        isLoading: context.watch<SessionProvider>().isLoading,
        child: Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 5,
                    spreadRadius: 2,
                    color: Colors.black.withOpacity(0.1))
              ]),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Rate your Customer!',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: getFontSize(20)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 22),
                  child: Align(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      unratedColor: Colors.grey.withOpacity(0.5),
                      itemSize: getSize(41),
                      itemPadding: EdgeInsets.only(right: 4.0),
                      itemBuilder: (context, number) => Icon(
                        Icons.star,
                        color: Color(0xFFFFB206),
                      ),
                      onRatingUpdate: (rating) {
                        contentRating=rating.toStringAsFixed(0);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(top: 30.0, bottom: 24),
                  child: Divider(
                    color: Color(0xffD9D9D9),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: getPadding(bottom: 11.0, top: 8),
                  child: Text('Public Feedback',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(13),
                          color: textColorPrimary)),
                ),
                Padding(
                  padding: getPadding(bottom: 8.0),
                  child: CustomTextField(
                    textEditingController: publicFeedback,
                    maxLines: 5,
                    hint: 'Your Feedback (Optional)',
                  ),
                ),
                Padding(
                  padding: getPadding(top: 30.0, bottom: 24),
                  child: Divider(
                    color: Color(0xffD9D9D9),
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: getPadding(bottom: 11.0, top: 8),
                  child: Text('Anything that would make the experience better\n(private)',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(13),
                          color: textColorPrimary)),
                ),
                Padding(
                  padding: getPadding(bottom: 8.0),
                  child: CustomTextField(
                    textEditingController: privateFeedback,
                    maxLines: 5,
                    hint: 'Your Feedback (Optional)',
                  ),
                ),
                Padding(
                  padding: getPadding(top: 75.0),
                  child: SizedBox(
                    width: size.width,
                    child: CustomButton(
                        color: colorAccent,
                        borderRadius: 8,
                        title: 'Publish Feedback',
                        onPressed: () {
                          if (contentRating.isEmpty) {
                            toast('Please provide rating stars');
                            return;
                          }
                          Map body={};
                          body['reviewToId'] = userId;
                          body['stars'] = contentRating;
                          body['publicReview']=publicFeedback.text;
                          body['privateReview']=privateFeedback.text;
                          body['sessionId']=sessionId;
                         context.read<SessionProvider>().doCallCreateReview(context, body);
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
