import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllEnrollCoursesWidget extends StatelessWidget {
  final List<dynamic> enrolledCourses;

  const AllEnrollCoursesWidget({super.key, required this.enrolledCourses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Enrolled Courses',
          style: TextStyle(
            fontSize: 22.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: enrolledCourses.isEmpty
                ? Center(
              child: Text(
                'No Enrolled Courses',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  fontFamily: 'Gilroy',
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(15.w),
              itemCount: enrolledCourses.length,
              itemBuilder: (context, index) {
                final course = enrolledCourses[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to course details page
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XFF23408F).withOpacity(0.14),
                            offset: const Offset(-4, 5),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                course['courseImage'] ?? 'https://via.placeholder.com/100',
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 100.w,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: const Icon(
                                    Icons.book,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['courseName'] ?? 'No Title',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF23408F),
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '${course['TotalLessons']} lessons | ${course['TotalLessonsLectures']} lectures',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: 'Gilroy',
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 6.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.circular(22.r),
                                          ),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: (course['courseProgress'] ?? 0) / 100,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF8CC13F),
                                                borderRadius: BorderRadius.circular(22.r),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${course['courseProgress'] ?? 0}%',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      course['courseProgress'] == 0
                                          ? 'Not Started'
                                          : course['courseProgress'] == 100
                                          ? 'Completed'
                                          : 'In Progress',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontFamily: 'Gilroy',
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
  }
}