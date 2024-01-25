import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/screens/provider/widgets/review_tab_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReviewsTab extends StatelessWidget {
  ReviewsTab({super.key,required this.providerModel });
  ProviderModel providerModel;
  @override
  Widget build(BuildContext context) {
    return providerModel.reviews.isEmpty?Center(child: Text('I’m new to the platform. No reviews yet! 😊')): ListView.builder(
      itemCount: providerModel.reviews.length,
      itemBuilder: (context, index) {
        return ReViewTabCell(reviewModel: providerModel.reviews[index],);
      },
    );
  }
}