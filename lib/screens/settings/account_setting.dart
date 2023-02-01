import 'dart:io';

import 'package:bookthera_customer/screens/settings/chage_password.dart';
import 'package:bookthera_customer/screens/settings/setting_provider.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as ip;
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:provider/provider.dart';

import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../components/custom_loader.dart';
import '../../components/custom_textform_field.dart';
import '../../utils/Constants.dart';
import '../../utils/helper.dart';
import '../../utils/resources/Colors.dart';

class AccountSetting extends StatefulWidget {
  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  // const AccountSetting({super.key});
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? firstName, lastName, username, phone,email,password;
  File? file;

  ip.ImagePicker _imagePicker=ip.ImagePicker();

  @override
  void initState() {
    super.initState();
    firstNameController.text = Datamanager().firstName;
    lastNameController.text = Datamanager().lastName;
    usernameController.text = Datamanager().userName;
    phoneController.text = Datamanager().phone;
    emailController.text = Datamanager().email;
    passwordController.text = nb.getStringAsync(PASSWORD);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    dynamic imageProvider=NetworkImage(Datamanager().profile);
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Account',
      ),
      body: CustomLoader(
        isLoading: context.watch<SettingProvider>().isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
              padding: const EdgeInsets.only(top: 32.0, left: 32, right: 32),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Center(child: getCircularImageProvider( imageProvider, 130, false)),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    start: 0,
                    end: 0,
                    child: FloatingActionButton(
                        backgroundColor: colorPrimary,
                        child: Icon(
                          Icons.camera_alt,
                          color:
                              isDarkMode(context) ? Colors.black : Colors.white,
                        ),
                        mini: true,
                        onPressed: () async {
                          ip.XFile? image = await _imagePicker.pickImage(source: ip.ImageSource.gallery);
                          if (image!=null) {
                            file=File(image.path);  
                            setState(() {
                              imageProvider=FileImage(file!);
                            });
                          }
                          
                        }),
                  )
                ],
              ),
            ),
              Container(
                padding: EdgeInsets.all(14),
                margin: EdgeInsets.symmetric(horizontal: 17, vertical: 30),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          spreadRadius: 2,
                          color: Colors.black.withOpacity(0.1))
                    ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                        child: Column(
                      children: [
                        CustomTextFormField(
                          controller: firstNameController,
                          hintText: "First Name",
                          validator: validateName,
                          onSaved: (String? val) {
                            firstName = val;
                          },
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                        ),
                        CustomTextFormField(
                          controller: lastNameController,
                          hintText: "Last Name",
                          validator: validateName,
                          onSaved: (String? val) {
                            lastName = val;
                          },
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                        ),
                        CustomTextFormField(
                              controller: usernameController,
                              hintText: "Username",
                              isEditable: false,
                              focusNode: AlwaysDisabledFocusNode(),
                              onSaved: (String? val) {
                                username = val;
                              },
                              prefixIcon: Icon(
                                Icons.person,
                              ),
                            ),
                        CustomTextFormField(
                              controller: phoneController,
                              hintText: "Phone",
                              keyboardType: TextInputType.number,
                              validator: validateMobile,
                              onSaved: (String? val) {
                                phone = val;
                              },
                              prefixIcon: Icon(
                                Icons.phone,
                              ),
                            ),
                        CustomTextFormField(
                              controller: emailController,
                              hintText: "Email",
                              isEditable: false,
                              focusNode: AlwaysDisabledFocusNode(),
                              keyboardType: TextInputType.emailAddress,
                              validator: validateEmail,
                              onSaved: (String? val) {
                                email = val;
                              },
                              prefixIcon: Icon(
                                Icons.email,
                              ),
                            ),
                            CustomTextFormField(
                              controller: passwordController,
                              hintText: "Password",
                              isEditable: false,
                              focusNode: AlwaysDisabledFocusNode(),
                              obscureText: true,
                              prefixIcon: Icon(
                                Icons.lock,
                              ),
                              suffixIcon: TextButton(onPressed: (){
                                push(context, ChangePasswordScreen() );
                              }, child: Text('Change',style: TextStyle(decoration: TextDecoration.underline,color: colorPrimary),)),
                            )
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.only(top: 46.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          color: colorAccent,
                          borderRadius: 8,
                          title: 'Save', onPressed: (){
                            Map body={};
                            if (firstName!=null) {
                              body['fname']=firstName;
                            }
                            if (lastName!=null) {
                              body['lname']=lastName;
                            }
                            // if (username!=null) {
                            //   body['uname']=username;
                            // }
                            if (phone!=null) {
                              body['phone']=phone;
                            }
                            // if (email!=null) {
                            //   body['email']=email;
                            // }
                            if (body.keys.isNotEmpty || file!=null) {
                              context.read<SettingProvider>().doCallUpdateProfile(body , file, context);
                            }
                          }),
                      ),
                    ),
                    SizedBox(height: 9,)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }}