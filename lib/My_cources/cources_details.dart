// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/controller.dart';
import '../models/my_cource.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/screen_size.dart';
import '../utils/slider_page_data_model.dart';
import 'live_course_content.dart'; // Import the live course content widget
import 'non_live_course_content.dart'; // Import the non-live course content widget

class CourceDetail extends StatefulWidget {
  final Function? onLectureOpen; // Add callback parameter
  const CourceDetail({Key? key, required this.corcedetail,this.onLectureOpen}) : super(key: key);
  final Map<String, dynamic> corcedetail;

  @override
  State<CourceDetail> createState() => _CourceDetailState();
}

class _CourceDetailState extends State<CourceDetail> {
  List cource_detail = Utils.getCourceDetail();
  CourceDetailController courceDetailController = Get.put(CourceDetailController());
  late String CourseSlug;
  List<dynamic> liveCourses = [];
  List<dynamic> nonLiveCourses = [];
  String courseType = '';
  bool isLoading = true;
  List<dynamic> courseDetails = [];

  @override
  void initState() {
    super.initState();
    CourseSlug = widget.corcedetail['courseSlug'] ?? 'Unknown Slug';
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    final String apiUrl = 'https://cefonlineacademy.com/api/student/my-course/$CourseSlug';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data of courses: $data');
        setState(() {
          courseType = data['course_type'] ?? '';
          if (courseType == 'Live') {
            liveCourses = data['course_content_list_section'] ?? [];
          } else {
            nonLiveCourses = data['course_content_list_section'] ?? [];
          }
          isLoading = false;
        });
      } else {
        print("Error: Failed to load course details ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error: An error occurred while fetching data $error");
      setState(() {
        isLoading = false;
      });
    }
  }
  // Add method to handle lecture completion
  void handleLectureOpen() {
    // Call the parent's callback if it exists
    if (widget.onLectureOpen != null) {
      widget.onLectureOpen!();
    }
    // Optionally refresh the current page data
    fetchCourseDetails();
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: GetBuilder(
        init: CourceDetailController(),
        builder: (courceDetailController) => Column(
          children: [
            SizedBox(height: 64.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Image(
                      image: AssetImage("assets/back_arrow.png"),
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Text(
                      "${widget.corcedetail['courseName']}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Expanded(
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: Color(0XFF8CC13F),
                ),
              )
                  : courseType == 'Live'
                  ? LiveCourseContent(liveCourses: liveCourses,
                onLectureOpen : handleLectureOpen,
              ) // Use the LiveCourseContent widget
                  : NonLiveCourseContent(nonLiveCourses: nonLiveCourses,
              onLectureOpen : handleLectureOpen), // Use the NonLiveCourseContent widget
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.h, top: 15.h),
                child: Container(
                  height: 56.h,
                  width: 374.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.h),
                    color: const Color(0XFF78A03F),
                  ),
                  child: Center(
                    child: Text(
                      "Continue Course",
                      style: TextStyle(
                        color: Color(0XFFFFFFFF),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}