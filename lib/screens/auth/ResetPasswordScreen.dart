import 'package:bookthera_customer_1/components/custom_button.dart';
import 'package:bookthera_customer_1/components/custom_loader.dart';
import 'package:bookthera_customer_1/components/custom_textform_field.dart';
import 'package:bookthera_customer_1/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../utils/helper.dart';
import 'auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  GlobalKey<FormState> _key1 = GlobalKey();
  AutovalidateMode _validate1 = AutovalidateMode.disabled;

  GlobalKey<FormState> _key2 = GlobalKey();
  AutovalidateMode _validate2 = AutovalidateMode.disabled;

  String _emailAddress = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String? password, confirmPassword;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {context.read<AuthProvider>().setIsEnterOtp(false);});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var spaceFromWalls = 30.0;
    var isEnterOtp=context.watch<AuthProvider>().isEnterOtp;
    AuthProvider authProviderTrue =context.watch<AuthProvider>();
    AuthProvider authProviderFalse =context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      ),
      body:  CustomLoader(
        isLoading: authProviderTrue.isLoading,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.asset(
                    'assets/images/app_logo_signup.png',
                    width: 42,
                    height: 42,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 25.0),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 21,left: 16,right: 16),
                  child: Text(
                    authProviderTrue.isEnterOtp?'Please type verification code sent to you on provided email': 'Please follow steps to reset your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0),
                  ),
                ),
                Form(
                  autovalidateMode: _validate1,
                  key: _key1,
                  child: CustomTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: validateEmail,
                    onSaved: (val) => _emailAddress = val!,
                    hintText: 'E-mail',
                    prefixIcon: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  ),
                ),
                if(isEnterOtp)
                Form(
                  key: _key2,
                  autovalidateMode: _validate2,
                  child: Column(
                    children: [
                      Padding(
                    padding: EdgeInsets.only(top: size.height*0.04,bottom: size.height*0.02),
                    child: Container(
                      width: size.width - (spaceFromWalls * 5),
                      child: PinCodeTextField(
                        // readOnly: !Provider.of<PasswordProvider>(context , listen: true).turnOnPin ? true : false,
                        // enablePinAutofill: !Provider.of<PasswordProvider>(context , listen: true).turnOnPin ? false : true,
                        appContext: context,
                        textStyle: TextStyle(color: Colors.black),
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 6,
                        autoDisposeControllers: false,
                        obscureText: false,
                        obscuringCharacter: '*',
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        validator: validateOTP,
                        focusNode: authProviderTrue.pinFocus,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          // fieldWidth:
                          //     (size.width - (spaceFromWalls * 2) - (10 * 15)) /
                          //         4, //size.width * 0.2,
                          
                          inactiveFillColor: Colors.transparent,
                          inactiveColor: textColorPrimary,
                          selectedFillColor: Colors.transparent,
                          selectedColor: colorPrimary,
                          activeFillColor: colorPrimary.withOpacity(0.11),
                          activeColor: colorPrimary,
                        ),
                        cursorColor: colorPrimary,
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        // errorAnimationController: errorController,
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          return true;
                        },
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: 'password',
                    validator: validatePassword,
                    obscureText: authProviderTrue.isPasswordVisible,
                    onSaved: (String? val) {
                      password = val;
                    },
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          authProviderFalse.setIsPasswordVisible();
                        }, icon: Icon(Icons.visibility_outlined)),
                  ),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: authProviderTrue.isConPasswordVisible,
                    suffixIcon: IconButton(
                        onPressed: () {
                          authProviderFalse.setIsConPasswordVisible();
                        }, icon: Icon(Icons.visibility_outlined)),
                    validator: (value) {
                      return validateConfirmPassword(passwordController.text,value);
                    },
                    onSaved: (String? val) {
                      confirmPassword = val;
                    },
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                  ),
                  
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity),
                    child: CustomButton(
                        title: isEnterOtp?'Reset Password': 'Send Link', onPressed: isEnterOtp? resetPassword:sendOTP),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  sendOTP() async {
    if (_key1.currentState?.validate() ?? false) {
      _key1.currentState!.save();
      Map request={};
      request['email']=emailController.text.trim();
      await Provider.of<AuthProvider>(context,listen: false).doForgotPassword(request, context);
    } else {
      setState(() {
        _validate1 = AutovalidateMode.onUserInteraction;
      });
    }
  }

  resetPassword() async {
    if (_key2.currentState?.validate() ?? false) {
      _key2.currentState!.save();
      Map request={};
      request['otp']=otpController.text.trim();
      request['newPassword']=passwordController.text.trim();
      request['confirmPassword']=confirmPasswordController.text.trim();
      await Provider.of<AuthProvider>(context,listen: false).doResetPassword(request, context);
    } else {
      setState(() {
        _validate2 = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
