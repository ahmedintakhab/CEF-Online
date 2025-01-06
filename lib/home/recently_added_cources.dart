import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:learn_megnagmet/home/recent_added_cource_detail.dart';

import 'package:learn_megnagmet/models/recently_added.dart';
import 'package:learn_megnagmet/utils/slider_page_data_model.dart';

import '../My_cources/cources_details.dart';
import '../login/login_empty_state.dart';
import '../utils/screen_size.dart';


class RecentlyAdded extends StatefulWidget {
  const RecentlyAdded({Key? key}) : super(key: key);

  @override
  State<RecentlyAdded> createState() => _RecentlyAddedState();
}

class _RecentlyAddedState extends State<RecentlyAdded> {

  Future<void> share() async {
    await Share.share(
      'Example share text',  // Text content to share
      subject: 'Example share subject',
    );
  }
  List<Recent> recentcource = [];
  Map<String, dynamic>? fetchData;



  @override
  void initState() {
    recentcource = Utils.getRecentAdded();
    super.initState();
    fetchCourses(); // Call the API on page load

  }
  Future<void> fetchCourses() async {
    const String apiUrl = "https://cefonlineacademy.com/api/frontend/all-courses?sortBy_id=2";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Data Fetched Successfully: $data");

        setState(() {
          fetchData = data;
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
    initializeScreenSize(context);
    return Scaffold(
      body: Column(
        children: [
           SizedBox(height: 60.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              children: [
                 GestureDetector(
                   onTap: (){
                     Get.back();
                   },
                   child: Image(
                    image: AssetImage("assets/back_arrow.png"),
                    height: 24.h,
                    width: 24.w,
                ),
                 ),
                SizedBox(width: 16.w),
                 Text(
                  "Recently Added Course",
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: Color(0XFF000000),
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(child:  recently_added_cources_list(fetchData ?? {}),)

        ],
      ),
    );
  }

  Widget recently_added_cources_list(Map<String,dynamic>fetchData) {
    if (fetchData == null || fetchData['courses_section_data'] == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFF8CC13F), // Loader color
        ),
      );
    }
    // Assuming `fetchData['data']` contains the list of courses
    final courses = fetchData?['courses_section_data'] ?? [];

    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: courses.length,
          itemBuilder: (BuildContext, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: (){

                Get.to(RecentCourceDetail(corcedetail: course,));
              },
              child: Padding(
                padding:  EdgeInsets.only(left: 20.w,right: 20.w,top:index==0?0.h: 10.h,bottom: 10.h),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.h),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.14),
                            offset: const Offset(-4, 5),
                            blurRadius: 16.h),
                      ],
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.all(0.h),
                            child: Container(
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0XFF23408F)
                                            .withOpacity(0.14),
                                        offset: const Offset(-4, 5),
                                        blurRadius: 16.h),
                                  ],
                                  color: Colors.white),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 210.h,
                                    width: double.infinity.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.h),
                                        color: Colors.white),
                                    child: Image.network(
                                      course['course_image'].toString(), // Update with your API's image key
                                      fit: BoxFit.fill,
                                    ),

                                  ),
                                  Padding(
                                    padding:
                                         EdgeInsets.only(left: 10.w, top: 10.h),
                                    child: Container(
                                        height: 33.h,
                                        width: 32.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: IconButton(splashRadius: 10.h,
                                            onPressed: () {

                                            },
                                            icon:  const Center(
                                              child:  Image(image: AssetImage("assets/saveicon.png"))
                                            ))),
                                  ),
                                  Padding(
                                    padding:
                                         EdgeInsets.only(left: 55.w, top: 10.h),
                                    child: Container(
                                        height: 33.h,
                                        width: 32.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                share();
                                              },
                                              icon: Image(image: AssetImage("assets/shareicon.png")),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                       SizedBox(height: 10.h),
                      Padding(
                        padding:  EdgeInsets.only(left: 10.42.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Column(
                              children: [
                                Container(
                                  height: 27.h,
                                  width: 59.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.h),
                                    color: const Color(0XFFFAF4E1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                       Image(image:const AssetImage("assets/staricon.png"),height: 17.h,width: 17.w),
                                      Text(
                                        course['course_total_reviews'].toString() ,
                                        style:  TextStyle(
                                            color: Color(0XFFFFC403),
                                            fontFamily: 'Gilroy',
                                            fontSize: 15.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 23.h,
                                  width: 120.w,
                                  //color: Colors.red,
                                  child: Row(
                                    children: [
                                      Image(image: const AssetImage("assets/clock.png")
                                          ,height: 17.h,width: 17.w,color: Color(0XFF8CC13F),),
                                       SizedBox(width: 4.w),
                                      Text(
                                        course['course_duration'].toString(),
                                        style:  TextStyle(
                                            fontSize: 12.sp,
                                            color: const Color(0XFF000000),
                                            fontFamily: 'Gilroy'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                       SizedBox(height: 11.h),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(right: 68.w),
                              child: Text(
                                course['course_title'].toString(),
                                style:  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                    fontFamily: 'Gilroy',
                                    color: Color(0XFF000000)),
                              ),
                            ),
                             SizedBox(height: 11.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image(
                                      image: NetworkImage(
                                          course['course_user_pic'].toString()),
                                      height: 40.h,
                                      width: 40.w,
                                    ),
                                     SizedBox(width: 10.w),
                                    Text(
                                      course['course_user_name'].toString(),
                                      style:  TextStyle(
                                          color: Color(0XFF5E8421),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Gilroy'),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width: 74.w,
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
                                            fontWeight: FontWeight.w700),
                                      )),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                       SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
