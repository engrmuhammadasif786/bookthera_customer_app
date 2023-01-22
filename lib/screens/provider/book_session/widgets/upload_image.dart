import 'dart:io';

import 'package:bookthera_customer_1/components/custom_button.dart';
import 'package:bookthera_customer_1/screens/provider/book_session/book_session_provider.dart';
import 'package:bookthera_customer_1/utils/Constants.dart';
import 'package:bookthera_customer_1/utils/resources/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../utils/helper.dart';

class UploadImage extends StatelessWidget {
  const UploadImage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    File? image = context.watch<BookSesstionProvider>().image;
    dynamic provider=image!=null? FileImage(image):NetworkImage(placehorder);
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, left: 32, right: 32),
      child: Column(
        children: <Widget>[
          Text('Picture of Yourself*',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: textColorPrimary)),
          Text('(needed for seession)',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: textColorPrimary)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ClipOval(
                child: Container(
              width: 130,
              height: 130,
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
                borderRadius: 15,
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
