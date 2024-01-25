
import 'package:bookthera_customer/firebase_options.dart';
import 'package:bookthera_customer/screens/auth/splash_screen.dart';
import 'package:bookthera_customer/screens/sessions/audioVideosCalls/call.dart';
import 'package:bookthera_customer/screens/auth/LoginScreen.dart';
import 'package:bookthera_customer/screens/auth/SignUpScreen.dart';
import 'package:bookthera_customer/screens/auth/auth_provider.dart';
import 'package:bookthera_customer/screens/home/home_provider.dart';
import 'package:bookthera_customer/screens/inbox/chat_provider.dart';
import 'package:bookthera_customer/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer/screens/sessions/session_provider.dart';
import 'package:bookthera_customer/screens/settings/setting_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookthera_customer/local/BaseLanguage.dart';
import 'package:bookthera_customer/utils/AppTheme.dart';
import 'package:bookthera_customer/utils/AppWidgets.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'screens/provider/provider_detail.dart';
import 'screens/provider/provider_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initialize(aLocaleLanguageList: languageList());
  textPrimaryColorGlobal = Colors.white;
  textSecondaryColorGlobal = Colors.grey.shade500;
  initDeeplink();
  runApp(MyApp());
}

initDeeplink() {
  FirebaseDynamicLinks.instance.getInitialLink().then((dynamicLink) {
    onDynamicLink(dynamicLink);
  });
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
    onDynamicLink(dynamicLink);
  }).onError((error) {
    print(error);
  });
}

void onDynamicLink(PendingDynamicLinkData? dynamicLink) {
  if (dynamicLink != null) {
    print(dynamicLink.link.queryParameters);
    String? providerId = dynamicLink.link.queryParameters['providerId'];
    if (providerId!=null) {
      print('Go to provider profile $providerId');
      Navigator.push(AppKeys.navigatorKey.currentState!.context, MaterialPageRoute(builder: (context)=>ProviderDetail(providerId: providerId,fromDynamicLink: true,)));
    }
  }
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
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            // HomeScreen.tag: (BuildContext context) => HomeScreen(),
          },
          builder: scrollBehaviour(),
          supportedLocales: LanguageDataModel.languageLocales(),
          navigatorKey: AppKeys.navigatorKey,
        ),
      ),
    );
  }
}

class AppKeys {
  static final GlobalKey<NavigatorState> navigatorKey=GlobalKey(); 
}
