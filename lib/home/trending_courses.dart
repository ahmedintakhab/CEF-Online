// lib/widgets/trending_courses.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../cources/cources.dart';

class TrendingCourses extends StatefulWidget {
  final Map<String, dynamic> apiData;

  const TrendingCourses({
    Key? key,
    required this.apiData,
  }) : super(key: key);

  @override
  State<TrendingCourses> createState() => _TrendingCoursesState();
}

class _TrendingCoursesState extends State<TrendingCourses> {
  void toggle(int index, List<dynamic> courses) {
    setState(() {
      courses[index]['buttonStatus'] = !(courses[index]['buttonStatus'] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final trendingCourses = widget.apiData['trendingCourses'];

    return SizedBox(
      height: 234.h,
      width: double.infinity,
      child: trendingCourses == null || trendingCourses.isEmpty
          ? ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: _buildShimmerEffect(),
          );
        },
      )
          : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: trendingCourses.length,
        itemBuilder: (BuildContext context, index) {
          final course = trendingCourses[index];
          return _buildCourseItem(course, index, trendingCourses);
        },
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 172.h,
            width: 177.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 177.w,
            height: 20.h,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: 5.h),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 100.w,
            height: 15.h,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course, int index, List<dynamic> courses) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: GestureDetector(
        onTap: () {
      final slug = course['slug'];
      if (slug != null) {
        Get.to(MyCources(slug: slug));
      }
    },
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    height: 172.h,
    width: 177.w,
      // lib/widgets/trending_courses.dart (continued)

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        image: DecorationImage(
          image: NetworkImage(course['image'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 10.w,
          right: 147.w,
          bottom: 142.h,
        ),
        child: Container(
          height: 20.h,
          width: 20.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: GestureDetector(
              onTap: () => toggle(index, courses),
              child: Image(
                image: AssetImage(
                    course['buttonStatus'] == true
                        ? "assets/saveboldblue.png"
                        : "assets/savebold.png"
                ),
                height: 10.h,
                width: 9.w,
              ),
            ),
          ),
        ),
      ),
    ),
      SizedBox(height: 6.h),
      Expanded(
        child: SizedBox(
          width: 177.w,
          child: Text(
            course['title'] ?? '',
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              fontSize: 17.sp,
              color: const Color(0XFF000000),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ),
      SizedBox(height: 5.h),
      Text(
        course['subtitle'] ?? '',
        style: TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w700,
          fontSize: 15.sp,
          color: const Color(0XFF000000),
        ),
      ),
    ],
    ),
        ),
    );
  }
}