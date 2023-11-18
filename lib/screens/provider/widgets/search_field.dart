import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
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
      this.isClose=false,
      this.onClose,
      this.showFilterCount = false,this.onSubmitted,this.onSearchTap,this.showCursor});
  TextEditingController? searchController;
  bool isShowFavourite;
  void Function()? onTap;
  void Function()? onFilter;
  void Function()? onFavouriteTap;
  void Function(String)? onSubmitted;
  void Function()? onSearchTap;
  void Function()? onClose;
  void Function(String)? onChanged;
  bool isFilter;
  bool isClose;
  bool showFilterCount;
  bool? showCursor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getSize(44),
      child: Row(
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
                style: TextStyle(fontSize: getFontSize(12), fontWeight: FontWeight.w400,color: search_edittext_color),
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: GestureDetector(
                    onTap: onSearchTap,
                    child: Icon(
                      Icons.search,
                      size: getSize(26),
                      color: isDarkMode(context) ? Colors.white : Colors.black,
                    ),
                  ),
                  suffixIcon: isFilter?
                      GestureDetector(
                          onTap: onFilter,
                          child: Container(
                            margin: getMargin(all: 8),
                            padding: getPadding(all: 6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: colorPrimary),
                            child:  Image.asset(
                                  'assets/icons/ic_filter.png',
                                  fit: BoxFit.contain,
                                  height: getSize(16),
                                  width: getSize(16),
                                ),
                          ),
                        ):SizedBox.shrink(),
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
          if(isClose)  CloseButton(onPressed: onClose,color: colorPrimary,),
          if (isShowFavourite)
            GestureDetector(
                onTap: onFavouriteTap,
                child: Padding(
                  padding: getPadding(left: 8),
                  child: Icon(
                    Icons.favorite,
                    color: colorPrimary,
                    size: getSize(30),
                  ),
                ))
        ],
      ),
    );
  }
}
