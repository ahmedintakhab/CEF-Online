import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../cources/cources.dart';
import '../login/login_empty_state.dart';
import '../utils/api_constants.dart';
import '../utils/screen_size.dart';
import '../utils/slider_page_data_model.dart';

class CategoryWiseCourses extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryWiseCourses({
    Key? key,
    required this.categoryId,required this.categoryName
  }) : super(key: key);
  @override
  State<CategoryWiseCourses> createState() => _CategoryWiseCoursesState();
}
Map<String, dynamic>? categoryCoursesData;
Map<String, dynamic>? Allcourses;
bool isLoading = true;
bool showNoCoursesMessage = false;
Timer? _shimmerTimer;




class _CategoryWiseCoursesState extends State<CategoryWiseCourses> {
  List cource = Utils.getTrending();
  // Initialization
  @override
  void initState() {
    super.initState();
    fetchCategoryWiseCourses();
    fetchAllCourses(); // Call the API when the widget is initialized
  }
  @override
  void dispose() {
    _shimmerTimer?.cancel();
    super.dispose();
  }
  // Reset state when navigating back
  @override
  void didUpdateWidget(CategoryWiseCourses oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      setState(() {
        categoryCoursesData = null;
        isLoading = true;
        showNoCoursesMessage = false;
      });
      fetchCategoryWiseCourses();
    }
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
  Future<void> fetchCategoryWiseCourses() async {
    // Cancel any existing timer
    _shimmerTimer?.cancel();

    setState(() {
      isLoading = true;
      showNoCoursesMessage = false;
      categoryCoursesData = null; // Clear previous data
    });

    // Start timer for showing "No courses" message
    _shimmerTimer = Timer(const Duration(seconds: 7), () {
      if (mounted && (categoryCoursesData == null ||
          categoryCoursesData!['category_courses_section_data'] == null ||
          categoryCoursesData!['category_courses_section_data'].isEmpty)) {
        setState(() {
          showNoCoursesMessage = true;
          isLoading = false;
        });
      }
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}frontend/all-categorywise-courses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'category_id': widget.categoryId,
        }),
      );

      if (mounted) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            categoryCoursesData = data;
            isLoading = false;
            showNoCoursesMessage = data['category_courses_section_data'] == null ||
                data['category_courses_section_data'].isEmpty;
          });
        } else {
          setState(() {
            isLoading = false;
            showNoCoursesMessage = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          showNoCoursesMessage = true;
        });
      }
    }
  }

  Future<void> fetchAllCourses() async {
     String apiUrl = "${ApiConstants.baseUrl}frontend/all-courses?sortBy_id=2";

    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';
      final response = await http.get(Uri.parse(apiUrl),
          headers: {'Authorization': 'Bearer $token',
            'content-Type': 'application/json'}
      );
      print("API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Data Fetched Successfully on Trending Page");

        setState(() {
          Allcourses = data;
          isLoading = false; // Hide the loading spinner
        });
      } else {
        print("Failed to fetch data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    print("please check the category Name: ${widget.categoryName}");
    initializeScreenSize(context);
    return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 27.h),
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
                      "Category Wise Courses",
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

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text( widget.categoryName ,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0XFF000000),
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 20.h),
              trending_course_list(categoryCoursesData ?? {})
            ],
          ),
        ));
  }

  Widget trending_course_list(Map<String, dynamic> coursesData) {
    if (showNoCoursesMessage) {
      return const Center(
        child: Text(
          'No such courses available',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            color: Colors.grey,
          ),
        ),
      );
    }


    // Check if coursesData is null or category_courses_section_data is null
    if (isLoading || coursesData['category_courses_section_data'] == null) {
      // Return a shimmer effect grid
      return Expanded(
        flex: 1,
        child: GridView.count(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          crossAxisCount: 2,
          crossAxisSpacing: 18.73,
          mainAxisSpacing: 20,
          childAspectRatio: 0.650,
          children: List.generate(4, (index) { // Generate 4 shimmer placeholders
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Light grey
              highlightColor: Colors.grey[100]!, // Lighter grey
              child: Container(
                width: 177.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300], // Base grey color
                ),
                child: Column(
                  children: [
                    Container(
                      height: 155.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[300], // Base grey color
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14.h,
                            width: 100.w,
                            color: Colors.grey[300], // Base grey color
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 27.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[300], // Base grey color
                                ),
                              ),
                              Container(
                                height: 17.h,
                                width: 80.w,
                                color: Colors.grey[300], // Base grey color
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            height: 28.h,
                            width: 100.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.h),
                              color: Colors.grey[300], // Base grey color
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    }

    // If data is available, render the actual course list
    final courses = coursesData?['category_courses_section_data'] ?? [];
    return Expanded(
      flex: 1,
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        crossAxisCount: 2,
        crossAxisSpacing: 18.73,
        mainAxisSpacing: 20,
        childAspectRatio: 0.650,
        children: courses.map<Widget>((course) {
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
              width: 177.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0XFF23408F).withOpacity(0.14),
                    offset: const Offset(-4, 5),
                    blurRadius: 16,
                  ),
                ],
                color: const Color(0XFFFFFFFF),
              ),
              child: Column(
                children: [
                  Container(
                    height: 155.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(course['course_image'].toString()),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0XFF23408F).withOpacity(0.14),
                          offset: const Offset(-4, 5),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          toggle(course);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 30.h,
                            width: 30.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Image(
                                image: const AssetImage("assets/like.png"),
                                height: 13.08.h,
                                width: 13.08.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          course['course_title'] ?? 'No Title',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Gilroy',
                            color: const Color(0XFF000000),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0, left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 27.h,
                              width: 50.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0XFFFAF4E1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image(
                                    image: const AssetImage("assets/staricon.png"),
                                    height: 15.h,
                                    width: 15.w,
                                  ),
                                  Text(
                                    course['course_average_rating'] ?? '0',
                                    style: TextStyle(
                                      color: const Color(0XFFFFC403),
                                      fontFamily: 'Gilroy',
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: (course['duration'] != null && course['duration'] != 0)
                                    ? Row(
                                  children: [
                                    Image(
                                      image: const AssetImage("assets/clock.png"),
                                      height: 17.h,
                                      width: 17.w,
                                      color: const Color(0XFF8CC13F),
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        "${course['duration']} Day's",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: const Color(0XFF000000),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Gilroy',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                                    : SizedBox(), // Agar condition false ho to empty widget
                              ),

                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
                        child: Row(
                          children: [
                            if (course['course_price'] != null)
                              Row(
                                children: [
                                  Container(
                                    height: 28.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.h),
                                      color: const Color(0XFFEBF2C2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        course['course_price'].toString(),
                                        style: TextStyle(
                                          color: const Color(0XFF78A03F),
                                          fontFamily: 'Gilroy',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


}

