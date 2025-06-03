import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import 'content_display_screen.dart';

class NonLiveCourseContent extends StatelessWidget {
  final List<dynamic> nonLiveCourses;
  final Function? onLectureOpen;

  const NonLiveCourseContent({
    Key? key,
    required this.nonLiveCourses,
    this.onLectureOpen,
  }) : super(key: key);

  // Function to map API lecture_type and lecture_resource_type to ContentDisplayScreen contentType
  String _mapLectureTypeToContentType(String lectureType, String lectureResourceType) {
    lectureType = lectureType.toLowerCase();
    lectureResourceType = lectureResourceType.toLowerCase();
    if (lectureType == 'resource' && lectureResourceType == 'slide document') {
      return 'webview'; // Use webview for Slide Document
    }
    switch (lectureType) {
      case 'video':
        return 'video';
      case 'youtube':
        return 'youtube';
      case 'audio':
        return 'audio';
      case 'image':
        return 'image';
      case 'pdf':
        return 'pdf';
      case 'text':
        return 'text';
      default:
        return 'text'; // Default to text for unknown types
    }
  }

  // Function to make the POST API call
  Future<void> _callClickLectureApi(BuildContext context, String lectureId, String lectureTitle) async {
    final String apiUrl = '${ApiConstants.baseUrl}student/course/click-lecture';
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'lecture_id': lectureId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("On Icon click API response: ${response.statusCode}");
        print("On Icon click API Data: $data");

        // Extract the lecture_preview_src, lecture_type, and lecture_resource_type from the response
        String lecturePreviewSrc = data['data']['lecture_preview_src'];
        String lectureType = data['data']['lecture_type']?.toString().toLowerCase() ?? 'text';
        String lectureResourceType = data['data']['lecture_resource_type']?.toString().toLowerCase() ?? '';

        // Map lecture_type to contentType
        String contentType = _mapLectureTypeToContentType(lectureType, lectureResourceType);

        // Navigate to ContentDisplayScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContentDisplayScreen(
              title: lectureTitle,
              contentType: contentType,
              source: lecturePreviewSrc,
            ),
          ),
        ).then((_) {
          if (onLectureOpen != null) onLectureOpen!();
        });
      } else {
        print("Error: Failed to call API. Status Code: ${response.statusCode}");
        Get.snackbar('Error', 'Failed to call API');
      }
    } catch (e) {
      print("Error during API call: $e");
      Get.snackbar('Error', 'An error occurred during the API call');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nonLiveCourses.length,
      itemBuilder: (context, index) {
        var lessonCategory = nonLiveCourses[index];
        List<dynamic> lessonLectures = lessonCategory['lesson_lectures'] ?? [];

        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: index == 0 ? 0.h : 8.h,
            bottom: 8.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index == 0
                  ? Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lessonCategory['lesson_name'],
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        color: Color(0XFF6E758A),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox(),
              ...lessonLectures.map((lecture) {
                if (lecture['lecture_type'] == 'Assignment') {
                  return Container(); // Placeholder for Assignment type
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 80.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.h),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.14),
                            offset: const Offset(-4, 5),
                            blurRadius: 16,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 55.h,
                              width: 33.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22.h),
                                color: const Color(0XFFEBF2C2),
                              ),
                              child: Center(
                                child: Text(
                                  "${lecture['lecture_no']}",
                                  style: TextStyle(
                                    color: Color(0XFF78A02A),
                                    fontSize: 15.sp,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10),
                                child: Center(
                                  child: Text(
                                    lecture['lecture_title'],
                                    style: TextStyle(
                                      color: Color(0XFF000000),
                                      fontSize: 16.sp,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                lecture['is_locked'] == "No"
                                    ? GestureDetector(
                                  child: Icon(
                                    Icons.open_in_new,
                                    color: Color(0XFF8CC13F),
                                    size: 26.w,
                                  ),
                                  onTap: () async {
                                    await _callClickLectureApi(
                                      context,
                                      lecture['lecture_id'].toString(),
                                      lecture['lecture_title'],
                                    );
                                  },
                                )
                                    : GestureDetector(
                                  child: Icon(
                                    Icons.lock,
                                    color: Color(0XFF8CC13F),
                                    size: 26.w,
                                  ),
                                  onTap: () {
                                    Get.snackbar('Error', 'This lecture is locked');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}