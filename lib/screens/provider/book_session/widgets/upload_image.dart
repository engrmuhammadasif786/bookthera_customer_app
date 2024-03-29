import 'dart:io';

import 'package:bookthera_customer/components/custom_button.dart';
import 'package:bookthera_customer/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/datamanager.dart';
import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:bookthera_customer/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../utils/helper.dart';

class UploadImage extends StatelessWidget {
  // const UploadImage({super.key});

  File? image ;
  dynamic provider;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    image=context.watch<BookSesstionProvider>().image;
    String userProfileImage = getStringAsync(USER_PROFILE);
    if (userProfileImage.isEmpty && image==null) {
      provider=AssetImage('assets/images/person_placeholder.png');
    }else{
      provider = image!=null? FileImage(image!):NetworkImage(Datamanager().profile);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 32, right: 32),
      child: Column(
        children: <Widget>[
          Text('Picture of Yourself*',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getFontSize(15),
                  color: textColorPrimary)),
          Text('(needed for seession)',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: getFontSize(13),
                  color: textColorPrimary)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ClipOval(
                child: Container(
              width: getSize(108),
              height: getSize(108),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(130 / 2)),
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.cover,
                  )),
            )),
          ),
          SizedBox(
            width: size.width * 0.4,
            child: CustomButton(
                borderRadius: getSize(15),
                title: image==null? 'Upload':'Edit',
                onPressed: () async {
                  ImagePicker _imagePicker = ImagePicker();
                  XFile? image =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    context
                        .read<BookSesstionProvider>()
                        .setImage(File(image.path));
                  }
                }),
          )
        ],
      ),
    );
  }
}
