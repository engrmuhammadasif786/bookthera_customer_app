import 'dart:developer';

import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import 'custom_textfields.dart';

// ignore: must_be_immutable
class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  TextEditingController? searchText;
  final bool isShowFavourite;
  final bool isShowSearchIcon;
  final bool isShowMenuButton;
  final bool isActionButtons;
  final bool isShowCart;
  final String title;
  final bool isShowSearch;
  final bool isLeading;
  // final VoidCallback? onLeadingCallBack;
  List<String>? tabs;
  Function(int)? onTap;
  static TabController? tabController;
  void Function()? onSearch;
  final Function(String)? onChange;
  void Function(String)? onSubmitted;
  double? elevation;
  Widget? titleWidget;
  List<Widget>? actions;
  CustomAppbar(
      {Key? key,
      this.searchText,
      this.title = '',
      this.titleWidget,
      this.isShowFavourite = false,
      this.isShowSearch = false,
      // this.onLeadingCallBack,
      this.isLeading = true,
      this.onSubmitted,
      this.isActionButtons = true,
      this.isShowMenuButton = false,
      this.isShowSearchIcon = true,
      this.tabs,
      this.onTap,
      this.actions,
      this.preferredSize = const Size.fromHeight(kToolbarHeight),
      this.onSearch,
      this.onChange,
      this.isShowCart = true,this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AppBar(
      leading: IconButton(
        icon: Image.asset(
                        'assets/images/arrow_back.png',
                        height: getSize(33),
                        width: getSize(33),
                        color: colorPrimary,
                      ),
        onPressed: () => Navigator.of(context).pop(),
      ), 
      backgroundColor: Colors.white,
      title: titleWidget?? Text(title,
          style: TextStyle(color: textColorPrimary, fontSize: getFontSize(20), fontWeight: FontWeight.w500)),
      elevation: elevation?? getSize(2),
      centerTitle: true,
      actions: actions,
      // actions: isActionButtons ? actionbar(size) : null,
    );
  }

  List<Widget>? actionbar(Size size) {
    if (!isShowSearch)
      return [
        if (isShowSearchIcon)
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 30,
            ),

            // child: Padding(
            //   padding: const EdgeInsets.only(left: 8),
            //   child: Image.asset(
            //     "resources/search_selected.png",
            //     height: 30,
            //     width: 30,
            //   ),
            // )
          ),
        if (isShowFavourite)
          IconButton(
              onPressed: () {
                // StateManager().isFavouritePressed =
                //     !StateManager().isFavouritePressed;
                // setState(() {});
                // Get.toNamed(WishListScreen.routeName);
              },
              icon: Icon(
                Icons.favorite_outline,
                size: 30,
              )),
        if (isShowCart)
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.005),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    // Get.toNamed(CartScreen.routeName);
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                  ),
                ),
                // if (dashboardController.cartItemCount.value != 0)
                //   Obx(() => Positioned(
                //         top: 0,
                //         right: 0,
                //         child: Container(
                //           padding: EdgeInsets.all(size.height * 0.003),
                //           margin: EdgeInsets.only(
                //               right: size.width * 0.01,
                //               top: size.width * 0.005),
                //           // width: size.width * 0.045,
                //           // height: size.width * 0.045,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //             color: ColorConstants.secondaryColor,
                //             shape: BoxShape.circle,
                //           ),
                //           child: Center(
                //             child: Text(
                //               dashboardController.cartItemCount.value
                //                   .toString(),
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.w500,
                //                   fontSize: size.height * 0.019),
                //             ),
                //           ),
                //         ),
                //       ))
              ],
            ),
          ),
      ];
  }

  searchFiled(Size size, BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: EdgeInsets.only(top: size.height * 0.01),
      child: Row(
        children: [
          Expanded(
              child: CustomTextField(
            autofocus: true,
            textInputAction: TextInputAction.search,
            textEditingController: searchText!,
            hint: 'Suche',
            fillColor: Colors.grey.shade50,
            onChanged: onChange,
            onSubmitted: onSubmitted,
            suffixIcon: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                onSearch!();
              },
              child: Icon(
                Icons.search,
              ),
            ),
          )),
          // TextButton(
          //     onPressed: () {},
          //     child: Text(
          //       'Abbrechen',
          //       style: TextStyle(
          //           fontSize: size.height * 0.015,
          //           fontWeight: FontWeight.w500,
          //           color: colorPrimary),
          //     ))
        ],
      ),
    );
  }
}
