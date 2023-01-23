import 'dart:convert';
import 'dart:io';

import 'package:bookthera_provider/components/custom_appbar.dart';
import 'package:bookthera_provider/components/custom_button.dart';
import 'package:bookthera_provider/screens/sessions/widgets/feed_back_success.dart';
import 'package:bookthera_provider/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_textfields.dart';
import '../../../utils/resources/Colors.dart';
import 'package:video_player/video_player.dart';

import '../../components/custom_loader.dart';
import '../../utils/datamanager.dart';
import '../inbox/chat_provider.dart';

class FeedbackSuggestion extends StatefulWidget {
  @override
  State<FeedbackSuggestion> createState() => _FeedbackSuggestionState();
}

class _FeedbackSuggestionState extends State<FeedbackSuggestion> {
  // const FeedbackSuggestion({super.key});
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
        title: 'Make a Suggestion',
      ),
      body: CustomLoader(
        isLoading: chatProvider.isLoading,
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
                  child: Text('How can we make the app better?',
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.06),
                      child: Column(
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
                                  shape: BoxShape.circle, color: colorPrimary),
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
      file = await _imagePicker.pickImage(
          source: ImageSource.gallery);
      _controller = null;
    } else {
      file = await _imagePicker.pickVideo(source: ImageSource.gallery);
      _controller = VideoPlayerController.file(File(file!.path))
        ..initialize().then((_) {
          _controller!.pause();
          setState(() {});
        });
      
      selectedFile = null;
    }
    selectedFile = isIOS? await compressImage(File(file!.path)):File(file!.path);
    print(await selectedFile!.length() / 1e6);
    setState(() {
      isFileSelected = true;
    });
  }

  onSubmit() async {
    if (bugController.text.isEmpty) {
      return toast('Kinldy share your suggestion');
    }
    Map data = {
      'type': 'send-message',
      'payload': {
        'receiverId': Datamanager().adminId,
        'message': bugController.text.trim(),
        'bugSuggestionType': 'suggestion'
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
            'bugSuggestionType': 'suggestion'
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
