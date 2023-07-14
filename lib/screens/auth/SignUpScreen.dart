import 'dart:io';

import 'package:bookthera_customer/components/custom_textform_field.dart';
import 'package:bookthera_customer/screens/auth/LoginScreen.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

import '../../components/custom_loader.dart';
import '../../components/custom_phone_field.dart';
import '../../components/custom_textfields.dart';
import '../../utils/helper.dart';
import 'auth_provider.dart';

File? _image;

class SignUpScreen extends StatefulWidget {
  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  String? username, firstName, lastName, email, mobile, password, confirmPassword;
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? _phoneNumber;
  bool _isPhoneValid = false;
  Country selectedCountry=Country(
    nameTranslations: {},
    name: "United States",
    flag: "🇺🇸",
    code: "US",
    dialCode: "1",
    minLength: 10,
    maxLength: 10,
  );

  @override
  void initState() {
    super.initState();
    ThemeData.light();
  }
  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (Platform.isAndroid) {
      retrieveLostData();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light
        ),
        // iconTheme: IconThemeData(color: isDarkMode(context) ? Colors.white : Colors.black),
      ),
      body: CustomLoader(
        isLoading: context.watch<AuthProvider>().isLoading,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 16.0, right: 16, bottom: 16,top: 32),
            child: Form(
              key: _key,
              autovalidateMode: _validate,
              child: formUI(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse? response = await _imagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
  }

  Widget formUI() {
    AuthProvider authProviderTrue =context.watch<AuthProvider>();
    AuthProvider authProviderFalse =context.read<AuthProvider>();
    return Column(
      children: <Widget>[
        Image.asset(
          'assets/images/app_logo_signup.png',
          width: 42,
          height: 42,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Create Account',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 21),
          child: Text(
            'Sign up to get started!',
            style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 15.0),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
        //   child: Stack(
        //     alignment: Alignment.bottomCenter,
        //     children: <Widget>[
        //       CircleAvatar(
        //         radius: 65,
        //         backgroundColor: Colors.grey.shade400,
        //         child: ClipOval(
        //           child: SizedBox(
        //             width: 170,
        //             height: 170,
        //             child: _image == null
        //                 ? Image.asset(
        //                     'assets/images/placeholder.jpg',
        //                     fit: BoxFit.cover,
        //                   )
        //                 : Image.file(
        //                     _image!,
        //                     fit: BoxFit.cover,
        //                   ),
        //           ),
        //         ),
        //       ),
        //       Positioned(
        //         left: 80,
        //         right: 0,
        //         child: FloatingActionButton(
        //             backgroundColor: Color(COLOR_ACCENT),
        //             child: Icon(
        //               CupertinoIcons.camera,
        //               color: isDarkMode(context) ? Colors.black : Colors.white,
        //             ),
        //             mini: true,
        //             onPressed: _onCameraClick),
        //       )
        //     ],
        //   ),
        // ),

        Row(
          children: [
            Expanded(
                child: CustomTextFormField(
              controller: firstNameController,
              hintText: "first Name",
              validator: validateName,
              onSaved: (String? val) {
                firstName = val;
              },
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            )),
            Expanded(
                child: CustomTextFormField(
              controller: lastNameController,
              hintText: "last Name",
              validator: validateName,
              onSaved: (String? val) {
                lastName = val;
              },
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            )),
          ],
        ),
        CustomTextFormField(
              controller: nameController,
              hintText: "Username",
              validator: validateEmptyField,
              onSaved: (String? val) {
                username = val;
              },
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey,
              )),
        CustomTextFormField(
          controller: emailController,
          hintText: 'Email',
          validator: validateEmail,
          keyboardType: TextInputType.emailAddress,
          onSaved: (String? val) {
            email = val;
          },
          prefixIcon: Icon(
            Icons.email,
            color: Colors.grey,
          ),
        ),
        PhoneTextFormField(
          controller: phoneController,
          onCountryChanged: (country) {
            selectedCountry=country;
          },
          hintText: 'Phone Number',
          validator: validateMobileWithPhone,
          keyboardType: TextInputType.phone,
          onSaved: (PhoneNumber? val) {
            _phoneNumber = val!=null? val.completeNumber:null;
          },
        ),
        /// user mobile text field, this is hidden in case of sign up with
        /// phone number
        // Padding(
        //   padding: EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 16),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(5),
        //         shape: BoxShape.rectangle,
        //         border: Border.all(color: Colors.black.withOpacity(0.1))),
        //     child: InternationalPhoneNumberInput(
        //       onInputChanged: (PhoneNumber number) =>
        //           _phoneNumber = number.phoneNumber,
        //       onInputValidated: (bool value) => _isPhoneValid = value,
        //       ignoreBlank: true,
        //       validator: validateMobile,
        //       autoValidateMode: AutovalidateMode.onUserInteraction,
        //       inputDecoration: InputDecoration(
        //         hintText: 'Mobile',
        //         // labelText: 'Mobile',
        //         labelStyle: TextStyle(color: colorPrimary),
        //         border: OutlineInputBorder(
        //           borderSide: BorderSide.none,
        //         ),
        //         isDense: true,
        //         contentPadding: EdgeInsets.zero,
        //         errorBorder: OutlineInputBorder(
        //           borderSide: BorderSide.none,
        //         ),
        //       ),
        //       inputBorder: OutlineInputBorder(
        //         borderSide: BorderSide.none,
        //       ),
        //       initialValue: PhoneNumber(isoCode: 'US'),
        //       selectorConfig: SelectorConfig(
        //           selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
        //     ),
        //   ),
        // ),

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
            },
            icon: Icon(authProviderTrue.isPasswordVisible?Icons.visibility_off_outlined:Icons.visibility_outlined)),
        ),
        CustomTextFormField(
          controller: confirmPasswordController,
          hintText: 'Confirm Password',
          obscureText: authProviderTrue.isConPasswordVisible,
          suffixIcon: IconButton(
            onPressed: () {
              authProviderFalse.setIsConPasswordVisible();
            },
            icon: Icon(authProviderTrue.isConPasswordVisible?Icons.visibility_off_outlined:Icons.visibility_outlined)),
          validator: (value){
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
        // ConstrainedBox(
        //   constraints: BoxConstraints(minWidth: double.infinity),
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
        //     child: TextFormField(
        //       textAlignVertical: TextAlignVertical.center,
        //       textInputAction: TextInputAction.done,
        //       onFieldSubmitted: (_) => _signUp(),
        //       obscureText: true,
        //       validator: (val) => validateConfirmPassword(_passwordController.text, val),
        //       onSaved: (String? val) {
        //         confirmPassword = val;
        //       },
        //       style: TextStyle(fontSize: 18.0),
        //       cursorColor: colorPrimary,
        //       decoration: InputDecoration(
        //         contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        //         fillColor: Colors.white,
        //         hintText: 'confirmPassword',
        //         focusedBorder: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide(color: colorPrimary, width: 2.0)),
        //         errorBorder: OutlineInputBorder(
        //           borderSide: BorderSide(color: Theme.of(context).errorColor),
        //           borderRadius: BorderRadius.circular(25.0),
        //         ),
        //         focusedErrorBorder: OutlineInputBorder(
        //           borderSide: BorderSide(color: Theme.of(context).errorColor),
        //           borderRadius: BorderRadius.circular(25.0),
        //         ),
        //         enabledBorder: OutlineInputBorder(
        //           borderSide: BorderSide(color: Colors.grey.shade200),
        //           borderRadius: BorderRadius.circular(25.0),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              Checkbox(
                  activeColor: colorPrimary,
                  side: BorderSide(color: Colors.black),
                  value: authProviderTrue.termsNConditons,
                  onChanged: (value) {
                    if (value != null) {
                      authProviderFalse.setTermsNConditions();
                    }
                  }),
              Flexible(
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "I accept the Terms & Conditions of ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Bookthera',
                          style: TextStyle(
                              color: colorPrimary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(
                    color: colorPrimary,
                  ),
                ),
                primary: colorPrimary,
              ),
              child: Text(
                'signUp',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode(context) ? Colors.black : Colors.white,
                ),
              ),
              onPressed: () => _signUp(),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(32.0),
        //   child: Center(
        //     child: Text(
        //       'or',
        //       style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black),
        //     ),
        //   ),
        // ),
        // InkWell(
        //   onTap: () {
        //     push(context, PhoneNumberInputScreen(login: false));
        //   },
        //   child: Padding(
        //     padding: EdgeInsets.only(top: 10, right: 40, left: 40),
        //     child: Container(
        //         alignment: Alignment.bottomCenter,
        //         padding: EdgeInsets.all(10),
        //         decoration:
        //             BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(color: colorPrimary, width: 1)),
        //         child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //           Icon(
        //             Icons.phone,
        //             color: colorPrimary,
        //           ),
        //           Text(
        //             'signUpWithPhoneNumber',
        //             style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold, letterSpacing: 1),
        //           ),
        //         ])),
        //   ),
        // )
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
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
          padding: EdgeInsets.only(top: 45),
          child: GestureDetector(
            onTap: () => pushReplacement(context, LoginScreen()),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  /// dispose text controllers to avoid memory leaks
  @override
  void dispose() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.dispose();
    _image = null;
    super.dispose();
  }

  /// if the fields are validated and location is enabled we create a new user
  /// and navigate to [ContainerScreen] else we show error
  _signUp() async {
    if (_key.currentState?.validate() ?? false) {
       if (phoneController.text.isEmpty ) {
         return "Phone number is required";
       }
      _key.currentState!.save();
      Map request={};
      request['fname']=firstNameController.text.trim();
      request['lname']=lastNameController.text.trim();
      request['uname']=nameController.text.trim();
      request['email']=emailController.text.trim();
      request['phone']=selectedCountry.dialCode+phoneController.text.trim();
      request['password']=passwordController.text.trim();
      request['confirmPassword']=confirmPasswordController.text.trim();
      request['role']='user';
      await Provider.of<AuthProvider>(context,listen: false).doRegister(request, context);
    } else {
        setState(() {
          _validate = AutovalidateMode.onUserInteraction;
        });
    }
  }
}
