import 'dart:io';

import 'package:bookthera_customer/utils/resources/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoViewer extends StatefulWidget {
  final String videoUrl;
  final String heroTag;
  final File? videoFile;

  const FullScreenVideoViewer({Key? key, required this.videoUrl, required this.heroTag, this.videoFile}) : super(key: key);

  @override
  _FullScreenVideoViewerState createState() => _FullScreenVideoViewerState();
}

class _FullScreenVideoViewerState extends State<FullScreenVideoViewer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoFile == null ? VideoPlayerController.network(widget.videoUrl) : VideoPlayerController.file(widget.videoFile!)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          
        });
      })..play();
    _controller.setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
          color: Colors.black,
          child: Hero(
            tag: widget.videoUrl,
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          )),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.4),
        heroTag: widget.heroTag,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        color: colorPrimary,
        size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
