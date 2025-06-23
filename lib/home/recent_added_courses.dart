import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/Course_details_tabbar/tabbar_details.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class RecentAddedCourses extends StatelessWidget {
  final Map<String, dynamic> apiData;

  const RecentAddedCourses({Key? key, required this.apiData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newCourses = apiData['myCourses'] ?? [];

    // Initialize recentAdded dynamically with the same length as newCourses
    List<Map<String, dynamic>> recentAdded = List.generate(
      newCourses.length,
          (index) => {'buttonStatus': false},
    );

    if (newCourses == null || newCourses.isEmpty) {
      return Center(
        child: Text(
          'No my courses available',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Container(
      color: const Color(0XFFFFFFFF),
      height: 500.h,
      width: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        itemCount: newCourses.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          final latest = newCourses[index];
          String courseType = latest['type'].toString(); // Fetch Type from API
          String slug = latest['slug'].toString();
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabBarDetails(courseType: courseType, slug: slug)
                  ));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                width: 276.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0XFF23408F).withOpacity(0.14),
                      offset: const Offset(-4, 5),
                      blurRadius: 16,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Language Container
                      Container(
                        height: 28.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0XFFE8F0FF),
                        ),
                        child: Center(
                          child: Text(
                            latest['language']?.toString() ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0XFF23408F),
                              fontFamily: 'Gilroy',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Title
                      Text(
                        latest['title']?.toString() ?? "Course Title",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          color: const Color(0XFF000000),
                          fontFamily: 'Gilroy',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8.h),

                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0XFFFFC403),
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            latest['average_rating']?.toString() ?? "0.00",
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: const Color(0XFFFFC403),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Square Image Container
                      Container(
                        height: 250.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 250.h,
                                width: double.infinity,
                                child: latest['image'] != null
                                    ? Image.network(
                                  latest['image'].toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey[400],
                                        size: 40.sp,
                                      ),
                                    );
                                  },
                                )
                                    : Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[400],
                                    size: 40.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Subtitle
                      Text(
                        latest['subtitle']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0XFF666666),
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 12.h),

                      // Price and Lessons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Lessons Container
                          Flexible(
                            child: Container(
                              height: 32.h,
                              constraints: BoxConstraints(minWidth: 90.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0XFFE0E0E0),
                                  width: 1,
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_arrow,
                                      color: const Color(0XFF666666),
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Flexible(
                                      child: Text(
                                        latest['no_of_classes']?.toString() ?? '',
                                        style: TextStyle(
                                          color: const Color(0XFF666666),
                                          fontFamily: 'Gilroy',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Flexible(
                                      child: Text(
                                        "classes",
                                        style: TextStyle(
                                          color: const Color(0XFF666666),
                                          fontFamily: 'Gilroy',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      if (courseType == 'General') ...[
                        LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          width: 150.0,
                          lineHeight: 6.0,
                          percent: double.parse(latest['progress']) / 100, // Progress dynamic
                          trailing: Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Text(
                              '${latest['progress']}%', // Dynamic progress
                              style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          backgroundColor: const Color(0XFFDEDEDE),
                          progressColor: const Color(0XFF8CC13F),
                          barRadius: const Radius.circular(22),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}