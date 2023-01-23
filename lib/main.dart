import 'package:bookthera_provider/firebase_options.dart';
import 'package:bookthera_provider/screens/sessions/audioVideosCalls/call.dart';
import 'package:bookthera_provider/screens/auth/LoginScreen.dart';
import 'package:bookthera_provider/screens/auth/SignUpScreen.dart';
import 'package:bookthera_provider/screens/auth/auth_provider.dart';
import 'package:bookthera_provider/screens/home/home_provider.dart';
import 'package:bookthera_provider/screens/inbox/chat_provider.dart';
import 'package:bookthera_provider/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_provider/screens/sessions/session_provider.dart';
import 'package:bookthera_provider/screens/settings/setting_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookthera_provider/local/BaseLanguage.dart';
import 'package:bookthera_provider/utils/AppTheme.dart';
import 'package:bookthera_provider/utils/AppWidgets.dart';
import 'package:bookthera_provider/utils/Constants.dart';
import 'package:provider/provider.dart';

import 'screens/provider/provider_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initialize(aLocaleLanguageList: languageList());
  textPrimaryColorGlobal = Colors.white;
  textSecondaryColorGlobal = Colors.grey.shade500;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
        ChangeNotifierProvider<ProviderProvider>(
            create: (_) => ProviderProvider()),
        ChangeNotifierProvider<BookSesstionProvider>(
            create: (_) => BookSesstionProvider()),
        ChangeNotifierProvider<SessionProvider>(
            create: (_) => SessionProvider()),
        ChangeNotifierProvider<SettingProvider>(
            create: (_) => SettingProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          home: LoginScreen(),
          routes: <String, WidgetBuilder>{
            // HomeScreen.tag: (BuildContext context) => HomeScreen(),
          },
          builder: scrollBehaviour(),
          supportedLocales: LanguageDataModel.languageLocales(),
        ),
      ),
    );
  }
}
