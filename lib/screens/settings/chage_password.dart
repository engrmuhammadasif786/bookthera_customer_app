import 'package:bookthera_provider/components/custom_button.dart';
import 'package:bookthera_provider/components/custom_loader.dart';
import 'package:bookthera_provider/components/custom_textform_field.dart';
import 'package:bookthera_provider/screens/settings/setting_provider.dart';
import 'package:bookthera_provider/utils/Constants.dart';
import 'package:bookthera_provider/utils/datamanager.dart';
import 'package:bookthera_provider/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../components/custom_appbar.dart';
import '../../utils/helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? password, confirmPassword;

  @override
  void initState() {
    super.initState();
    oldPasswordController.text = getStringAsync(PASSWORD);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SettingProvider settingProviderTrue = context.watch<SettingProvider>();
    SettingProvider settingProviderFalse = context.read<SettingProvider>();
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Change Password',
      ),
      body: CustomLoader(
        isLoading: context.watch<SettingProvider>().isLoading,
        child: SingleChildScrollView(
          child: Container(
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
              children: [
                Form(
                  key: _key,
                  autovalidateMode: _validate,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: oldPasswordController,
                        hintText: 'Old Password',
                        isEditable: false,
                        focusNode: AlwaysDisabledFocusNode(),
                        obscureText: !settingProviderTrue.isOldPasswordVisible,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              settingProviderFalse.setIsOldPasswordVisible();
                            },
                            icon: Icon(Icons.visibility_outlined)),
                      ),
                      CustomTextFormField(
                        controller: passwordController,
                        hintText: 'Password',
                        validator: validatePassword,
                        obscureText: !settingProviderTrue.isPasswordVisible,
                        onSaved: (String? val) {
                          password = val;
                        },
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              settingProviderFalse.setIsPasswordVisible();
                            },
                            icon: Icon(Icons.visibility_outlined)),
                      ),
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: !settingProviderTrue.isConPasswordVisible,
                        suffixIcon: IconButton(
                            onPressed: () {
                              settingProviderFalse.setIsConPasswordVisible();
                            },
                            icon: Icon(Icons.visibility_outlined)),
                        validator: (value) {
                          return validateConfirmPassword(
                              passwordController.text, value);
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
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, top: 40),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: CustomButton(
                      borderRadius: 8,
                      color: colorAccent,
                        title: 'Update Password', onPressed: updatePassword),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  updatePassword() async {
    if (_key.currentState?.validate() ?? false) {
      _key.currentState!.save();
      if (password==null || confirmPassword==null) {
        return;
      }
      Map request = {};
      request['oldPassword'] = oldPasswordController.text.trim();
      request['newPassword'] = passwordController.text.trim();
      request['confirmPassword'] = confirmPasswordController.text.trim();
      await Provider.of<SettingProvider>(context, listen: false)
          .doCallUpdatePassword(request, context);
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }
}
