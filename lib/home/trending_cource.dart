import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cources/cources.dart';
import '../login/login_empty_state.dart';
import '../utils/api_constants.dart';
import '../utils/cache_api_service.dart';
import '../utils/screen_size.dart';
import '../utils/slider_page_data_model.dart';

class TrendingCource extends StatefulWidget {
  const TrendingCource({Key? key}) : super(key: key);

  @override
  State<TrendingCource> createState() => _TrendingCourceState();
}
Map<String, dynamic>? Allcourses;


class _TrendingCourceState extends State<TrendingCource> {
  List cource = Utils.getTrending();
  // Initialization
  @override
  void initState() {
    super.initState();
    fetchAllCourses(); // Call the API when the widget is initialized
  }

  toggle(int index){
    setState(() {
      if(cource[index].buttonStatus==true){
        cource[index].buttonStatus=false;
      }
      else{
        cource[index].buttonStatus=true;
      }
    });
  }
  Future<void> fetchAllCourses() async {
    final apiUrl = "${ApiConstants.baseUrl}frontend/all-courses?sortBy_id=2";

    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // Use fetchDataWithCache to get data from cache or network
      final data = await fetchDataWithCache(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("✅ API Data Fetched Successfully on Trending Page");

      setState(() {
        Allcourses = data;
        isLoading = false; // Hide the loading spinner
      });
    } catch (e) {
      print("❌ Error fetching All Courses data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
          body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Image(
                        image: const AssetImage("assets/back_arrow.png"),
                        height: 24.h,
                        width: 24.w,
                      )),
                  SizedBox(width: 16.w),
                  Text(
                    "Latest Courses",
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: const Color(0XFF000000),
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
             trending_course_list(Allcourses ?? {})
          ],
        ),
      ));
  }

  Widget trending_course_list(Map<String, dynamic> Allcourses) {
    if (Allcourses == null || Allcourses['courses_section_data'] == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8CC13F), // Loader color
        ),
      );
    }
    final courses = Allcourses['courses_section_data'] ?? [];
    return Expanded(
      flex: 1,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return GestureDetector(
            onTap: () {
              final slug = course['course_slug'];
              if (slug != null) {
                Get.to(() => MyCources(slug: slug));
              } else {
                print("Slug is null");
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF23408F).withOpacity(0.14),
                    offset: const Offset(-4, 5),
                    blurRadius: 16,
                  ),
                ],
                color: const Color(0xFFFFFFFF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Image (Left)
                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: NetworkImage(course['course_image']?.toString() ?? ''),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) => AssetImage('assets/placeholder.png'),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Course Name (Right)
                      Expanded(
                        child: Text(
                          course['course_title'] ?? 'No Title',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy',
                            color: const Color(0xFF000000),
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating (Left)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: const Color(0xFFFAF4E1),
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: const AssetImage("assets/staricon.png"),
                              height: 15.h,
                              width: 15.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              course['course_average_rating']?.toString() ?? '0',
                              style: TextStyle(
                                color: const Color(0xFFFFC403),
                                fontFamily: 'Gilroy',
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Price (Center)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: const Color(0xFFEBF2C2),
                        ),
                        child: Text(
                          course['course_price'] != null ? course['course_price'].toString() : 'Free',
                          style: TextStyle(
                            color: const Color(0xFF78A03F),
                            fontFamily: 'Gilroy',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Duration (Right)
                      Row(
                        children: [
                          Image(
                            image: const AssetImage("assets/clock.png"),
                            height: 15.h,
                            width: 15.w,
                            color: const Color(0xFF8CC13F),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            course['course_duration'] == 'Full Lifetime Access'
                                ? 'Full Lifetime Access'
                                : "${course['course_duration'] ?? '0'} Day's",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Gilroy',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  }

