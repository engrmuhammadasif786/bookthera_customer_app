
import 'package:bookthera_customer_1/models/Provider.dart';
import 'package:bookthera_customer_1/screens/provider/provider_provider.dart';
import 'package:bookthera_customer_1/screens/provider/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../utils/resources/Colors.dart';
import 'widgets/provider_cell.dart';

class ListProviders extends StatefulWidget {
  ListProviders({super.key,this.providers=const [],this.appBarTitle,this.onInitCall});
  List<ProviderModel> providers;
  final String? appBarTitle;
  final Function? onInitCall;
  @override
  State<ListProviders> createState() => _ListProvidersState();
}

class _ListProvidersState extends State<ListProviders> {
  @override
  void initState() {
    if (widget.onInitCall!=null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {widget.onInitCall!();});
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var isLoading=context.watch<ProviderProvider>().isLoading;
    List<ProviderModel> providerList=[];
    if (widget.providers.isEmpty) {
      providerList=context.watch<ProviderProvider>().favouriteProvidersList;
    }else{
      providerList=widget.providers;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle?? 'Providers',
          style: primaryTextStyle(
              color: textColorPrimary, size: 20, weight: FontWeight.w500),
        ),
      ),
      body: CustomLoader(
        isLoading: isLoading,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
              child: CustomSearchField(isShowFavourite: false,),
            ),
            Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: providerList.length,
                  itemBuilder: (context, index) => ProviderCell(provider: providerList[index],)),
            )
          ],
        ),
      ),
    );
  }
}
