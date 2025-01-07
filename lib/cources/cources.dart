import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/cources/lessons_screen.dart';
import 'package:learn_megnagmet/cources/overview_page.dart';
import 'package:learn_megnagmet/cources/review_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import '../models/trending_cource.dart';
import '../utils/screen_size.dart';
import '../widget/button.dart';
import 'choose_plane_screen.dart';

class MyCources extends StatefulWidget {
  const MyCources({Key? key,required this.slug}) : super(key: key);
  final String slug;


  @override
  State<MyCources> createState() => _MyCourcesState();
}

class _MyCourcesState extends State<MyCources> {
  CourceController courceController = Get.put(CourceController());
  PageController pageController = PageController();
  int initialvalue = 0;



  late FlickManager flickManager;
  bool currentbuttonpos = false;
  List pageclass = [
    Overview(),
    Lesson(),
    Review(),
  ];


  @override
  void initState() {
    fetchCourseDetails(); // Fetch course details on page load
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
      autoPlay: false,

    );
  }
  Future<void> fetchCourseDetails() async {
    final url = 'https://cefonlineacademy.com/api/frontend/course/detail/${widget.slug}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Successfullt fetched data");
        print('Check the value of slug: ${widget.slug}');
        print('Course Details: $data');
        // Update state with course details
      } else {
        print('Failed to load course details. Status code: ${response.statusCode}');
        print('Check the value of slug: ${widget.slug}');

      }
    } catch (e) {
      print('Error fetching course details: $e');
    }
  }


  @override
  void dispose() {
    flickManager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: GetBuilder<CourceController>(
          init: CourceController(),
          builder: (CourceController) => SafeArea(
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 20.h),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child:  Image(
                            image: const AssetImage("assets/back_arrow.png"),
                            height: 24.h,
                            width: 24.w,
                          )),
                       SizedBox(width: 15.w),
                       Text(
                        "Courses",
                        style: TextStyle(fontFamily: 'Gilroy',fontWeight: FontWeight.w700, fontSize: 24.sp),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 20.h),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    padding: EdgeInsets.all(12.h),

                    decoration: BoxDecoration(
                      color:Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0XFF23408F).withOpacity(0.1),
                            blurRadius: 16,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(22.h),
                        ),
                    child: Container(
                      height: 195.h,

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.h)),
                        child: ClipRRect(borderRadius: BorderRadius.circular(22),child: FlickVideoPlayer(flickManager: flickManager))),
                  ),
                ),
                 SizedBox(height: 12.h),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.w),
                  child: Container(
                    height: 54.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.20),
                            blurRadius: 16,
                          ),
                        ],
                        color: const Color(0XFFFFFFFF),
                        borderRadius: BorderRadius.circular(22)),
                    child: TabBar(
                      unselectedLabelColor: Color(0XFF6E758A),
                      padding:
                           EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      labelStyle:  TextStyle(
                          color: const Color(0XFF23408F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          fontFamily: 'Gilroy'),
                      labelColor: const Color(0XFF78A03F),
                      unselectedLabelStyle:  TextStyle(
                          color: const Color(0XFF23408F),
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                          fontFamily: 'Gilroy'),
                      indicator: ShapeDecoration(
                          color: const Color(0XFFEBE2C2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.h))),
                      controller: courceController.tabController,
                      tabs: const [
                        Tab(
                          text: "Overview ",
                        ),
                        Tab(
                          text: "Lessons",
                        ),
                        Tab(
                          text: "Reviews",
                        ),
                      ],
                      onTap: (value) {
                        courceController.pController.animateToPage(value,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                Expanded(
                  child: PageView.builder(
                    controller: courceController.pController,
                    onPageChanged: (value) {
                      courceController.tabController.animateTo(value,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    itemCount: pageclass.length,
                    itemBuilder: (context, index) {
                      return pageclass[index];
                    },
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 30.h),
                  child: CustomButton(
                    onTap: () {
                      Get.to(const ChoosePlane());
                    },
                    buttonText: 'Enroll Now',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
