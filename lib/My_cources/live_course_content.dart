import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'content_display_screen.dart';

class LiveCourseContent extends StatelessWidget {
  final List<dynamic> liveCourses;
  final Function? onLectureOpen; // Callback function to trigger refresh


  const LiveCourseContent({Key? key, required this.liveCourses,this.onLectureOpen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: liveCourses.length,
      itemBuilder: (context, index) {
        var courseCategory = liveCourses[index];
        var categoryResources = courseCategory['category_resources'];
        var categoryName = courseCategory['category_name'];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: index == 0 ? 0.h : 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isCategoryDisplayed(categoryName))
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Text(
                    courseCategory['category_name'],
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0XFF6E758A),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ...categoryResources.map<Widget>((resource) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 80.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.h),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0XFF23408F).withOpacity(0.14),
                          offset: const Offset(-4, 5),
                          blurRadius: 16,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 55.h,
                          width: 33.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.h),
                            color: const Color(0XFFEBF2C2),
                          ),
                          child: Center(
                            child: Text(
                              resource['resource_no'].toString(),
                              style: TextStyle(
                                color: Color(0XFF78A02A),
                                fontSize: 15.sp,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10),
                            child: Center(
                              child: Text(
                                resource['resource_name'],
                                style: TextStyle(
                                  color: Color(0XFF000000),
                                  fontSize: 17.sp,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to ContentDisplayScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentDisplayScreen(
                                  title: resource['resource_name'],
                                  contentType: resource['resource_type']?.toString().toLowerCase() ?? 'text',
                                  source: resource['redirect_preview_src'],
                                ),
                              ),
                            ).then((_) {
                              if (onLectureOpen != null) onLectureOpen!();
                            });
                          },
                          child: Icon(
                            Icons.open_in_new,
                            color: Color(0XFF8CC13F),
                            size: 26.w,
                          ),
                        ),                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  bool _isCategoryDisplayed(String categoryName) {
    Set<String> displayedCategories = {};
    if (!displayedCategories.contains(categoryName)) {
      displayedCategories.add(categoryName);
      return false;
    }
    return true;
  }
}