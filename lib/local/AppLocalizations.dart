import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookthera_customer/local/BaseLanguage.dart';
import 'package:bookthera_customer/local/LanguageAr.dart';
import 'package:bookthera_customer/local/LanguageEn.dart';
import 'package:bookthera_customer/local/LanguageFr.dart';
import 'package:bookthera_customer/local/LanguageHi.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'hi':
        return LanguageHi();
      case 'fr':
        return LanguageFr();

      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
