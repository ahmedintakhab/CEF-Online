import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../instructor/zoom_buttons_controllbar.dart';
import '../utils/api_constants.dart';
import 'dart:convert';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
import 'package:flutter_zoom_videosdk/flutter_zoom_view.dart' as flutter_zoom_view;
import 'package:permission_handler/permission_handler.dart';

import '../zoom/zoom_event_handler.dart';

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

  final isInSession = ValueNotifier<bool>(false);
  String sessionNameNotifier = '';
  String sessionPassword = '';
  final users = ValueNotifier<List<dynamic>>([]);
  final isMuted = ValueNotifier<bool>(false);
  final isSpeakerOn = ValueNotifier<bool>(false);
  final isVideoOn = ValueNotifier<bool>(false);
  String? localUserId;

  @override
  void initState() {
    super.initState();
    _startZoomFlow();
  }

  Future<void> _startZoomFlow() async {
    await _requestPermissions(); // Wait for permission before continuing
  }

  Future<void> _requestPermissions() async {
    print("Requesting permissions...");
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
    print("Enter in initialize zoom sdk function:");
    try {
      InitConfig initConfig = InitConfig(
        domain: "zoom.us",
        enableLog: true,
      );

      // You do NOT need to call setZoomVideoSdkEventListener
      await zoom.initSdk(initConfig);
      print('SDK initialized');

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
      print('✅ onSessionJoin triggered');
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
      print('👥 onUserJoin: $data');
      final newUsers = (await zoom.session.getRemoteUsers()) ?? [];
      final mySelf = await zoom.session.getMySelf();

      // Combine current users
      users.value = [if (mySelf != null) mySelf, ...newUsers];
    });

    eventListener.addListener('onUserLeave', (data) async {
      print('🚪 onUserLeave: $data');
      final remainingUsers = (await zoom.session.getRemoteUsers()) ?? [];
      final mySelf = await zoom.session.getMySelf();

      users.value = [if (mySelf != null) mySelf, ...remainingUsers];
    });

    eventListener.addListener('onSessionLeave', (data) async {
      print('❌ onSessionLeave triggered');
      setState(() {
        isInSession.value = false;
        users.value = [];
        localUserId = null;
      });
    });

    eventListener.addListener('*', (dynamic data) {
      print('🔥 [Zoom Event] => $data');
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
        print('Zoom Meeting API Response: $responseData');

        if (responseData['session_name'] == null || responseData['meeting_password'] == null || responseData['sdkKey'] == null) {
          setState(() {
            errorMessage = 'Invalid meeting details';
            isLoading = false;
          });
          return;
        }

        setState(() {
          apiResponse = responseData;
          sessionName = responseData['session_name'].toString();
          meetingPassword = responseData['meeting_password'].toString();
          sdkKey = responseData['sdkKey'].toString();
        });

        await _generateZoomToken(token);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        setState(() {
          errorMessage = 'Failed to fetch meeting details: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Exception: $e');
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
        print('Generate Zoom Token API Response: $responseData');

        if (responseData['signature'] == null) {
          setState(() {
            errorMessage = 'Invalid token response: signature is missing';
            isLoading = false;
          });
          return;
        }

        setState(() {
          signature = responseData['signature'].toString();
        });

        await _updateZoomSignature(token);
      } else {
        print('Generate Zoom Token API Error: ${response.statusCode} - ${response.body}');
        setState(() {
          errorMessage = 'Failed to generate Zoom token: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Generate Zoom Token Exception: $e');
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
        final responseData = json.decode(response.body);
        print('Update Zoom Signature API Response: $responseData');

        setState(() {
          updateSignatureResponse = responseData;
          isLoading = false;
        });

        await _joinZoomSession();
      } else {
        print('Update Zoom Signature API Error: ${response.statusCode} - ${response.body}');
        setState(() {
          errorMessage = 'Failed to update Zoom signature: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Update Zoom Signature Exception: $e');
      setState(() {
        errorMessage = 'Error updating Zoom signature: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _joinZoomSession() async {
    print('Enter in joinsession function:');
    try {
      if (sessionName == null || sessionName!.isEmpty || signature == null || signature!.isEmpty || meetingPassword == null) {
        setState(() {
          errorMessage = 'Session name, signature, or meeting password is missing or empty';
          isLoading = false;
        });
        return;
      }

      Map<String, bool> audioOptions = {'connect': true, 'mute': false};
      Map<String, bool> videoOptions = {'localVideoOn': true};
      JoinSessionConfig joinConfig = JoinSessionConfig(
        sessionName: sessionName!,
        sessionPassword: meetingPassword!,
        token: signature!,
        userName: 'Student',
        audioOptions: audioOptions,
        videoOptions: videoOptions,
      );
      print('Joining Zoom session with: sessionName=$sessionName, signature=$signature');
      await zoom.joinSession(joinConfig);
    } catch (e) {
      print('Join Zoom Session Exception: $e');
      setState(() {
        errorMessage = 'Error joining Zoom session: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    isInSession.dispose();
    users.dispose();
    isMuted.dispose();
    isSpeakerOn.dispose();
    isVideoOn.dispose();
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
          print('Check inSession: $inSession, localUserId: $localUserId');
          if (inSession && localUserId != null) {
            return ValueListenableBuilder<List<dynamic>>(
              valueListenable: users,
              builder: (context, userList, _) {
                return Stack(
                  children: [
                    // Full screen for selected user
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: VideoView(
                        user: users.value.firstWhere((u) => u.userId.toString() == localUserId),
                        hasMultiCamera: false,
                        sharing: false,
                        preview: false,
                        focused: true,
                        multiCameraIndex: "0",
                        videoAspect: null,
                        fullScreen: true,
                      ),
                    ),

                    // Scrollable bottom thumbnails
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 110,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: users.value.length,
                          itemBuilder: (context, index) {
                            final user = users.value[index];
                            return InkWell(
                              onTap: () {
                                // Optional: Add logic to change fullScreenUser.value
                              },
                              child: VideoView(
                                user: user,
                                hasMultiCamera: false,
                                sharing: false,
                                preview: false,
                                focused: false,
                                multiCameraIndex: "0",
                                videoAspect: null,
                                fullScreen: false,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                        ),
                      ),
                    ),
                    ZoomButtonsControllbar(
                      isMuted: isMuted.value,
                      isVideoOn: isVideoOn.value,
                      onLeaveSession: () {
                        setState(() {
                          isInSession.value = false;
                          users.value = [];
                          localUserId = null;
                        });
                      },
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
