import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/reviewModel.dart';
import '../../../utils/helper.dart';

class ReViewTabCell extends StatelessWidget {
  const ReViewTabCell({super.key,required this.reviewModel});
  final ReviewModel reviewModel;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    String reviewByFName='';
    String reviewByLName='';
    String reviewByName='';
    dynamic reviewByProfile=AssetImage("assets/images/placeholder.jpg");
    if (reviewModel.reviewFromData!=null) {
      reviewByFName=reviewModel.reviewFromData!.fname!;
      reviewByLName=reviewModel.reviewFromData!.lname!;
      reviewByName=reviewModel.reviewFromData!.uname!;
      if (reviewModel.reviewFromData!.avatar!=null) {
        reviewByProfile=NetworkImage(reviewModel.reviewFromData!.avatar!.url!);  
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20, bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: getSize(41),
            width: getSize(41),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: reviewByProfile)),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('$reviewByName',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: getFontSize(18),
                            )),
                    Spacer(),
                    Text(setLastSeen(reviewModel.createdAt!.millisecondsSinceEpoch),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: getFontSize(15),
                            color: Color(0xFFADB3BC)
                            )),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                AbsorbPointer(
                  child: RatingBar.builder(
                      initialRating: double.parse(reviewModel.stars!),
                      minRating: 1,
                      direction: Axis.horizontal,
                      unratedColor: Colors.grey.withOpacity(0.5),
                      itemSize: getSize(20),
                      itemPadding: EdgeInsets.only(right: 4.0),
                      
                      itemBuilder: (context, number) => Icon(
                        Icons.star,
                        color: Color(0xFFF98600),
                      ),
                      onRatingUpdate: (rating) {
                        // contentRating=rating.toStringAsFixed(0);
                      },
                    ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                    constraints: BoxConstraints(maxWidth: 230),
                    child: Text(
                      reviewModel.publicReview!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                            fontSize: getFontSize(16),
                            color: Color(0xFF50555C)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
