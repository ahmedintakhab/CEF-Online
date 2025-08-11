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
    final courses = Allcourses?['courses_section_data'] ?? [];
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
          child:  Container(
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
                        padding: EdgeInsets.only(bottom: 8.0,left: 8.0),
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
                                    image: const AssetImage(
                                        "assets/staricon.png"),
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
                                child: Row(
                                  children: [
                                    Image(
                                      image: const AssetImage(
                                          "assets/clock.png"),
                                      height: 17.h,
                                      width: 17.w,
                                      color: const Color(0XFF8CC13F),
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        "${course['course_duration']} Day's",
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
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0,bottom: 8.0),
                        child: Row(
                          children: [
                            // CircleAvatar(
                            //   backgroundImage: NetworkImage(
                            //       course['course_user_pic'] ?? ''),
                            //   radius: 14.h,
                            // ),
                            SizedBox(width: 6.w),
                            if(course['course_price']!=null)
                              Row(
                                children: [
                                  Container(
                                    height: 28.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.h),
                                        color:const  Color(0XFFEBF2C2)),
                                    child: Center(
                                        child: Text(
                                          course['course_price'].toString(),
                                          style:  TextStyle(
                                              color: const Color(0XFF78A03F),
                                              fontFamily: 'Gilroy',
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  )
                                ],
                              ),
                            // Expanded(
                            //   child: Text(
                            //     course['course_user_name'] ?? 'Unknown',
                            //     style: TextStyle(
                            //       color: const Color(0XFF23408F),
                            //       fontSize: 14.sp,
                            //       fontWeight: FontWeight.w500,
                            //       fontFamily: 'Gilroy',
                            //     ),
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //   ),
                            // )
                          ],



                        ),
                      ),
                    ],
                  ),

              ],
            )
          ),
          );
        }).toList(),
      ),
    );
  }


  }

