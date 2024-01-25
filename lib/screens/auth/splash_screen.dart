
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../utils/datamanager.dart';
import 'auth_provider.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AuthProvider>().doCallProfile(context);
      PackageInfo.fromPlatform().then((packageInfo) {
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;
        Datamanager().appVersion = 'v$version($buildNumber)';
        print(Datamanager().appVersion);
      });
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/app_logo_signup.png')));
  }
}