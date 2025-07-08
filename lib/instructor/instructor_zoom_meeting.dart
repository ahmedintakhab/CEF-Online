import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';

import '../zoom/video_grid.dart';
import '../zoom/zoom_event_handler.dart';
import '../zoom/zoom_screen_share.dart';
import '../instructor/zoom_buttons_controllbar.dart';

class InstructorZoomMeeting extends StatefulWidget {
  final String lessonId;
  final String meetingId;

  const InstructorZoomMeeting({
    required this.lessonId,
    required this.meetingId,
    super.key,
  });

  @override
  State<InstructorZoomMeeting> createState() => _InstructorZoomMeetingState();
}

class _InstructorZoomMeetingState extends State<InstructorZoomMeeting> {
  bool isLoading = true;
  String? sessionName;
  String? sdkKey;
  String? signature;
  String? meetingPassword;
  String errorMessage = '';
  Map<String, dynamic> apiResponse = {};
  Map<String, dynamic> updateSignatureResponse = {};
  var zoom = ZoomVideoSdk();
  var eventListener = ZoomVideoSdkEventListener();
  final isSharing = ValueNotifier<bool>(false);
  final sharingUser = ValueNotifier<ZoomVideoSdkUser?>(null);
  final isInSession = ValueNotifier<bool>(false);
  String sessionNameNotifier = '';
  String sessionPassword = '';
  final users = ValueNotifier<List<ZoomVideoSdkUser>>([]);
  final isMuted = ValueNotifier<bool>(false);
  final isSpeakerOn = ValueNotifier<bool>(false);
  final isVideoOn = ValueNotifier<bool>(false);
  String? localUserId;
  bool _sdkInitialized = false;

  @override
  void initState() {
    super.initState();
    _startZoomFlow();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute.of(context)?.addScopedWillPopCallback(_onWillPop);
  }

  Future<bool> _onWillPop() async {
    try {
      await zoom.leaveSession(true);
      await zoom.cleanup();
    } catch (_) {}
    return true;
  }

  Future<void> _startZoomFlow() async {
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted) {
      await _initializeZoomSdk();
      await _fetchZoomMeetingDetails();
    } else {
      setState(() {
        errorMessage = 'Permissions are required to proceed.';
        isLoading = false;
      });
      if (statuses[Permission.camera]!.isPermanentlyDenied || statuses[Permission.microphone]!.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  Future<void> _initializeZoomSdk() async {
    if (_sdkInitialized) return;
    try {
      InitConfig initConfig = InitConfig(
        domain: "zoom.us",
        enableLog: true,
      );
      await zoom.initSdk(initConfig);
      _sdkInitialized = true;
      _setupEventListeners();
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to initialize Zoom SDK: $e';
        isLoading = false;
      });
    }
  }

  void _setupEventListeners() {
    eventListener.addListener('onSessionJoin', (data) async {
      try {
        final mySelf = await zoom.session.getMySelf();
        final userId = mySelf?.userId.toString();
        final sessionName = await zoom.session.getSessionName() ?? '';
        final sessionPassword = await zoom.session.getSessionPassword() ?? '';
        final remoteUsers = await zoom.session.getRemoteUsers() ?? [];

        final muted = mySelf != null ? await mySelf.audioStatus?.isMuted() : false;
        final videoOn = mySelf != null ? await mySelf.videoStatus?.isOn() : false;
        final speakerOn = await zoom.audioHelper.getSpeakerStatus();

        setState(() {
          isInSession.value = true;
          localUserId = userId;
          sessionNameNotifier = sessionName;
          this.sessionPassword = sessionPassword;

          users.value = [if (mySelf != null) mySelf, ...remoteUsers];
          isMuted.value = muted ?? false;
          isSpeakerOn.value = speakerOn;
          isVideoOn.value = videoOn ?? false;
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Error in onSessionJoin listener: $e';
          isLoading = false;
        });
      }
    });

    eventListener.addListener('onUserJoin', (data) async {
      final newUsers = (await zoom.session.getRemoteUsers()) ?? [];
      final mySelf = await zoom.session.getMySelf();
      users.value = [if (mySelf != null) mySelf, ...newUsers];
    });

    eventListener.addListener('onUserLeave', (data) async {
      final remainingUsers = (await zoom.session.getRemoteUsers()) ?? [];
      final mySelf = await zoom.session.getMySelf();
      users.value = [if (mySelf != null) mySelf, ...remainingUsers];
    });

    eventListener.addListener('onSessionLeave', (data) async {
      await zoom.cleanup();
      setState(() {
        isInSession.value = false;
        users.value = [];
        localUserId = null;
        isSharing.value = false;
        sharingUser.value = null;
      });
    });

    eventListener.addListener('onUserShareStatusChanged', (data) async {
      data = data as Map;
      ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
      ZoomVideoSdkUser shareUser = ZoomVideoSdkUser.fromJson(jsonDecode(data['user'].toString()));
      dynamic shareAction = jsonDecode(data['shareAction'].toString());

      if (shareAction.shareStatus == ShareStatus.Start || shareAction.shareStatus == ShareStatus.Resume) {
        sharingUser.value = shareUser;
        isSharing.value = (shareUser.userId == mySelf?.userId);
      } else {
        sharingUser.value = null;
        isSharing.value = false;
      }
      setState(() {});
    });
  }

