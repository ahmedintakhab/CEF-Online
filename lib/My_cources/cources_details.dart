// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/utils/slider_page_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/my_cource.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/screen_size.dart';
import 'lesson_play.dart';
import 'ongoing_screen.dart';

class CourceDetail extends StatefulWidget {
  const CourceDetail({Key? key, required this.corcedetail}) : super(key: key);
  final Map<String, dynamic> corcedetail; // Accept a map
  // final OngoingCources corcedetail;

  @override
  State<CourceDetail> createState() => _CourceDetailState();
}

class _CourceDetailState extends State<CourceDetail> {
  List cource_detail = Utils.getCourceDetail();
  CourceDetailController courceDetailController =
      Get.put(CourceDetailController());
  late String CourseSlug;
  List<dynamic> liveCourses = [];
  List<dynamic> nonLiveCourses = [];
  String courseType = '';
  bool isLoading = true;
  List<dynamic> courseDetails = [];

  @override
  void initState(){
    super.initState();
    CourseSlug = widget.corcedetail['courseSlug'] ?? 'Unknown Slug';
    fetchCourseDetails();
    // print('Check the slug: $CourseSlug');
  }

  Future<void> fetchCourseDetails() async {
    final String apiUrl = 'https://cefonlineacademy.com/api/student/my-course/$CourseSlug';
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token', // Pass the token as a Bearer token
          'Content-Type': 'application/json', // Optional: Set content type
        },
      );
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Data of courses: $data');
        setState(() {
          courseType = data['course_type'] ?? '';
          print('Check the course type: $courseType');
          if (courseType == 'Live') {
            liveCourses = data['course_content_list_section'] ?? [];
          } else {
            nonLiveCourses = data['course_content_list_section'] ?? [];
          }
          print('Check the live data: $liveCourses');
          // courseDetails = data['course_content_list_section'] ?? [];
          isLoading = false;
        });
      } else {
        print("Error: Failed to load course details ${response.body}");
        // Get.snackbar('Error', 'Failed to load course details.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error: An error occurred while fetching data $error");
      // Get.snackbar('Error', 'An error occurred while fetching data.');
      setState(() {
        isLoading = false;
      });
    }
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
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child:  Image(
                          image: AssetImage("assets/back_arrow.png"),
                          height: 24.h,
                          width: 24.w,
                        )),
                     SizedBox(width: 20.w),
                       Expanded(
                         child: Text(
                          "${widget.corcedetail['courseName']}",
                          style:  TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 24.sp),
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
                    ? Center(child: CircularProgressIndicator(color: Color(0XFF8CC13F),))
                    : courseType == 'Live'
                    ? _buildLiveCourseContent()
                    : _buildNonLiveCourseContent(),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding:  EdgeInsets.only(bottom: 40.h, top: 15.h),
                  child: Container(
                    height: 56.h,
                    width: 374.w,
                    //color: Color(0XFF23408F),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.h),
                      color: const Color(0XFF78A03F),
                    ),
                    child:  Center(
                      child: Text("Continue Course",
                          style: TextStyle(
                              color: Color(0XFFFFFFFF),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Gilroy')),
                    ),
                  ),
                ),
              )
            ],
          )),
    );

  }
  Widget _buildLiveCourseContent() {
    return ListView.builder(
      itemCount: liveCourses.length,
      itemBuilder: (context, index) {
        var courseCategory = liveCourses[index];
        var categoryResources = courseCategory['category_resources'];
        var categoryName = courseCategory['category_name'];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: index == 0 ? 0.h : 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isCategoryDisplayed(categoryName))
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Text(
                    courseCategory['category_name'],
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0XFF6E758A),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ...categoryResources.map<Widget>((resource) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 80.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                              resource['resource_no'].toString(),
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
                            padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 10),
                            child: Center(
                              child: Text(
                                resource['resource_name'],
                                style: TextStyle(
                                  color: Color(0XFF000000),
                                  fontSize: 14.sp,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String url = resource['redirect_preview_src'];
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not launch $url')),
                              );
                            }
                          },
                          child: Icon(
                            Icons.open_in_new,
                            color: Color(0XFF8CC13F),
                            size: 26.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
  bool _isCategoryDisplayed(String categoryName) {
    // Keep track of the categories that have already been displayed
    Set<String> displayedCategories = {};

    if (!displayedCategories.contains(categoryName)) {
      displayedCategories.add(categoryName);
      return false;
    }
    return true;
  }

  Widget _buildNonLiveCourseContent() {
    return ListView.builder(
        itemCount: nonLiveCourses.length,
        itemBuilder: (context, index) {
          var lessonCategory = nonLiveCourses[index];
          // var lessonLectures = lessonCategory['lesson_lectures'];
          return Padding(
            padding:  EdgeInsets.only(
                left: 20.w, right: 20.w, top: index==0?0.h:8.h, bottom: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index == 0
                    ? Padding(
                  padding:  EdgeInsets.only(
                    bottom: 20.h,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(lessonCategory['lesson_name'],style: TextStyle(
                          fontFamily:
                          'Gilroy',
                          color:
                          Color(0XFF6E758A),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),),
                      //
                    ],
                  ),
                )
                    : const SizedBox(),
                index==3?Padding(
                  padding:  EdgeInsets.only(
                    bottom: 20.h,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Lesson 2 - User Research",style: TextStyle(
                          fontFamily:
                          'Gilroy',
                          color:
                          Color(0XFF6E758A),
                          fontSize: 15.sp,

                          fontWeight: FontWeight.w700),),

                    ],
                  ),
                ):const SizedBox(),

                Container(
                  height: 80.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.h),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.14),
                            offset: const Offset(-4, 5),
                            blurRadius: 16),
                      ],
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 55.h,
                          width: 33.w,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(22.h),
                              color: const Color(0XFFEBF2C2)),
                          child: Center(
                            child: Text(
                              "${cource_detail[index].lessonID}",
                              style:  TextStyle(
                                  color: Color(0XFF78A02A),
                                  fontSize: 15.sp,
                                  fontFamily: 'Gilroy',
                                  fontWeight:
                                  FontWeight.w700),
                            ),
                          )),

                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 10),
                          child: Center(
                            child: Text(cource_detail[index].lessonName!,
                              style: TextStyle(
                                color: Color(0XFF000000),
                                fontSize: 14.sp,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),



                      // Column(
                      //   crossAxisAlignment:
                      //   CrossAxisAlignment.start,
                      //   children: [
                      //     SizedBox(height: 18.h),
                      //     Text(
                      //         cource_detail[index]
                      //             .lessonName!,
                      //         style:  TextStyle(
                      //             color: Color(0XFF000000),
                      //             fontSize: 14.sp,
                      //             fontFamily: 'Gilroy',
                      //             fontWeight:
                      //             FontWeight.w700)),
                      //     SizedBox(height: 10.h),
                      //     // Text(cource_detail[index].time!,
                      //     //     style:  TextStyle(
                      //     //       color: Color(0XFF6E758A),
                      //     //       fontSize: 14.sp,
                      //     //       fontFamily: 'Gilroy',
                      //     //     ))
                      //   ],
                      // ),
                      Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          index < 3
                              ? GestureDetector(
                            child: Image(
                              image: AssetImage(
                                  cource_detail[index]
                                      .playIconImage!),
                              height: 26.h,
                              width: 26.w,color: Color(0XFF8CC13F),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VidioPlay(
                                              lessonplay:
                                              cource_detail[
                                              index])));
                            },
                          )
                              : GestureDetector(
                            child: Image(
                              image: AssetImage(
                                  cource_detail[index]
                                      .lockImageImage!),
                              height: 26.h,
                              width: 26.w,color: Color(0XFF8CC13F),
                            ),
                            onTap: () {
                              Get.snackbar('error',
                                  'This lesson is locked');
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
