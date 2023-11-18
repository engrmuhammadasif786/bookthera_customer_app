
import 'package:bookthera_customer/components/custom_appbar.dart';
import 'package:bookthera_customer/models/Provider.dart';
import 'package:bookthera_customer/screens/provider/provider_filter.dart';
import 'package:bookthera_customer/screens/provider/provider_provider.dart';
import 'package:bookthera_customer/screens/provider/provider_search.dart';
import 'package:bookthera_customer/screens/provider/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../utils/Common.dart';
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
      appBar: CustomAppbar(title: widget.appBarTitle??"",),
      body: CustomLoader(
        isLoading: providerList.isEmpty && isLoading,
        child: Column(
          children: [
            if(providerList.isNotEmpty && isLoading) LinearProgressIndicator(color: colorPrimary,minHeight: 2,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
              child: CustomSearchField(
                      onFavouriteTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => ListProviders(
                                  appBarTitle: 'Saved',
                                      onInitCall: () {
                                        context
                                            .read<ProviderProvider>()
                                            .doCallGetProvidersByFavourite();
                                      },
                                    )))
                            .then((value) {
                          context
                              .read<ProviderProvider>()
                              .doCallGetProvidersByCategory();
                        });
                      },
                      onFilter: () {
                        showCustomDialog(context, ProviderFilter());
                      },
                      onTap: () {
                        showCustomDialog(context, ProviderSearch());
                      },
                    ),
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
