import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'instructor_zoom_meeting.dart';
import '../utils/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // Import for Timer

class InstructorIndividualScheduleClass extends StatefulWidget {
  final List<dynamic> classes;
  const InstructorIndividualScheduleClass({required this.classes, super.key});

  @override
  State<InstructorIndividualScheduleClass> createState() => _InstructorIndividualScheduleClassState();
}

class _InstructorIndividualScheduleClassState extends State<InstructorIndividualScheduleClass> {
  Timer? _timer;
  List<dynamic> _classes = []; // Local state to hold classes data

  @override
  void initState() {
    super.initState();
    // Initialize local classes data
    _classes = List.from(widget.classes);
    print("Initial classes count: ${_classes.length}"); // Debug print

    // Start the timer to call StartClassFunction every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      StartClassFunction();
    });
    // Call the function immediately on init to avoid waiting for the first minute
    StartClassFunction();
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _timer?.cancel();
    super.dispose();
  }

  // API function to check lesson start time and update UI
  Future<void> StartClassFunction() async {
    final String apiUrl = "${ApiConstants.baseUrl}instructor/checkLessonStartTime";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Check start lesson function api response: ${response.statusCode}");
        print("API Response Body: ${response.body}"); // Debug print

        // Parse the response
        final responseData = jsonDecode(response.body);
        print("Parsed Response Data: $responseData"); // Debug print

        // Check if the API returns lesson status update
        if (responseData is Map<String, dynamic> && responseData.containsKey('id')) {
          // API returned a specific lesson update
          String lessonId = responseData['id'].toString();
          String meetingId = responseData['meeting_id']?.toString() ?? '';

          print("Lesson status update received for lesson ID: $lessonId");
          print("Meeting ID: $meetingId");

          // Update the specific lesson in the classes list
          bool lessonFound = false;
          setState(() {
            for (int i = 0; i < _classes.length; i++) {
              var classData = _classes[i];

              // Check if this class matches the lesson ID (direct ID field)
              if (classData['id']?.toString() == lessonId) {

                print("Found matching lesson at index $i");
                print("Current status: ${classData['status']?['btnText']}");

                // Update the button text to "In Progress" and add necessary fields
                if (classData['status'] != null) {
                  _classes[i]['status']['btnText'] = 'In Progress';
                  _classes[i]['status']['started'] = 1;

                  // For Google Meet, use the URL from API response
                  if (responseData['learning_tool'] == 'Google_Meet' && responseData['url'] != null) {
                    _classes[i]['status']['btnHref'] = responseData['url'];
                  } else {
                    _classes[i]['status']['btnHref'] = 'javascript:void(0);';
                  }

                  _classes[i]['status']['btnClass'] = responseData['learning_tool'] == 'Google_Meet'
                      ? 'google_meet_link'
                      : 'create_zoom_meeting_link';

                  // Add or update classDetails
                  if (_classes[i]['status']['classDetails'] == null) {
                    _classes[i]['status']['classDetails'] = {};
                  }

                  _classes[i]['status']['classDetails']['type'] = responseData['learning_tool'];
                  _classes[i]['status']['classDetails']['lesson_id'] = lessonId;
                  _classes[i]['status']['classDetails']['meeting_id'] = meetingId;
                  _classes[i]['status']['classDetails']['user_type'] = 'Tutor';
                  _classes[i]['status']['classDetails']['user_name'] = responseData['user_name'];
                  _classes[i]['status']['classDetails']['user_id'] = responseData['user_id'];

                  print("Updated lesson $lessonId status to 'In Progress'");
                  print("Button href set to: ${_classes[i]['status']['btnHref']}");
                  lessonFound = true;
                }
                break;
              }
            }
          });

          if (!lessonFound) {
            print("No matching lesson found for ID: $lessonId");
            // Print all lesson IDs for debugging
            for (int i = 0; i < _classes.length; i++) {
              print("Class $i ID: ${_classes[i]['id']}, Status: ${_classes[i]['status']?['btnText']}");
            }
          }

        } else if (responseData is List && responseData.isEmpty) {
          // API returned empty array - no lesson to start right now
          print("No lesson to start at this time");
        } else {
          print("API response format not recognized");
        }

      } else {
        print("Start lesson function api failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Start lesson function api error: $e");
      print("Stack trace: ${StackTrace.current}");
    }
  }

  // POST API function to update class status
  Future<void> updateClassStatus(String lessonId, String meetingId) async {
    final url = Uri.parse("${ApiConstants.baseUrl}instructor/update-class-status");
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'lesson_id': lessonId,
          'meeting_id': meetingId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Class status updated API response: ${response.statusCode}');

        // After updating class status, refresh the data
        StartClassFunction();
      } else {
        print('Failed to update class status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error updating class status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_classes.isEmpty)
            const Center(child: Text('No classes scheduled'))
          else
            ..._classes.map((classData) => _buildClassItem(context, classData)).toList(),
        ],
      ),
    );
  }

  Widget _buildClassItem(BuildContext context, Map<String, dynamic> classData) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          _buildInfoRow('No', classData['sr_no']?.toString() ?? 'N/A'),
          _buildInfoRow('Student', classData['student_name']?.toString() ?? 'N/A'),
          _buildInfoRow('Course', classData['course_title']?.toString() ?? 'N/A'),
          _buildInfoRow('Date', classData['class_date']?.toString() ?? 'N/A'),
          _buildInfoRow('Time', classData['class_time']?.toString() ?? 'N/A'),
          _buildInfoRow(
            'Status',
            classData['status']?['btnText']?.toString() ?? 'N/A',
            isStatus: true,
            btnHref: classData['status']?['btnHref']?.toString(),
            learningTool: classData['learning_tool']?.toString(),
            lessonId: classData['status']?['classDetails']?['lesson_id']?.toString(),
            meetingId: classData['status']?['classDetails']?['meeting_id']?.toString(),
            context: context, // Pass context only for Status row
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      String label,
      String value, {
        bool isStatus = false,
        String? btnHref,
        String? learningTool,
        String? lessonId,
        String? meetingId,
        BuildContext? context, // Make context optional
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 17.sp,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isStatus
                ? value == 'In Progress' && btnHref != null
                ? SizedBox(height: 40.h,
              child: ElevatedButton(
                onPressed: () async {
                  // Call the POST API for updating class status
                  print('Lesson ID  $lessonId');
                  print(' Meeting ID $meetingId');
                  if (lessonId != null && meetingId != null) {
                    await updateClassStatus(lessonId, meetingId);
                  } else {
                    print('Lesson ID or Meeting ID is missing');
                  }
                  if (learningTool == 'Zoom' && context != null) {
                    // Navigate to InstructorZoomMeeting for Zoom classes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  InstructorZoomMeeting(lessonId: lessonId ?? 'N/A',
                          meetingId: meetingId ?? 'N/A',),
                      ),
                    );
                  } else if (learningTool == 'Google_Meet' &&
                      btnHref != 'javascript:void(0);' &&
                      context != null) {
                    // Launch URL for Google Meet classes
                    final url = Uri.parse(btnHref);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $btnHref')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(value).withOpacity(0.2),
                  foregroundColor: _getStatusColor(value),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(
                    color: _getStatusColor(value),
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  ),
                ),
                child: Text(value),
              ),
            )
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: _getStatusColor(value).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: _getStatusColor(value),
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  ),
                ),
              ),
            )
                : Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Missed':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      case 'Scheduled':
        return Colors.blue;
      case 'In Progress':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}