import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import 'dart:convert';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';

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
  String errorMessage = '';
  Map<String, dynamic> apiResponse = {};
  Map<String, dynamic> updateSignatureResponse = {};
  var zoom = ZoomVideoSdk();


  @override
  void initState() {
    super.initState();
    _fetchZoomMeetingDetails();
    InitConfig initConfig = InitConfig(
      domain: "zoom.us",
      enableLog: true,
    );
    zoom.initSdk(initConfig);
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

        setState(() {
          apiResponse = responseData;
          sessionName = responseData['session_name'];
          sdkKey = responseData['sdkKey'];
        });

        // Call the generate zoom token API after fetching meeting details
        await _generateZoomToken(token);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
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

        setState(() {
          signature = responseData['signature'];
        });

        // Call the update zoom signature API after generating the token
        await _updateZoomSignature(token);
      } else {
        print('Generate Zoom Token API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Generate Zoom Token Exception: $e');

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
      } else {
        print('Update Zoom Signature API Error: ${response.statusCode} - ${response.body}');

      }
    } catch (e) {
      print('Update Zoom Signature Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF8CC13F),
          ),
        ),
      );
    }

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zoom Meeting Details',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),


          ],
        ),
      ),
    );
  }
}