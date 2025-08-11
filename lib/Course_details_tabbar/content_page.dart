import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../My_cources/live_course_content.dart';
import '../My_cources/non_live_course_content.dart';

class ContentPage extends StatelessWidget {
  final String courseType;
  final List<dynamic> courseContent;
  final Function? onLectureOpen;

  const ContentPage({
    Key? key,
    required this.courseType,
    required this.courseContent,
    this.onLectureOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: courseType == 'Live'
              ? LiveCourseContent(
            liveCourses: courseContent,
            onLectureOpen: onLectureOpen,
          )
              : NonLiveCourseContent(
            nonLiveCourses: courseContent,
            onLectureOpen: onLectureOpen,
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Padding(
        //     padding: EdgeInsets.only(bottom: 40.h, top: 15.h),
        //     child: Container(
        //       height: 56.h,
        //       width: 374.w,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20.h),
        //         color: const Color(0XFF78A03F),
        //       ),
        //       child: Center(
        //         child: Text(
        //           "Continue Course",
        //           style: TextStyle(
        //             color: Color(0XFFFFFFFF),
        //             fontSize: 18.sp,
        //             fontWeight: FontWeight.w700,
        //             fontFamily: 'Gilroy',
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}