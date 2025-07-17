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

class StudentZoomMeeting extends StatefulWidget {
  final String lessonId;
  final String meetingId;

  const StudentZoomMeeting({
    required this.lessonId,
    required this.meetingId,
    super.key,
  });

  @override
  State<StudentZoomMeeting> createState() => _StudentZoomMeetingState();
}

class _StudentZoomMeetingState extends State<StudentZoomMeeting> {
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

    if (statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted) {
      await _initializeZoomSdk();
      await _fetchZoomMeetingDetails();
    } else {
      setState(() {
        errorMessage = 'Permissions are required to proceed.';
        isLoading = false;
      });
      if (statuses[Permission.camera]!.isPermanentlyDenied ||
          statuses[Permission.microphone]!.isPermanentlyDenied) {
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

  Future<List<ZoomVideoSdkUser>> _fetchRemoteUsersWithRetry({int retries = 3, Duration delay = const Duration(seconds: 1)}) async {
    for (int i = 0; i < retries; i++) {
      final remoteUsers = await zoom.session.getRemoteUsers() ?? [];
      print('� Bellamy FetchRemoteUsers attempt ${i + 1}: ${remoteUsers.length} users');
      if (remoteUsers.isNotEmpty) return remoteUsers;
      await Future.delayed(delay);
    }
    print('� Bellamy Failed to fetch remote users after $retries attempts');
    return [];
  }

  void _setupEventListeners() {
    eventListener.addListener('onSessionJoin', (data) async {
      try {
        final mySelf = await zoom.session.getMySelf();
        final remoteUsers = await _fetchRemoteUsersWithRetry();
        final sessionName = await zoom.session.getSessionName() ?? '';
        final sessionPassword = await zoom.session.getSessionPassword() ?? '';
        final muted = mySelf != null ? await mySelf.audioStatus?.isMuted() : false;
        final videoOn = mySelf != null ? await mySelf.videoStatus?.isOn() : false;
        final speakerOn = await zoom.audioHelper.getSpeakerStatus();

        setState(() {
          isInSession.value = true;
          localUserId = mySelf?.userId.toString();
          sessionNameNotifier = sessionName;
          this.sessionPassword = sessionPassword;
          users.value = [if (mySelf != null) mySelf, ...remoteUsers];
          isMuted.value = muted ?? false;
          isSpeakerOn.value = speakerOn;
          isVideoOn.value = videoOn ?? false;
          print('� Bellamy onSessionJoin: Users updated to ${users.value.length}');
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Error in onSessionJoin listener: $e';
          isLoading = false;
        });
      }
    });

    eventListener.addListener('onUserJoin', (data) async {
      try {
        final newUsers = await _fetchRemoteUsersWithRetry();
        final mySelf = await zoom.session.getMySelf();
        users.value = [if (mySelf != null) mySelf, ...newUsers];
        print('� Bellamy onUserJoin: Users updated to ${users.value.length}');
      } catch (e) {
        print('� Bellamy Error in onUserJoin: $e');
      }
    });

    eventListener.addListener('onUserLeave', (data) async {
      try {
        final remainingUsers = await _fetchRemoteUsersWithRetry();
        final mySelf = await zoom.session.getMySelf();
        users.value = [if (mySelf != null) mySelf, ...remainingUsers];
        print('� Bellamy onUserLeave: Users updated to ${users.value.length}');
      } catch (e) {
        print('� Bellamy Error in onUserLeave: $e');
      }
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

      print('� Bellamy Fetch meeting response status: ${response.statusCode}');
      print('� Bellamy Fetch meeting response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body) as Map<String, dynamic>;
        print('� Bellamy Parsed meeting data: $responseData');

        if (responseData.isEmpty) {
          setState(() {
            errorMessage = 'Invalid meeting details: Empty response';
            isLoading = false;
          });
          return;
        }

        setState(() {
          apiResponse = responseData;
          sessionName = responseData['session_name']?.toString();
          meetingPassword = responseData['meeting_password']?.toString();
          sdkKey = responseData['sdkKey']?.toString();
        });

        if (sessionName == null || meetingPassword == null || sdkKey == null) {
          setState(() {
            errorMessage = 'Missing required fields: session_name, meeting_password, or sdkKey';
            isLoading = false;
          });
          return;
        }

        print('� Bellamy Screen sharing enabled: ${responseData['screen_sharing_enabled']}');
        print('� Bellamy Screen sharing locked: ${responseData['lock_screen_sharing']}');

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
      Map<String, bool> audioOptions = {
        'connect': true,
        'mute': false,
        'noLocalFeedback': true
      };
      Map<String, bool> videoOptions = {'localVideoOn': true};

      JoinSessionConfig joinConfig = JoinSessionConfig(
        sessionName: sessionName!,
        sessionPassword: meetingPassword!,
        token: signature!,
        userName: 'Student',
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
      print('� Bellamy Check the sdk error: $errorMessage');
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
                print('� Bellamy Building VideoGrid with ${userList.length} users');
                return Stack(
                  children: [
                    Positioned.fill(
                      child: ValueListenableBuilder<ZoomVideoSdkUser?>(
                        valueListenable: sharingUser,
                        builder: (context, sharingUserValue, _) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: isSharing,
                            builder: (context, isSharingValue, _) {
                              return VideoGrid(
                                users: userList,
                                localUserId: localUserId,
                                sharingUser: sharingUserValue,
                                isSharing: isSharingValue,
                              );
                            },
                          );
                        },
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
                      isInstructor: false,
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