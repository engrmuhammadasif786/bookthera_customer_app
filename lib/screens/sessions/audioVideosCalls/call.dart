import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bookthera_provider/components/custom_loader.dart';
import 'package:bookthera_provider/screens/sessions/session_provider.dart';
import 'package:bookthera_provider/screens/sessions/widgets/report_no_show.dart';
import 'package:bookthera_provider/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

const appId = agoraAppId;
var token = aograToken;

class AudioVideoScreen extends StatefulWidget {
  const AudioVideoScreen({Key? key,this.channelName=''}) : super(key: key);
  final  String channelName;

  @override
  State<AudioVideoScreen> createState() => _AudioVideoScreenState();
}

class _AudioVideoScreenState extends State<AudioVideoScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool muted = false;
  bool speaker = false;
  bool video = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((time){
      context.read<SessionProvider>().doCallGetAgoraToken(widget.channelName).then((value) {
        token=value;
        initAgora();
      });
    });
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();

    String userID=getStringAsync(USER_ID);
    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: int.parse(userID.substring(userID.length-5) ,radix: 16),
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _engine.leaveChannel();
    _engine.disableVideo();
    _engine.stopPreview();
    _engine.unregisterEventHandler(RtcEngineEventHandler());
    _engine.release(sync: true);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: context.watch<SessionProvider>().isLoading,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black,),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 135,
                height: 177,
                margin: EdgeInsets.only(left: 35),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white
                ),
                child: Center(
                  child: _localUserJoined
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          ),
                      )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            _toolbar()
          ],
        ),
      ),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    // if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: RawMaterialButton(
                  onPressed: _onToggleSpeaker,
                  child: Icon(
                    speaker ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
              Expanded(
                child: RawMaterialButton(
                  onPressed: _onToggleVideo,
                  child: Icon(
                    video ? Icons.videocam_off : Icons.videocam,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
              Expanded(
                child: RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 37.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.red,
                  padding: const EdgeInsets.all(18.0),
                ),
              ),
              Expanded(
                child: RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
              Expanded(
                child: RawMaterialButton(
                  onPressed: _onToggleReport,
                  child: Image.asset('assets/icons/report_icon.png',
                      height: 34, width: 34, color: Colors.white),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Session Time',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '20:00',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 22),
            ),
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Text(
        'Waiting on Provider',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
      );
    }
  }

  void _onToggleSpeaker() {
    setState(() {
      speaker = !speaker;
    });
    _engine.setEnableSpeakerphone(speaker);
  }

  void _onToggleVideo() {
    setState(() {
      video = !video;
    });
    _engine.muteLocalVideoStream(video);
  }

  void _onToggleReport() {
    showDialog(context: context, builder: (context)=>ReportNoShow());
  }
}
