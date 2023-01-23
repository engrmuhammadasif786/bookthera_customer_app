import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/screens/provider/provider_provider.dart';
import 'package:bookthera_customer/screens/provider/widgets/search_field.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ProviderFilter extends StatefulWidget {
  @override
  State<ProviderFilter> createState() => _ProviderFilterState();
}

class _ProviderFilterState extends State<ProviderFilter> {
  // const ProviderFilter({super.key});
  bool onlineOnly = false;
  int filter1Index = -1;
  int filter2Index = -1;
  int filter3Index = -1;
  int filter4Index = -1;
  bool isAppliedFilter = false;
  List<String> filter1 = [
    'Price - High to Low',
    'Price - Low to High',
    'Most Reviews',
    'Least Reviews (Newest)'
  ];

  List<String> filter2 = ['Voice', 'Video'];

  List<String> filter3 = ['Offers \$5 Intro Call'];

  List<String> filter4 = ['Chat Now', 'Book Appointment'];

  @override
  void initState() {
    super.initState();
    onlineOnly = Datamanager().onlineOnly;
    filter1Index = Datamanager().filter1Index;
    filter2Index = Datamanager().filter2Index;
    filter3Index = Datamanager().filter3Index;
    filter4Index = Datamanager().filter4Index;
    isAppliedFilter = onlineOnly ||
        filter1Index != -1 ||
        filter2Index != -1 ||
        filter3Index != -1 || filter4Index != -1;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 64 + kToolbarHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: textColorPrimary),
                    ),
                    GestureDetector(onTap: (){
                      Navigator.of(context).pop();
                    }, child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.close),
                    ))
                  ],
                ),
              ),
               Text(
                'Sorting By',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColorPrimary),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filter1.length,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.25,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (filter1Index == index) {
                            filter1Index = -1;
                          } else {
                            filter1Index = index;
                          }
                        });
                      },
                      child: filterCell(index == filter1Index, filter1[index]),
                    );
                  }),
              Text(
                'Session Type',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColorPrimary),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filter2.length,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.25,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (filter2Index == index) {
                            filter2Index = -1;
                          } else {
                            filter2Index = index;
                          }
                        });
                      },
                      child: filterCell(index == filter2Index, filter2[index]),
                    );
                  }),
              Text(
                'Availability',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColorPrimary),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filter4.length,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.25,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (filter4Index == index) {
                            filter4Index = -1;
                          } else {
                            filter4Index = index;
                          }
                        });
                      },
                      child: filterCell(index == filter4Index, filter4[index]),
                    );
                  }),
              
              Text(
                'Promotion',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColorPrimary),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filter3.length,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3.25,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (filter3Index == index) {
                            filter3Index = -1;
                          } else {
                            filter3Index = index;
                          }
                        });
                      },
                      child: filterCell(index == filter3Index, filter3[index]),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        borderRadius: 10,
                        title: isAppliedFilter ? 'Clear Filter' : 'Apply',
                        color: isAppliedFilter?dimGrey:colorPrimary,
                        onPressed: () {
                          if (isAppliedFilter) {
                            Datamanager().onlineOnly = false;
                            Datamanager().filter1Index = -1;
                            Datamanager().filter2Index = -1;
                            Datamanager().filter3Index = -1;
                            Datamanager().filter4Index = -1;

                             onlineOnly = Datamanager().onlineOnly;
                            filter1Index = Datamanager().filter1Index;
                            filter2Index = Datamanager().filter2Index;
                            filter3Index = Datamanager().filter3Index;
                            filter4Index = Datamanager().filter4Index;
                            isAppliedFilter=false;
                            setState(() {
                              
                            });
                            Navigator.of(context).pop(true);
                          } else {
                            Datamanager().onlineOnly = onlineOnly;
                            Datamanager().filter1Index = filter1Index;
                            Datamanager().filter2Index = filter2Index;
                            Datamanager().filter3Index = filter3Index;
                            Datamanager().filter4Index = filter4Index;
                            Navigator.of(context).pop(false);
                            context.read<ProviderProvider>().doCallGetProviders(
                                onlineOnly: onlineOnly,
                                price: filter1Index == 0
                                    ? '-1'
                                    : filter1Index == 1
                                        ? '1'
                                        : '',
                                reviewsCount: filter1Index == 2
                                    ? '-1'
                                    : filter1Index == 3
                                        ? '1'
                                        : '',
                                isAudio: filter2Index>-1?filter2Index == 0 ? true : false:true,
                                isVideo: filter2Index>-1?filter2Index == 1 ? true : false:true,
                                isChat: filter4Index>-1?filter4Index == 0 ? true : false:true,
                                isBook: filter4Index>-1?filter4Index == 0 ? true : false:true,
                                promotion: filter3Index>-1?filter3Index == 0 ? true : false:true);
                          }
                        })),
              )
            ],
          ),
        ),
      ),
    );
  }

  filterCell(bool isSelected, String title) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? colorPrimaryLight : Color(0xffF1F1F1),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: isSelected ? colorPrimary : Color(0xff858585))),
    );
  }

  Widget _focus(String category) {
    return Container(
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
    );
  }
}