  Future<void> _fetchZoomMeetingDetails() async {
    try {
      final String apiUrl = "${ApiConstants.baseUrl}student/start-zoom-class";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'lesson_id': widget.lessonId,
          'meeting_id': widget.meetingId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          apiResponse = responseData;
          sessionName = responseData['session_name'].toString();
          meetingPassword = responseData['meeting_password'].toString();
          sdkKey = responseData['sdkKey'].toString();
        });

        await _generateZoomToken(token);
      } else {
        setState(() {
          errorMessage = 'Failed to fetch meeting details: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching meeting details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _generateZoomToken(String token) async {
    try {
      final String apiUrl = "${ApiConstants.baseUrl}student/generate_zoom_token";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'sdk_key': sdkKey,
          'sessionName': sessionName,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          signature = responseData['signature'].toString();
        });

        await _updateZoomSignature(token);
      } else {
        setState(() {
          errorMessage = 'Failed to generate Zoom token: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error generating Zoom token: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _updateZoomSignature(String token) async {
    try {
      final String apiUrl = "${ApiConstants.baseUrl}student/update-zoom-signature";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'meeting_id': widget.meetingId,
          'meeting_signature': signature,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          updateSignatureResponse = json.decode(response.body);
          isLoading = false;
        });

        await _joinZoomSession();
      } else {
        setState(() {
          errorMessage = 'Failed to update Zoom signature: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error updating Zoom signature: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _joinZoomSession() async {
    try {
      Map<String, bool> audioOptions = {'connect': true, 'mute': false, 'noLocalFeedback': true};
      Map<String, bool> videoOptions = {'localVideoOn': true};

      JoinSessionConfig joinConfig = JoinSessionConfig(
        sessionName: sessionName!,
        sessionPassword: meetingPassword!,
        token: signature!,
        userName: 'Instructor',
        audioOptions: audioOptions,
        videoOptions: videoOptions,
      );

      await zoom.joinSession(joinConfig);
    } catch (e) {
      setState(() {
        errorMessage = 'Error joining Zoom session: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    ModalRoute.of(context)?.removeScopedWillPopCallback(_onWillPop);
    isInSession.dispose();
    users.dispose();
    isMuted.dispose();
    isSpeakerOn.dispose();
    isVideoOn.dispose();
    isSharing.dispose();
    sharingUser.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF8CC13F)),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      print('Check the sdk error: $errorMessage');
      return Scaffold(
        body: Center(
          child: Text(
            errorMessage,
            style: TextStyle(fontSize: 16.sp, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<bool>(
        valueListenable: isInSession,
        builder: (context, inSession, child) {
          if (inSession && localUserId != null) {
            return ValueListenableBuilder<List<ZoomVideoSdkUser>>(
              valueListenable: users,
              builder: (context, userList, _) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: VideoGrid(
                        users: users.value,
                        localUserId: localUserId,
                      ),
                    ),
                    ZoomButtonsControllbar(
                      isMuted: isMuted,
                      isVideoOn: isVideoOn,
                      onLeaveSession: () async {
                        try {
                          await zoom.leaveSession(true);
                          await zoom.cleanup();
                        } catch (_) {}
                        setState(() {
                          isInSession.value = false;
                          users.value = [];
                          localUserId = null;
                        });
                      },
                    ),
                    ZoomScreenShareWidget(
                      zoom: zoom,
                      isSharing: isSharing,
                      sharingUser: sharingUser,
                      isInstructor: true,
                    ),
                  ],
                );
              },
            );
          }
          return Center(
            child: Text(
              "Joining Zoom session...",
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          );
        },
      ),
    );
  }
}
