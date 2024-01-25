import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/components/custom_loader.dart';
import 'package:bookthera_customer/components/error_indicator.dart';
import 'package:bookthera_customer/network/NetworkUtils.dart';
import 'package:bookthera_customer/network/RestApis.dart';
import 'package:bookthera_customer/screens/auth/ResetPasswordScreen.dart';
import 'package:bookthera_customer/screens/auth/SignUpScreen.dart';
import 'package:bookthera_customer/screens/auth/auth_provider.dart';
import 'package:bookthera_customer/screens/home/dashboard.dart';
import 'package:bookthera_customer/screens/inbox/chat_provider.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../utils/helper.dart' as hp;

class LoginScreen extends StatefulWidget {
  bool isBackButton;
  LoginScreen({this.isBackButton=false});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  GlobalKey<FormState> _key = GlobalKey();
  String message='';
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController=VideoPlayerController.asset('assets/images/intro_video.mp4');
    videoPlayerController.initialize().then((value) {
      videoPlayerController.play();
    });
    videoPlayerController.setLooping(true);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      AuthProvider authProvider = context.read<AuthProvider>();
      if (getBoolAsync(isLoggedIn)) {
        // await authProvider.doCallProfile(context);
      } else {
        bool isRemember = getBoolAsync(is_remember);
        if (isRemember) {
          authProvider.isSavePassword = isRemember;
          _emailController.text = getStringAsync(USER_EMAIL);
          _passwordController.text = getStringAsync(PASSWORD);
        }
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: CustomLoader(
        isLoading: context.watch<AuthProvider>().isLoading,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Image.asset('assets/images/auth_bg.png',fit: BoxFit.cover,width: size.width,height: size.height,),
            SizedBox(
              width: size.width,
              height: size.height,
              child: VideoPlayer(videoPlayerController)),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.black.withOpacity(0.2),
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
                elevation: 1.0,
                toolbarHeight: 0,
              ),
              body: Form(
                key: _key,
                autovalidateMode: _validate,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.2,
                            vertical: size.height * 0.025),
                        child: Image.asset('assets/images/app_logo.png',
                            fit: BoxFit.cover),
                      ),
                      SizedBox(
                        height: size.height * 0.3,
                      ),
    
