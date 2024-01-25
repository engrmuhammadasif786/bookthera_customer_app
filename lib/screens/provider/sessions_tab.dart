import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/screens/provider/widgets/provider_cell.dart';
import 'package:bookthera_customer/screens/provider/widgets/session_tab_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SessionsTab extends StatelessWidget {
  SessionsTab({super.key,required this.providerModel,this.onAction});
  ProviderModel providerModel;
  Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
           ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: providerModel.promotions.length,
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (context, index) {
           return SessionTabCell(sesssionModel: providerModel.promotions[index],venderName: providerModel.venderName!,ownerId: providerModel.owner!,providerId: providerModel.sId!,onAction: onAction); 
          }),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: providerModel.sessions.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
           return SessionTabCell(sesssionModel: providerModel.sessions[index],venderName: providerModel.venderName!,ownerId: providerModel.owner!,providerId: providerModel.sId!,onAction: onAction); 
          }),
        ],
      ),
    );
  }
}