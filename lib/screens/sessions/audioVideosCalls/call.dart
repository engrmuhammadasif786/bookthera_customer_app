import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bookthera_customer/components/custom_loader.dart';
import 'package:bookthera_customer/screens/sessions/session_provider.dart';
import 'package:bookthera_customer/screens/sessions/widgets/report_no_show.dart';
import 'package:bookthera_customer/utils/Constants.dart';
import 'package:bookthera_customer/utils/CloudRecordingManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../network/RestApis.dart';
import '../../../utils/Common.dart';
import '../../../utils/datamanager.dart';

const appId = agoraAppId;
var token = '';
final timerKey = GlobalKey<_CountDownState>();

class AudioVideoScreen extends StatefulWidget {
  const AudioVideoScreen(
      {Key? key,
      required this.channelName,
      required this.sessionId,
      required this.providerId,
      this.sessionTime = '',
      this.type = 'audio'})
      : super(key: key);
  final String channelName;
  final String sessionId;
  final String providerId;
  final String type;
  final String sessionTime;

  @override
  State<AudioVideoScreen> createState() => _AudioVideoScreenState();
}

class _AudioVideoScreenState extends State<AudioVideoScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  bool muted = false;
  bool speaker = false;
  bool video = false;
  late final RtcEngineEx _engine;
  CloudRecordingManager cloudRecordingManager = CloudRecordingManager();
  String? filePath;
  
  get remoteUid => _remoteUid;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((time) {
      context
          .read<SessionProvider>()
          .doCallGetAgoraToken(widget.channelName, widget.sessionId)
          .then((value) {
        token = value;
        print("Calling initAgora");
        initAgora();
      });
    });
  }

  Future<void> initAgora() async {
    String? dirPath = await getCachedDirPath();
    if(dirPath!=null) filePath="${dirPath}/audio_file.WAV";
    
    // retrieve permissions
    if (widget.type == 'audio') {
      await [Permission.microphone].request();
    } else {
      await [Permission.microphone, Permission.camera].request();
    }

    //create the engine
    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    initHandlers();

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    if (widget.type == 'video') {
      await _engine.enableVideo();
      await _engine.startPreview();
    }
    await _engine.enableAudio();

    // String userID = getStringAsync(USER_ID);
    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      // uid: int.parse(userID.substring(userID.length - 1), radix: 16),
      uid: 0,
      options: ChannelMediaOptions(
          publishCameraTrack: widget.type == 'video',
          publishMicrophoneTrack: true,enableAudioRecordingOrPlayout: true),
    );
    log('join channel success');
  }

  void initHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          if (widget.type == 'video' && Datamanager().isRecordVideo)
            cloudRecordingManager.startCloudRecording(
                widget.channelName, token);
          _engine.startAudioRecording(
              AudioRecordingConfiguration(filePath:  filePath));
          setState(() {
            _localUserJoined = true;
          });
        },
        onLeaveChannel: (connection, stats) {},
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) async {
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
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return CustomLoader(
      isLoading: context.watch<SessionProvider>().isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
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
                    color: Colors.white),
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
          _remoteUid != null
              ? CountDown(widget: widget,key: timerKey,)
              : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${widget.sessionTime}:00',
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

  Future<void> _onCallEnd(BuildContext context) async {
    // save audio and video file (optional)
    if (widget.type == 'video' && Datamanager().isRecordVideo)
      cloudRecordingManager.stopCloudRecording(
          widget.channelName, token, widget.sessionId);
    saveAudioFile();

    // Disable audio and video
    if (widget.type == 'video') {
      _engine.disableVideo();
    }
    _engine.disableAudio();

    // Leave the channel and release the engine
    _engine.leaveChannel();
    _engine.release();

    // Pop the current screen
    Navigator.pop(context);
  }

  void saveAudioFile() {
    _engine.stopAudioRecording().then((value) {
      if (filePath != null) {
        final file = File(filePath!);
        callUploadMedia(file, (persent) {}) // upload media to server
            .then((uploadedFilePath) {
          if (uploadedFilePath != null) {
            if (uploadedFilePath['url'] != null) {
              callUpdateBookSession(// update media path to session
                  {"audioRecording": uploadedFilePath['url']},
                  widget.sessionId);
            }
          }
        });
      }
    });
  }

  Future<void> _onToggleMute() async {
    await _engine.enableLocalAudio(muted);
    setState(() {
      muted = !muted;
    });
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

  Future<void> _onToggleSpeaker() async {
    await _engine.setEnableSpeakerphone(speaker);
    setState(() {
      speaker = !speaker;
    });
  }

  Future<void> _onToggleVideo() async {
    await _engine.muteLocalVideoStream(video);
    setState(() {
      video = !video;
    });
  }

  void _onToggleReport() {
    showDialog(context: context, builder: (context) => ReportNoShow(sessionId: widget.sessionId,providerId: widget.providerId, waitingtime: timerKey.currentState!=null? timerKey.currentState!.waitingTime:'',));
  }
}

class CountDown extends StatefulWidget {
  const CountDown({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final AudioVideoScreen widget;

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late Timer _timer;
  int start = 0;
  String get waitingTime {
    int maxTime = int.parse(widget.widget.sessionTime) * 60;
    return '${((maxTime - start) / 60).floor().toString().padLeft(2,'0')}:${((maxTime - start) % 60).toString().padLeft(2,'0')}';
  }

  void startTimer() {
    start = int.parse(widget.widget.sessionTime) * 60;
    log('timer started-->>>>>>');
    _timer = new Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => setState(() {
              start = start - 1;
              if (start == 0) _timer.cancel();
            }));
  }

  @override
  void initState() {
    if (widget.widget.sessionTime.isNotEmpty) startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '${(start / 60).floor().toString().padLeft(2,'0')}:${(start % 60).toString().padLeft(2,'0')}',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22),
      ),
    );
  }
}
