import 'package:bookthera_provider/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../utils/helper.dart';

class CustomSearchField extends StatelessWidget {
  CustomSearchField(
      {super.key,
      this.searchController,
      this.isShowFavourite = true,
      this.onTap,
      this.onFilter,
      this.isFilter = true,
      this.onFavouriteTap,
      this.onChanged,
      this.showFilterCount = false,this.onSubmitted,this.onSearchTap,this.showCursor});
  TextEditingController? searchController;
  bool isShowFavourite;
  void Function()? onTap;
  void Function()? onFilter;
  void Function()? onFavouriteTap;
  void Function(String)? onSubmitted;
  void Function()? onSearchTap;
  void Function(String)? onChanged;
  bool isFilter;
  bool showFilterCount;
  bool? showCursor;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                spreadRadius: -6,
                offset: Offset(1, 1),
              )
            ]),
            child: TextField(
              controller: searchController,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              onTap: onTap,
              onSubmitted: (value){
                if (onSubmitted==null) {
                  if (onSearchTap!=null) {
                    onSearchTap!();
                  }
                }else{
                  onSubmitted!(value);
                }
              },
              showCursor: showCursor??true,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                prefixIcon: GestureDetector(
                  onTap: onSearchTap,
                  child: Icon(
                    Icons.search,
                    size: 26,
                    color: isDarkMode(context) ? Colors.white : Colors.black,
                  ),
                ),
                suffixIcon: isFilter
                    ? GestureDetector(
                        onTap: onFilter,
                        child: Container(
                          margin: EdgeInsets.all(6),
                          padding: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: colorPrimary),
                          child:  Image.asset(
                                'assets/icons/ic_filter.png',
                                fit: BoxFit.contain,
                                height: 12,
                                width: 12,
                              ),
                        ),
                      )
                    : null,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    borderSide: BorderSide(style: BorderStyle.none)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    borderSide: BorderSide(style: BorderStyle.none)),
                hintText: 'Search here... ',
              ),
            ),
          ),
        ),
        if (isShowFavourite)
          GestureDetector(
              onTap: onFavouriteTap,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.favorite,
                  color: colorPrimary,
                  size: 38,
                ),
              ))
      ],
    );
  }
}
