import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:learn_megnagmet/cources/choose_plane_screen.dart';
import 'package:learn_megnagmet/cources/lessons_screen.dart';
import 'package:learn_megnagmet/cources/review_dialog_box.dart';
import 'package:learn_megnagmet/cources/review_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  late YoutubePlayerController youtubeController;
  bool isYouTubeVideo = false;
  String courseType = '';
  String videoUrl = '';
  String btnText = '';
  String btnApiRoute = '';
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
    if (isYouTubeVideo && youtubeController != null) {
      youtubeController.dispose();
    }
    super.dispose();
  }
  void showWriteReviewDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => WriteReviewDialog(courseId: courseId),
    );
  }


  Future<void> fetchCourseDetails() async {
    final url = 'https://cefonlineacademy.com/api/frontend/course/detail/${widget.slug}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final fetchedCourseType = data['course_type'];
        final coursePreviewSrc = data['course_preview_src'];
        final overviewData = data['overview'];
        final reviewData = data['reviews'];
        final courseID = data['course_id'].toString();
        final lessonsData = data['lessons'];
        // Fetch button text and API route
        btnText = data['btn_text'];
        btnApiRoute = data['btn_api_route'];

        print('API fetched data Successfully: $data');
        print('Check the slug: ${widget.slug}');
        print('Check the course type: $fetchedCourseType');
        print('Check the course preview src: $coursePreviewSrc');
        print('Check the course id: $courseID');
        print('Check the button Data: $btnText');
        print('Check the button API route Data: $btnApiRoute');


        setState(() {
          courseType = fetchedCourseType;

          // Null check for coursePreviewSrc before accessing it
          if (coursePreviewSrc != null && coursePreviewSrc.isNotEmpty) {
            // Check if the video source is a YouTube URL
            if (coursePreviewSrc.contains('youtube.com/embed/')) {
              final videoId = coursePreviewSrc.split('embed/').last;
              isYouTubeVideo = true;
              youtubeController = YoutubePlayerController(
                initialVideoId: videoId,
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );
            } else if (coursePreviewSrc.contains('youtube.com/watch?v=')) {
              final videoId = Uri.parse(coursePreviewSrc).queryParameters['v'];
              isYouTubeVideo = true;
              youtubeController = YoutubePlayerController(
                initialVideoId: videoId!,
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );
            } else {
              // If the URL is not YouTube, check if it's a regular video (mp4)
              if (coursePreviewSrc.endsWith('.mp4')) {
                // It's a regular video URL
                isYouTubeVideo = false;
                flickManager = FlickManager(
                  videoPlayerController: VideoPlayerController.network(coursePreviewSrc),
                  autoPlay: false,
                );
              }
            }
          } else {
            // If there's no coursePreviewSrc, show a message saying "No video upload"
            print("No video uploaded");
            isYouTubeVideo = false;  // No video
          }

          // Adjust pages and initialize the controllers
          pageclass = (courseType == "Live")
              ? [
            Overview(overviewData: overviewData),
            Review(reviewData: reviewData, courseId: courseID),
          ]
              : [
            Overview(overviewData: overviewData),
            Lesson(lessonsData: lessonsData),
            Review(reviewData: reviewData, courseId: courseID),
          ];

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

Future<void> enrollInCourse() async{
    try{
      final response = await http.post(Uri.parse(btnApiRoute),body: {
        // 'course_id': courseID,
      });
      if(response.statusCode == 200){
        print("Successfully enroll in the course");
        
      }
      else{
        print('Failed to enroll in the course. Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during enrollment: $e');
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
                      borderRadius: BorderRadius.circular(22.h),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: isYouTubeVideo
                          ? YoutubePlayer(controller: youtubeController)
                          : (isYouTubeVideo == false && flickManager != null)
                          ? FlickVideoPlayer(flickManager: flickManager)  // Show regular video
                          : Center(child: Text("No video uploaded")),  // Display message when there's no video


                    ),
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
                            (index) {
                          // Adjust tab titles based on courseType
                              if (courseType == "Live") {
                                // Only show "Overview" and "Review"
                                if (index == 0) {
                                  return Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center, // Center the text
                                      children: [
                                        SizedBox(
                                          width: 100, // Set equal spacing width
                                          child: Text(
                                            "Overview",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14), // Set consistent text size
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (index == 1) {
                                  return Tab(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 100, // Set equal spacing width
                                          child: Text(
                                            "Review",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                // For "General", show "Overview", "Lesson", and "Review"
                                if (index == 0) {
                                  return Tab(
                                    child: SizedBox(
                                      width: 70, // Fixed width for all tabs
                                      child: Center(
                                        child: Text(
                                          "Overview",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14), // Consistent font size
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (index == 1) {
                                  return Tab(
                                    child: SizedBox(
                                      width: 70,
                                      child: Center(
                                        child: Text(
                                          "Lessons",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (index == 2) {
                                  return Tab(
                                    child: SizedBox(
                                      width: 70,
                                      child: Center(
                                        child: Text(
                                          "Review",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }


                              return Container(); // This should never be reached
                        },
                      ),
                      onTap: (index) {
                        courceController.pController.jumpToPage(index); // Navigate to correct page
                      },
                    )


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
                  onTap: (){enrollInCourse();},
                  // onTap: () => Get.to(const ChoosePlane()),

                  buttonText: btnText.isNotEmpty ? btnText : 'Enroll Now',                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
