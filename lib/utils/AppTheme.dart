import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookthera_customer_1/utils/resources/Colors.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackground,
    splashColor: navigationBackground,
    primaryColor: colorPrimary,
    primaryColorDark: colorPrimaryDark,
    errorColor: Color(0xFFE15858),
    hoverColor: colorPrimary.withOpacity(0.1),
    cardColor: navigationBackground,
    disabledColor: Colors.white10,
    appBarTheme: AppBarTheme(
      color: appBackground,
      iconTheme: IconThemeData(color: textColorPrimary),
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarIconBrightness: Brightness.light,
      //   statusBarColor: appBackground,
      // ),
    ),
    colorScheme: ColorScheme.light(
      primary: colorPrimary,
      onPrimary: colorPrimary,
      secondary: colorPrimary,
    ),
    cardTheme: CardTheme(color: navigationBackground),
    iconTheme: IconThemeData(color: textColorPrimary),
    textTheme: TextTheme(
      button: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: textColorPrimary),
      subtitle2: TextStyle(color: textColorSecondary),
      caption: TextStyle(color: textColorThird),
      headline6: TextStyle(color: Colors.white),
    ),
    dialogBackgroundColor: navigationBackground,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: navigationBackground,
    ),
  );
}
