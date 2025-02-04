import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:learn_megnagmet/utils/slider_page_data_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../controller/controller.dart';
import '../utils/screen_size.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final CompletedController completedController = Get.find<CompletedController>();

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);

    // Using Obx to observe the changes in completedCourses
    return Obx(() {
      // Print the list of completed courses to the console for debugging
      print("Completed Courses: ${completedController.completedCourses}");

      return completedController.completedCourses.isEmpty
          ? const Center(
        child: Text(
          'No completed courses yet',
          style: TextStyle(fontSize: 16, fontFamily: 'Gilroy'),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: completedController.completedCourses.length,
                itemBuilder: (context, index) {
                  final course = completedController.completedCourses[index];

                  // Debugging each course data
                  print("Course $index: $course");

                  return Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: index == 0 ? 0.h : 8.h,
                      bottom: 8.h,
                    ),
                    child: Container(
                      height: 124.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.h),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.14),
                            offset: const Offset(-4, 5),
                            blurRadius: 16.h,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Row(
                          children: [
                            Image(
                              image: NetworkImage(course['courseImage'] ?? 'No Image'),
                              height: 100.h,
                              width: 100.w,
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20.h),
                                Text(
                                  course['courseName'] ?? 'No Name',
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                // SizedBox(height: 10.h),
                                // Text(
                                //   "${course['lecturesRemaining'] ?? '0'} Lessons",
                                //   style: TextStyle(
                                //     color: Color(0XFF292929),
                                //     fontSize: 14.sp,
                                //     fontFamily: 'Gilroy',
                                //     fontWeight: FontWeight.w400,
                                //   ),
                                // ),
                                SizedBox(height: 15.h),
                                Row(
                                  children: [
                                    LinearPercentIndicator(
                                      padding: EdgeInsets.zero,
                                      width: 180.0.w,
                                      lineHeight: 6.0.h,
                                      percent: 1.0,
                                      trailing: Padding(
                                        padding: EdgeInsets.only(left: 12.w),
                                        child: Text(
                                          "100%",
                                          style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: const Color(0XFFDEDEDE),
                                      progressColor: const Color(0XFF8CC13F),
                                      barRadius: Radius.circular(22.w),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
