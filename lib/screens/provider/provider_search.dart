import 'package:bookthera_provider/screens/provider/provider_provider.dart';
import 'package:bookthera_provider/screens/provider/widgets/search_field.dart';
import 'package:bookthera_provider/utils/datamanager.dart';
import 'package:bookthera_provider/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ProviderSearch extends StatefulWidget {
  const ProviderSearch({super.key});

  @override
  State<ProviderSearch> createState() => _ProviderSearchState();
}

class _ProviderSearchState extends State<ProviderSearch> {
  TextEditingController searchControlelr=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 64 + kToolbarHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        width: double.infinity,
        // clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: appBackground,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 6,
                  spreadRadius: 0,
                  color: Colors.black.withOpacity(0.15))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchField(
              searchController: searchControlelr,
              isShowFavourite: false,
              isFilter: false,
              showCursor: true,
              onSearchTap: () {
                Navigator.of(context).pop();
                if (searchControlelr.text.trim().isNotEmpty) {
                  context.read<ProviderProvider>().doCallGetProvidersSearch(searchControlelr.text);  
                }
              },
              onSubmitted: (q) {
                Navigator.of(context).pop();
                if (q.trim().isNotEmpty) {
                  context.read<ProviderProvider>().doCallGetProvidersSearch(q);  
                }
              },
            ),
            if (Datamanager().recentSearch.isNotEmpty)
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                minVerticalPadding: 0,
                leading: Text(
                  'Recents',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                trailing: TextButton(
                  onPressed: () {
                     setState(() {
                              Datamanager()
                                  .recentSearch.clear();
                            });
                  },
                  child: Text(
                    'Clear all',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colorPrimary),
                  ),
                ),
              ),
            ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 16,
                    ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                reverse: true,
                itemCount: Datamanager().recentSearch.take(3).length,
                itemBuilder: (context, index) => ListTile(
                      minVerticalPadding: 0,
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        searchControlelr.text=Datamanager()
                                  .recentSearch[index];
                      },
                      leading: Text(
                        Datamanager().recentSearch[index],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              Datamanager()
                                  .recentSearch
                                  .removeAt(index);
                            });
                          },
                          child: Icon(
                            Icons.close,
                            size: 16,
                          )),
                    )),
            if(Datamanager().popularSearch.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 8),
              child: Text(
                'Popular Search',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 23),
              child: Wrap(
                runSpacing: 5,
                spacing: 5,
                children:
                    Datamanager().popularSearch.take(3).map((e) => _focus(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _focus(String category) {
    return GestureDetector(
      onTap: () {
        searchControlelr.text=category;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: colorPrimaryLight),
        child: Text(
          '$category',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 15, color: colorPrimary),
        ),
      ),
    );
  }
}
