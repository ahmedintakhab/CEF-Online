import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import 'content_display_screen.dart';

class LiveCourseContent extends StatelessWidget {
  final List<dynamic> liveCourses;
  final Function? onLectureOpen; // Callback function to trigger refresh

  const LiveCourseContent({Key? key, required this.liveCourses, this.onLectureOpen}) : super(key: key);

  // Function to map resource_type to ContentDisplayScreen contentType
  String _mapResourceTypeToContentType(String resourceType) {
    resourceType = resourceType.toLowerCase();
    if (resourceType == 'slide document') {
      return 'webview'; // Use webview for Slide Document
    }
    switch (resourceType) {
      case 'pdf':
        return 'pdf';
      case 'video':
        return 'video';
      case 'youtube':
        return 'youtube';
      case 'audio':
        return 'audio';
      case 'image':
        return 'image';
      case 'text':
        return 'text';
      default:
        return 'text'; // Default to text for unknown types
    }
  }

  // Function to map resource_type to IconData
  IconData _getIconForResourceType(String resourceType) {
    resourceType = resourceType.toLowerCase();
    switch (resourceType) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'video':
        return Icons.videocam;
      case 'youtube':
        return Icons.play_circle_fill; // YouTube is a video, so use a play icon
      case 'audio':
        return Icons.audiotrack;
      case 'image':
        return Icons.image;
      case 'text':
        return Icons.text_fields;
      case 'slide document':
        return Icons.slideshow;
      default:
        return Icons.file_open; // Default icon for unknown types
    }
  }

  // Function to validate YouTube URL
  bool _isValidYouTubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  @override
  Widget build(BuildContext context) {
    print('Live Courses: $liveCourses');
    return ListView.builder(
      itemCount: liveCourses.length,
      itemBuilder: (context, index) {
        var courseCategory = liveCourses[index];
        var categoryResources = courseCategory['data'] ?? [];
        var categoryName = courseCategory['name']?.toString() ?? '';

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: index == 0 ? 0.h : 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isCategoryDisplayed(categoryName))
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h, top: 15.h),
                  child: Text(
                    courseCategory['name'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: Color(0XFF6E758A),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ...categoryResources.map<Widget>((resource) {
                // Get the resource type for icon mapping
                String resourceType = resource['type']?.toString() ?? 'text';
                return GestureDetector(
                  onTap: () {
                    // Map resource_type to contentType
                    String contentType = _mapResourceTypeToContentType(resourceType);
                    // Validate YouTube URL if contentType is 'youtube'
                    if (contentType == 'youtube' &&
                        !_isValidYouTubeUrl(resource['preview_src'] ?? '')) {
                      Get.snackbar('Error', 'Invalid YouTube URL provided');
                      return;
                    }
                    // Navigate to ContentDisplayScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDisplayScreen(
                          title: resource['name'] ?? '',
                          contentType: contentType,
                          source: resource['preview_src'],
                        ),
                      ),
                    ).then((_) {
                      if (onLectureOpen != null) onLectureOpen!();
                    });
                  },
                  child: Padding(
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
                                resource['sr_no']?.toString() ?? '',
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
                                  resource['name'] ?? '',
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
                          Icon(
                            _getIconForResourceType(resourceType), // Dynamic icon based on resource type
                            color: Color(0XFF8CC13F),
                            size: 26.w,
                          ),
                        ],
                      ),
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
    // Note: This Set is recreated on every build, which may cause all categories to display.
    // Consider making it static or state-managed if this is not the intended behavior.
    Set<String> displayedCategories = {};
    if (!displayedCategories.contains(categoryName)) {
      displayedCategories.add(categoryName);
      return false;
    }
    return true;
  }
}