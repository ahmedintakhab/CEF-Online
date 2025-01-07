import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learn_megnagmet/cources/choose_plane_screen.dart';
import 'package:learn_megnagmet/cources/lessons_screen.dart';
import 'package:learn_megnagmet/cources/review_screen.dart';
import 'package:video_player/video_player.dart';
import '../utils/screen_size.dart';
import '../widget/button.dart';
import 'overview_page.dart';

class MyCources extends StatefulWidget {
  const MyCources({Key? key, required this.slug}) : super(key: key);
  final String slug;

  @override
  State<MyCources> createState() => _MyCourcesState();
}

class CourceController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  late PageController pController;

  void initializeController(int length) {
    tabController = TabController(length: length, vsync: this);
    pController = PageController();
  }

  @override
  void onClose() {
    tabController.dispose();
    pController.dispose();
    super.onClose();
  }
}

class _MyCourcesState extends State<MyCources> {
  late FlickManager flickManager;
  String courseType = '';
  String videoUrl = '';
  List<Widget> pageclass = [];
  bool isLoading = true;
  late CourceController courceController;

  @override
  void initState() {
    super.initState();
    // Use Get.put to let Get manage the controller lifecycle
    courceController = Get.put(CourceController());

    // Initialize the controller right after it's created
    courceController.initializeController(3);  // Pass the length of the pageclass if needed (3 for "Overview", "Lessons", "Reviews")

    // Add listener to PageController for syncing TabBar
    courceController.pController.addListener(() {
      int pageIndex = courceController.pController.page?.round() ?? 0;
      if (courceController.tabController.index != pageIndex) {
        courceController.tabController.animateTo(pageIndex);
      }
    });

    fetchCourseDetails(); // Fetch course details on page load
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"), // Temporary URL until API response
      autoPlay: false,
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Future<void> fetchCourseDetails() async {
    final url = 'https://cefonlineacademy.com/api/frontend/course/detail/${widget.slug}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final fetchedCourseType = data['course_type'];
        final coursePreviewSrc = data['course_preview_src'];

        setState(() {
          courseType = fetchedCourseType;
          if (coursePreviewSrc != null) {
            flickManager = FlickManager(
              videoPlayerController: VideoPlayerController.network(coursePreviewSrc),
              autoPlay: false,
            );
          }
          // Adjust pages and initialize the controllers
          pageclass = (courseType == "Live")
              ? [Overview(), Review()]
              : [Overview(), Lesson(), Review()];

          courceController.initializeController(pageclass.length);
          isLoading = false;
        });
      } else {
        print('Failed to load course details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching course details: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Padding(
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
                          fontSize: 24.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.h)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: FlickVideoPlayer(flickManager: flickManager)),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              if (pageclass.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                      controller: courceController.tabController,
                      isScrollable: true,
                      unselectedLabelColor: const Color(0XFF6E758A),
                      labelColor: const Color(0XFF78A03F),
                      indicator: ShapeDecoration(
                        color: const Color(0XFFEBE2C2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.h),
                        ),
                      ),
                      tabs: List.generate(
                        pageclass.length,
                            (index) => Tab(text: ["Overview", "Lessons", "Reviews"][index]),
                      ),
                      onTap: (index) {
                        courceController.pController.jumpToPage(index); // Navigate to correct page
                      },
                    ),

                  ),
                ),
              SizedBox(height: 12.h),
              Expanded(
                child: PageView.builder(
                  controller: courceController.pController,
                  itemCount: pageclass.length,
                  onPageChanged: (index) {
                    courceController.tabController.animateTo(index); // Update TabBar label
                  },
                  itemBuilder: (context, index) {
                    return pageclass[index];
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: CustomButton(
                  onTap: () => Get.to(const ChoosePlane()),
                  buttonText: 'Enroll Now',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
