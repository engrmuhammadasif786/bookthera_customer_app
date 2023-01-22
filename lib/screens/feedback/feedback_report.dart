import 'dart:convert';
import 'dart:io';

import 'package:bookthera_customer_1/components/custom_appbar.dart';
import 'package:bookthera_customer_1/components/custom_button.dart';
import 'package:bookthera_customer_1/components/custom_loader.dart';
import 'package:bookthera_customer_1/components/custom_persent_loader.dart';
import 'package:bookthera_customer_1/screens/sessions/widgets/feed_back_success.dart';
import 'package:bookthera_customer_1/utils/datamanager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_textfields.dart';
import '../../../utils/resources/Colors.dart';
import '../../utils/helper.dart';
import '../inbox/chat_provider.dart';
import 'package:video_player/video_player.dart';

class FeedbackReport extends StatefulWidget {
  @override
  State<FeedbackReport> createState() => _FeedbackReportState();
}

class _FeedbackReportState extends State<FeedbackReport> {
  // const FeedbackReport({super.key});
  TextEditingController bugController = TextEditingController();

  bool isFileSelected = false;
  VideoPlayerController? _controller;
  File? selectedFile;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    ChatProvider chatProvider = context.watch<ChatProvider>();
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Report a Bug',
      ),
      body: CustomLoader(
        isLoading: chatProvider.isLoading,
        // persent: chatProvider.persent,
        child: Container(
          padding: EdgeInsets.all(14),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 11.0, top: 8),
                  child: Text('Please give a description of the bug',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: textColorPrimary)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomTextField(
                    textEditingController: bugController,
                    maxLines: 12,
                    hint: 'Write text here...',
                  ),
                ),
                if (isFileSelected)
                  previewMedia(size)
                else
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                onUpload(context, true);
                              },
                              child: Container(
                                height: 65,
                                width: 65,
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorPrimary),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.photo_library_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text('Upload\nScreenshot',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: textColorPrimary)),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                onUpload(context, false);
                              },
                              child: Container(
                                height: 65,
                                width: 65,
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorPrimary),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text('Upload Screen\nRecording',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: textColorPrimary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 75.0),
                  child: SizedBox(
                    width: size.width,
                    child: CustomButton(
                        color: colorAccent,
                        borderRadius: 8,
                        title: 'Submit',
                        onPressed: onSubmit),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onUpload(BuildContext context, bool isImage) async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? file;
    if (isImage) {
      file = await _imagePicker.pickImage(source: ImageSource.gallery);
      _controller = null;
      selectedFile = isIOS? await compressImage(File(file!.path)):File(file!.path);
    } else {
      file = await _imagePicker.pickVideo(source: ImageSource.gallery);
      _controller = VideoPlayerController.file(File(file!.path))
        ..initialize().then((_) {
          _controller!.pause();
          setState(() {});
        });
      
      selectedFile = File(file.path);
    }
    print(selectedFile!.path.split('/').last);
    setState(() {
      isFileSelected = true;
    });
  }

  onSubmit() async {
    if (bugController.text.isEmpty) {
      return toast('Please provide bug description');
    }
    Map data = {
      'type': 'send-message',
      'payload': {
        'receiverId': Datamanager().adminId,
        'message': bugController.text.trim(),
        'bugSuggestionType': 'bug'
      }
    };
    context.read<ChatProvider>().channel.sink.add(jsonEncode(data)); // message
    if (selectedFile != null) {
      await context.read<ChatProvider>().doCallMediaUpload(selectedFile!);
      List url = context.read<ChatProvider>().mediaFile;
      if (url.isNotEmpty) {
        Map data = {
          'type': 'send-message',
          'payload': {
            'receiverId': Datamanager().adminId,
            'mediaFile': url.first,
            'bugSuggestionType': 'bug'
          }
        };
        context
            .read<ChatProvider>()
            .channel
            .sink
            .add(jsonEncode(data)); // media file
      }
    }
    bugController.clear();
    isFileSelected = false;
    selectedFile = null;
    showDialog(context: context, builder: (context) => FeedbackSuccess());
  }

  Widget previewMedia(Size size) {
    if (_controller != null) {
      // video
      return Container(
        height: size.height * 0.15,
        width: size.width * 0.3,
        margin: EdgeInsets.only(right: 8, top: 16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: VideoPlayer(_controller!)),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFile = null;
                    isFileSelected = false;
                    _controller = null;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.cancel),
                ))
          ],
        ),
      );
    } else {
      // image
      return Container(
        height: size.height * 0.15,
        width: size.width * 0.3,
        margin: EdgeInsets.only(right: 8, top: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: FileImage(selectedFile!), fit: BoxFit.cover)),
        alignment: Alignment.topRight,
        child: GestureDetector(
            onTap: () {
              setState(() {
                selectedFile = null;
                isFileSelected = false;
                _controller = null;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.cancel),
            )),
      );
    }
  }
}
