import 'package:bookthera_customer_1/network/RestApis.dart';
import 'package:bookthera_customer_1/screens/home/dashboard.dart';
import 'package:bookthera_customer_1/utils/Constants.dart';
import 'package:bookthera_customer_1/utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookthera_customer_1/utils/helper.dart' as hp;
import 'package:provider/provider.dart';

import '../inbox/chat_provider.dart';

class AuthProvider extends ChangeNotifier{
  bool isLoading=false;
  bool isEnterOtp=false;
  bool isPasswordVisible=true;
  bool isConPasswordVisible=true;
  bool isSavePassword = false;
  bool termsNConditons=false;
  FocusNode pinFocus=FocusNode();

  setLoader(bool status){
    isLoading=status;
    notifyListeners();
  }
  
  setTermsNConditions(){
    termsNConditons=!termsNConditons;
    notifyListeners();
  }

  setIsEnterOtp(bool status){
    isEnterOtp=status;
    notifyListeners();
  }

  setIsPasswordVisible(){
    isPasswordVisible=!isPasswordVisible;
    notifyListeners();
  }

  setIsConPasswordVisible(){
    isConPasswordVisible=!isConPasswordVisible;
    notifyListeners();
  }

  setIsSavePassword(bool status){
    isSavePassword=status;
    notifyListeners();
  }

  doGoogleSignin(BuildContext context) async {
    UserCredential userCredential = await signInWithGoogle();
    Map body={};
    if (userCredential.user==null) {
     toast(errorSomethingWentWrong);
      return;
    }
    User user = userCredential.user!;
    body['fname'] = user.displayName;
    body['uname'] = user.email!.split('@').first;
    body['email'] = user.email;
    body['password'] = userCredential.credential!.accessToken;
    body['role'] = 'user';
    setLoader(true);
    callGoogleSignin(body).then((value) {
      if (value is String) {
        toast(value);
      }else if(value is bool) {
        if (value) {
          doCallProfile(context).then((value) {
            hp.pushReplacement(context, Dashboard());
          });
        }else{
          toast(wentWrongMsg);
        }
      }
      setLoader(false);
    });
  }

  Future<void> doLogin(Map request,BuildContext context) async {
    setLoader(true);
    await setValue(is_remember, isSavePassword);
    if (isSavePassword) {
      await setValue(USER_EMAIL, request['emailUname']);
      await setValue(PASSWORD, request['password']);
    }
    await callLogin(request).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      }else if(value is bool) {
        if (value) {
          doCallProfile(context).then((value) {
            hp.pushReplacement(context, Dashboard());
          });
        }else{
          toast(wentWrongMsg);
        }
      }
    });
  }

  doRegister(Map request,BuildContext context){
    if (!termsNConditons) {
      toast('Please accept the Terms & Conditions.');
      return;
    }
    setLoader(true);
    callRegister(request).then((value) {
      if (value is String) {
        toast(value);
      }else if(value is bool) {
        if (value) {
          doCallProfile(context).then((value) {
            hp.pushReplacement(context, Dashboard());
          });
        }else{
          toast(wentWrongMsg);
        }
      }
      setLoader(false);
    });
  }

  Future<dynamic> doCallProfile(BuildContext context) async {
    setLoader(true);
    await callProfile().then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
      }else{
        if (value) {
          context.read<ChatProvider>().connectSocket();
          hp.pushAndRemoveUntil(context, Dashboard(),false);
        }
      }
    });
  }

  doForgotPassword(Map request,BuildContext context){
    setLoader(true);
    callForgotPassword(request).then((value) {
      setLoader(false);
      if (value is String) {
        toast(value);
        isEnterOtp=true;
        pinFocus.requestFocus();
        notifyListeners();
      }else{
        toast(wentWrongMsg);
      }
    });
  }

  doResetPassword(Map request,BuildContext context){
    setLoader(true);
    callResetPassword(request).then((value) {
      if (value is String) {
        toast(value);
      }else if(value is bool) {
        if (value) {
          isEnterOtp=false;
          doCallProfile(context).then((value) {
            hp.pushAndRemoveUntil(context, Dashboard(),false);
          });
        }else{
          toast(wentWrongMsg);
        }
      }
      setLoader(false);
    });
  }
}