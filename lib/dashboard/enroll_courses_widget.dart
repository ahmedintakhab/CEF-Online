import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/api_constants.dart';
import 'all_enroll_courses_widget.dart';

class EnrollCoursesWidget extends StatefulWidget {
  const EnrollCoursesWidget({super.key});

  @override
  State<EnrollCoursesWidget> createState() => _EnrollCoursesWidgetState();
}

class _EnrollCoursesWidgetState extends State<EnrollCoursesWidget> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic>? enrolledCourses;

  @override
  void initState() {
    super.initState();
    fetchEnrolledCourses();
  }

  Future<void> fetchEnrolledCourses() async {
    final url = "${ApiConstants.baseUrl}student/latestEnrolledCourses";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Dashboard enroll courses api response: ${response.statusCode}');
        final data = json.decode(response.body);
        setState(() {
          enrolledCourses = data;
          isLoading = false;
        });
      } else {
        setState(() {
          print("Failed to load data (Code: ${response.statusCode})");
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        print("An error occurred: $e");
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0XFF23408F).withOpacity(0.14),
                offset: const Offset(-4, 5),
                blurRadius: 16,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Enrolled Courses',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to AllEnrollCoursesWidget, passing the data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllEnrollCoursesWidget(
                              enrolledCourses: enrolledCourses ?? [],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: const Color(0xFF78A03F),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8CC13F),
                    ),
                  )
                // else if (errorMessage.isNotEmpty)
                //   Center(
                //     child: Text(
                //       errorMessage,
                //       style: TextStyle(
                //         fontSize: 16.sp,
                //         color: Colors.black54,
                //         fontFamily: 'Gilroy',
                //       ),
                //     ),
                //   )
                else if (enrolledCourses == null || enrolledCourses!.isEmpty)
                    Center(
                      child: Text(
                        'No Enrolled Courses',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                       itemCount: enrolledCourses!.length > 2 ? 2 :
                        enrolledCourses!.length, // Limit to 2 courses
                          itemBuilder: (context, index) {
                        final course = enrolledCourses![index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to course details page
                            // You can implement navigation similar to OngoingScreen
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Placeholder for course image (if available in API)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Image.network(
                                        course['courseImage'] ?? 'https://via.placeholder.com/100',
                                        width: 100.w,
                                        height: 100.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 100.w,
                                          height: 100.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: const Icon(
                                            Icons.book,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            course['courseName'] ?? 'No Title',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF23408F),
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            '${course['TotalLessons']} lessons | ${course['TotalLessonsLectures']} lectures',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontFamily: 'Gilroy',
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 6.h,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.circular(22.r),
                                                  ),
                                                  child: FractionallySizedBox(
                                                    alignment: Alignment.centerLeft,
                                                    widthFactor: (course['courseProgress'] ?? 0) / 100,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFF8CC13F),
                                                        borderRadius: BorderRadius.circular(22.r),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                '${course['courseProgress'] ?? 0}%',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Gilroy',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              course['courseProgress'] == 0
                                                  ? 'Not Started'
                                                  : course['courseProgress'] == 100
                                                  ? 'Completed'
                                                  : 'In Progress',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontFamily: 'Gilroy',
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}