                      ErrorIndicator(message: message,onCancel: () {
                        message='';
                      },),
                      /// email address text field, visible when logging with email
                      /// and password
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        child: Padding(
                          padding: getPadding(
                              top: 32.0, right: 24.0, left: 24.0),
                          child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              // validator: hp.validateEmail,
                              controller: _emailController,
                              style:
                                  TextStyle(fontSize: getFontSize(18), color: Colors.white),
                              keyboardType: TextInputType.text,
                              cursorColor: colorPrimary,
                              decoration: InputDecoration(
                                contentPadding:
                                    getPadding(left: 16, right: 16),
                                hintText: 'username',
                                labelText: 'username',
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.white),
                                errorStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: getSize(18),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: colorPrimary, width: 2.0)),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).errorColor),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).errorColor),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              )),
                        ),
                      ),
    
                      /// password text field, visible when logging with email and
                      /// password
                      ConstrainedBox(
                        constraints: BoxConstraints(minWidth: double.infinity),
                        child: Padding(
                          padding: getPadding(
                              top: 32.0, right: 24.0, left: 24.0),
                          child: TextFormField(
                              // validator: hp.validatePassword,
                              textAlignVertical: TextAlignVertical.center,
                              controller: _passwordController,
                              obscureText:
                                  context.watch<AuthProvider>().isPasswordVisible,
                              obscuringCharacter: '*',
                              onFieldSubmitted: (password) => _login(context),
                              textInputAction: TextInputAction.done,
                              style:
                                  TextStyle(fontSize: getFontSize(18), color: Colors.white),
                              cursorColor: colorPrimary,
                              decoration: InputDecoration(
                                contentPadding:
                                    getPadding(left: 16, right: 16),
                                hintText: 'password',
                                labelText: 'password',
                                labelStyle: TextStyle(color: Colors.white),
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: getSize(18),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      context
                                          .read<AuthProvider>()
                                          .setIsPasswordVisible();
                                    },
                                    icon: Icon(
                                      context.watch<AuthProvider>().isPasswordVisible?Icons.visibility_off: Icons.visibility_outlined,
                                      color: Colors.white,
                                      size: getSize(24),
                                    )),
                                errorStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: colorPrimary, width: 2.0)),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).errorColor),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).errorColor),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              )),
                        ),
                      ),
    
                      /// forgot password text, navigates user to ResetPasswordScreen
                      /// and this is only visible when logging with email and password
                      Padding(
                        padding:
                            getPadding(top: 16, right: 24, left: 12),
                        child: Row(
                          children: [
                            Checkbox(
                                activeColor: colorPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(getSize(4.19))
                                ),
                                side: BorderSide(color: Colors.white,),
                                value:
                                    context.watch<AuthProvider>().isSavePassword,
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<AuthProvider>()
                                        .setIsSavePassword(value);
                                  }
                                }),
                            Text(
                              'Save password',
                              style: TextStyle(color: Colors.white,fontSize: getFontSize(15),fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                hp.push(context, ResetPasswordScreen());
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getFontSize(15),
                                    letterSpacing: 1,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
    
                      /// the main action button of the screen, this is hidden if we
                      /// received the code from firebase
                      /// the action and the title is base on the state,
                      /// * logging with email and password: send email and password to
                      /// firebase
                      /// * logging with phone number: submits the phone number to
                      /// firebase and await for code verification
                      Padding(
                        padding: getPadding(
                            right: 40.0, left: 40.0, top: 40),
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: CustomButton(
                              title: 'Login',
                              onPressed: () {
                                _login(context);
                              }),
                        ),
                      ),
    
                      Padding(
                        padding: getPadding(top: 10, right: 40, left: 40),
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(minWidth: double.infinity),
                          child: ElevatedButton.icon(
                              label: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Continue with Google',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: getFontSize(18),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  )),
                              icon: Padding(
                                padding: getPadding(left: 20,right: 20,top: 8,bottom: 8),
                                child: Image.asset(
                                  'assets/images/google_logo.png',
                                  height: getSize(26),
                                  width: getSize(26),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(getSize(24)),
                                  side: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                context.read<AuthProvider>().doGoogleSignin(context);
                              }),
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            hp.pushReplacement(context, SignUpScreen());
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Don’t have an account? ",
                              style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: getFontSize(17),
                                      letterSpacing: 1),
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
    
                      SizedBox(
                        height: size.height * 0.07,
                      )
                    ],
                  ),
                ),
              ),
            ),
            if(widget.isBackButton)
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: getSize(kToolbarHeight),left: 12),
                child: BackButton(color: Colors.white,),
              ))
          ],
        ),
      ),
    );
  }

  _login(BuildContext context) async {
    message='';
    if (hp.validateEmptyField(_emailController.text)!=null) {
      message="Username is required";
    }else if (hp.validatePassword(_passwordController.text)!=null) {
      message=hp.validatePassword(_passwordController.text)??"";
    }
    if (message.isNotEmpty) {
      setState(() {
        
      });
    }else{
      Map request = {};
      request['emailUname'] = _emailController.text.trim();
      request['password'] = _passwordController.text.trim();
      await Provider.of<AuthProvider>(context, listen: false)
          .doLogin(request, context);
    }
    // if (_key.currentState?.validate() ?? false) {
    //   _key.currentState!.save();
      // Map request = {};
      // request['emailUname'] = _emailController.text.trim();
      // request['password'] = _passwordController.text.trim();
      // await Provider.of<AuthProvider>(context, listen: false)
      //     .doLogin(request, context);
    // } else {
      
      // _validate = AutovalidateMode.onUserInteraction;
    // }
  }
}
