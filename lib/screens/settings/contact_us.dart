import 'package:bookthera_customer_1/components/custom_loader.dart';
import 'package:bookthera_customer_1/components/custom_textfields.dart';
import 'package:bookthera_customer_1/screens/settings/setting_provider.dart';
import 'package:bookthera_customer_1/utils/datamanager.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textform_field.dart';
import '../../utils/Constants.dart';
import '../../utils/helper.dart';
import '../../utils/resources/Colors.dart';

class ContactUs extends StatefulWidget {
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  // const ContactUs({super.key});
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  String? firstName, lastName,email,message;

  @override
  void initState() {
    super.initState();
    firstNameController.text=Datamanager().firstName;
    lastNameController.text=Datamanager().lastName;
    emailController.text=Datamanager().email;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Contact Us',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    child: Column(
                  children: [
                    CustomTextFormField(
                      controller: firstNameController,
                      hintText: "First Name",
                      isEditable: false,
                      focusNode: AlwaysDisabledFocusNode(),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                    ),
                    SizedBox(height: 16,),
                    CustomTextFormField(
                      controller: lastNameController,
                      hintText: "Last Name",
                       isEditable: false,
                      focusNode: AlwaysDisabledFocusNode(),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                    ),
                    SizedBox(height: 16,),
                    CustomTextFormField(
                          controller: emailController,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          isEditable: false,
                      focusNode: AlwaysDisabledFocusNode(),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        SizedBox(height: 16,),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                      child: CustomTextField(
                            textEditingController: messageController,
                            hint: "Message",
                            onSubmitted: (String? val) {
                              message = val;
                            },
                            maxLines: 6,
                          ),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 87.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      color: colorAccent,
                      borderRadius: 8,
                      title: 'Send', onPressed: (){
                        if (messageController.text.isEmpty) {
                          toast('Message field is required');
                          return;
                        }
                        context.read<SettingProvider>().doCallContactUs(messageController.text, context);
                      }),
                  ),
                ),
                SizedBox(height: 9,)
              ],
            ),
          ),
        ),
      ),
    );
  }}