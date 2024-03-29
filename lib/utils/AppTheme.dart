import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

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
    // cardColor: navigationBackground,
    disabledColor: Colors.white10,
    appBarTheme: AppBarTheme(
      color: appBackground,
      iconTheme: IconThemeData(color: textColorPrimary),
      systemOverlayStyle: isAndroid? SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    
  ):null,
    ),
    switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return borderColor;
              }
              if (states.contains(MaterialState.disabled)) {
                return colorAccent;
              }
              return colorAccent;
            }),
            trackColor: MaterialStateProperty.all(Color(0xffD9D9D9)),
        ),    colorScheme: ColorScheme.light(
      primary: colorPrimary,
      onPrimary: colorPrimary,
      secondary: colorPrimary,
    ),
    // cardTheme: CardTheme(color: Colors.white),
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
