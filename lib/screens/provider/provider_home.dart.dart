import 'package:bookthera_customer/screens/provider/list_provider.dart';
import 'package:bookthera_customer/screens/provider/provider_filter.dart';
import 'package:bookthera_customer/screens/provider/provider_provider.dart';
import 'package:bookthera_customer/screens/provider/provider_search.dart';
import 'package:bookthera_customer/screens/provider/widgets/build_tile.dart';
import 'package:bookthera_customer/screens/provider/widgets/provider_cell.dart';
import 'package:bookthera_customer/screens/provider/widgets/search_field.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../utils/Common.dart';
import '../../utils/helper.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  TextEditingController searchController=TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!Datamanager().isDashboardFirstLoad) {
        context.read<ProviderProvider>().getChatProvider(context);
        callProviders();  
      }
    });
  }

  void callProviders() {
    // if (Datamanager().layoutChoice=='simple') {
    //   context.read<ProviderProvider>().doCallGetProviders();    
    // } else {
      context.read<ProviderProvider>().doCallGetProvidersByCategory();
    // }
  }
  @override
  Widget build(BuildContext context) {
    var providerProvider = context.watch<ProviderProvider>();
    return CustomLoader(
      isLoading: (providerProvider.providerCategoryList.isEmpty && providerProvider.providersList.isEmpty) && providerProvider.isLoading,
      child: (providerProvider.providersList.isEmpty)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  if((providerProvider.providerCategoryList.isNotEmpty || providerProvider.providersList.isNotEmpty) && providerProvider.isLoading) LinearProgressIndicator(color: colorPrimary,minHeight: 2,),
                  Padding(
                    padding: getPadding(all: 16),
                    child: CustomSearchField(
                      searchController: searchController,
                      isClose: searchController.text.isNotEmpty,
                      onClose: () {
                        setState(() {
                          searchController.clear();
                          callProviders();
                        });
                      },
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
                        showCustomDialog(context, ProviderSearch(),onthen: (query) {
                          if (query!=null) {
                            searchController.text=query;  
                          }
                        },);
                      },
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                        providerProvider.providerCategoryList.length,
                        (index) => Column(
                              children: [
                                buildTitleRow(
                                  titleValue: providerProvider
                                      .providerCategoryList[index].title!,
                                  onClick: () {
                                    push(
                                      context,
                                      ListProviders(
                                        providers: providerProvider
                                            .providerCategoryList[index].data,
                                        appBarTitle: providerProvider
                                                .providerCategoryList[index]
                                                .title! +
                                            " Providers",
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: getSize(309),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: providerProvider
                                            .providerCategoryList[index]
                                            .data
                                            .length,
                                        itemBuilder: (context, i) =>
                                            ProviderCell(
                                              provider: providerProvider
                                                  .providerCategoryList[index]
                                                  .data[i],
                                            ))),
                              ],
                            )),
                  )
                ],
              ),
            )
          : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if((providerProvider.providerCategoryList.isNotEmpty || providerProvider.providersList.isNotEmpty) && providerProvider.isLoading) LinearProgressIndicator(color: colorPrimary,minHeight: 2,),
              Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16),
                    child: CustomSearchField(
                      searchController: searchController,
                      isClose: searchController.text.isNotEmpty,
                      onClose: () {
                        setState(() {
                          searchController.clear();
                          callProviders();
                        });
                      },
                      onFavouriteTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => ListProviders(
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
                        showCustomDialog(context, ProviderFilter(),onthen: (value){
                          context.read<ProviderProvider>().resetProducsList();
                        });
                      },
                      onTap: () {
                        showCustomDialog(context, ProviderSearch(),onthen: (query) {
                          if (query!=null) {
                            searchController.text=query;
                          }
                        },);
                      },
                    ),
                  ),
              Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: providerProvider.providersList.length,
                      itemBuilder: (context, index) => ProviderCell(
                            provider: providerProvider.providersList[index],
                          )),
                ),
            ],
          ),
    );
  }
}

class TheSearch extends SearchDelegate<String> {
  TheSearch({required this.contextPage});

  BuildContext contextPage;
  // WebViewController controller;
  final suggestions1 = ["https://www.google.com"];

  @override
  String get searchFieldLabel => "Enter a web address";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text('result'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ? suggestions1 : [];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => ListTile(
          leading: Icon(Icons.arrow_left), title: Text(suggestions[index])),
    );
  }
}
