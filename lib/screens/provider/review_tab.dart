import 'package:bookthera_customer_1/models/Provider.dart';
import 'package:bookthera_customer_1/screens/provider/widgets/review_tab_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReviewsTab extends StatelessWidget {
  ReviewsTab({super.key,required this.providerModel });
  ProviderModel providerModel;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: providerModel.reviews.length,
      itemBuilder: (context, index) {
        return ReViewTabCell(reviewModel: providerModel.reviews[index],);
      },
    );
  }
}