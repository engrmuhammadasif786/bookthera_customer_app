import 'package:bookthera_provider/components/custom_button.dart';
import 'package:bookthera_provider/components/custom_loader.dart';
import 'package:bookthera_provider/network/NetworkUtils.dart';
import 'package:bookthera_provider/network/RestApis.dart';
import 'package:bookthera_provider/screens/auth/ResetPasswordScreen.dart';
import 'package:bookthera_provider/screens/auth/SignUpScreen.dart';
import 'package:bookthera_provider/screens/auth/auth_provider.dart';
import 'package:bookthera_provider/screens/home/dashboard.dart';
import 'package:bookthera_provider/screens/inbox/chat_provider.dart';
import 'package:bookthera_provider/utils/Constants.dart';
import 'package:bookthera_provider/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../utils/helper.dart' as hp;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  GlobalKey<FormState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      AuthProvider authProvider = context.read<AuthProvider>();
      if (getBoolAsync(isLoggedIn)) {
        await authProvider.doCallProfile(context);
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
    return CustomLoader(
      isLoading: context.watch<AuthProvider>().isLoading,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/auth_bg.png'),
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

                    /// email address text field, visible when logging with email
                    /// and password
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: double.infinity),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 32.0, right: 24.0, left: 24.0),
                        child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            validator: hp.validateEmail,
                            controller: _emailController,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            keyboardType: TextInputType.text,
                            cursorColor: colorPrimary,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16, right: 16),
                              hintText: 'username',
                              labelText: 'username',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              errorStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
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
                        padding: const EdgeInsets.only(
                            top: 32.0, right: 24.0, left: 24.0),
                        child: TextFormField(
                            validator: hp.validatePassword,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _passwordController,
                            obscureText:
                                context.watch<AuthProvider>().isPasswordVisible,
                            obscuringCharacter: '*',
                            onFieldSubmitted: (password) => _login(context),
                            textInputAction: TextInputAction.done,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white),
                            cursorColor: colorPrimary,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 16, right: 16),
                              hintText: 'password',
                              labelText: 'password',
                              labelStyle: TextStyle(color: Colors.white),
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    context
                                        .read<AuthProvider>()
                                        .setIsPasswordVisible();
                                  },
                                  icon: Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.white,
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
                          const EdgeInsets.only(top: 16, right: 24, left: 12),
                      child: Row(
                        children: [
                          Checkbox(
                              activeColor: colorPrimary,
                              side: BorderSide(color: Colors.white),
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
                            style: TextStyle(color: Colors.white),
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
                                  fontWeight: FontWeight.bold,
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
                      padding: const EdgeInsets.only(
                          right: 40.0, left: 40.0, top: 40),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: CustomButton(
                            title: 'logn',
                            onPressed: () {
                              _login(context);
                            }),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10, right: 40, left: 40),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                )),
                            icon: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: Image.asset(
                                'assets/images/google_logo.png',
                                height: 30,
                                width: 30,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
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
                      padding: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          hp.pushReplacement(context, SignUpScreen());
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Don’t have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
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
        ],
      ),
    );
  }

  _login(BuildContext context) async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      Map request = {};
      request['emailUname'] = _emailController.text.trim();
      request['password'] = _passwordController.text.trim();
      await Provider.of<AuthProvider>(context, listen: false)
          .doLogin(request, context);
    } else {
      _validate = AutovalidateMode.onUserInteraction;
    }
  }
}
