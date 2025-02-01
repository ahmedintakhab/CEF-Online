import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'my_courses_controller.dart';
import 'my_courses_video_player.dart';
import 'package:learn_megnagmet/cources/instructors.dart';
import 'package:learn_megnagmet/cources/lessons_screen.dart';
import 'package:learn_megnagmet/cources/review_screen.dart';
import '../utils/screen_size.dart';
import '../widget/button.dart';
import 'overview_page.dart';

class MyCources extends StatefulWidget {
  const MyCources({Key? key, required this.slug}) : super(key: key);
  final String slug;

  @override
  State<MyCources> createState() => _MyCourcesState();
}

class _MyCourcesState extends State<MyCources> {
  late CourseController courseController;
  bool isLoading = true;
  late String courseId;
  List<dynamic>? ongoingCourses;
  String courseType = '';
  String btnText = '';
  String btnApiRoute = '';
  List<Widget> pageclass = [];

  @override
  void initState() {
    super.initState();
    courseController = Get.put(CourseController());
    setupController();
    loadCourseData();
  }

  void setupController() {
    courseController.initializeController(3);
    courseController.pController.addListener(() {
      int pageIndex = courseController.pController.page?.round() ?? 0;
      if (courseController.tabController.index != pageIndex) {
        courseController.tabController.animateTo(pageIndex);
      }
    });
  }

  Future<void> loadCourseData() async {
    await courseController.fetchOngoingCourses();
    final courseDetails = await courseController.fetchCourseDetails(widget.slug);

    setState(() {
      ongoingCourses = courseController.ongoingCourses;
      courseType = courseDetails['course_type'];
      btnText = courseDetails['btn_text'];
      btnApiRoute = courseDetails['btn_api_route'];
      courseId = courseDetails['course_id'].toString();

      // Setup pages based on course type
      setupPages(courseDetails);
      isLoading = false;
    });
  }

  void setupPages(Map<String, dynamic> courseDetails) {
    final overviewData = courseDetails['overview'];
    final reviewData = courseDetails['reviews'];
    final lessonsData = courseDetails['lessons'];
    final instructorsData = courseDetails['instructors'];
    final fetchedCourseType = courseDetails['course_type'];

    pageclass = (courseType == "Live")
        ? [
      Overview(overviewData: overviewData, fetchedCourseType: fetchedCourseType),
      Instructors(instructors: instructorsData),
      Review(reviewData: reviewData, courseId: courseId),
    ]
        : [
      Overview(overviewData: overviewData, fetchedCourseType: fetchedCourseType),
      Lesson(lessonsData: lessonsData),
      Instructors(instructors: instructorsData),
      Review(reviewData: reviewData, courseId: courseId),
    ];

    courseController.initializeController(pageclass.length);
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildVideoPlayer(),
            SizedBox(height: 12.h),
            if (pageclass.isNotEmpty) _buildTabBar(),
            SizedBox(height: 12.h),
            _buildPageView(),
            _buildEnrollButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Image(
              image: const AssetImage("assets/back_arrow.png"),
              height: 24.h,
              width: 24.w,
            ),
          ),
          SizedBox(width: 15.w),
          Text(
            "Courses",
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              fontSize: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white,
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
          child: CourseVideoPlayer(
            videoUrl: courseController.coursePreviewSrc,
            courseType: courseType,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        height: 74.h,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0XFF23408F).withOpacity(0.20),
              blurRadius: 16,
            ),
          ],
          color: const Color(0XFFFFFFFF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: TabBar(
          controller: courseController.tabController,
          unselectedLabelColor: const Color(0XFF6E758A),
          labelColor: const Color(0XFF78A03F),
          indicator: ShapeDecoration(
            color: const Color(0XFFEBF2C2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.h),
            ),
          ),
          indicatorPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: _buildTabs(),
          onTap: (index) {
            courseController.pController.jumpToPage(index);
          },
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return List.generate(
      pageclass.length,
          (index) {
        String tabText = '';
        if (courseType == "Live") {
          tabText = index == 0 ? "Overview" : index == 1 ? "Instructors" : "Review";
        } else {
          tabText = index == 0 ? "Overview" : index == 1 ? "Lessons"
              : index == 2 ? "Instructors" : "Review";
        }

        return Tab(
          child: SizedBox(
            width: 75,
            child: Text(
              tabText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: courseController.pController,
        itemCount: pageclass.length,
        onPageChanged: (index) {
          courseController.tabController.animateTo(index);
        },
        itemBuilder: (context, index) {
          return pageclass[index];
        },
      ),
    );
  }

  Widget _buildEnrollButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.h),
      child: CustomButton(
        onTap: () => courseController.enrollInCourse(courseId, widget.slug, btnText, btnApiRoute),
        buttonText: btnText.isNotEmpty ? btnText : 'Enroll Now',
      ),
    );
  }
}
