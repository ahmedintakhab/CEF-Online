// all_blogs_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllBlogsWidget extends StatelessWidget {
  final List<dynamic> blogs;

  const AllBlogsWidget({super.key, required this.blogs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Blogs',
          style: TextStyle(
            fontSize: 22.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
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
            child: blogs.isEmpty
                ? Center(
              child: Text(
                'No Blogs Available',
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
              itemCount: blogs.length, // Show all blogs
              itemBuilder: (context, index) {
                final blog = blogs[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to blog details (implement as needed)
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.r),
                            child: Image.network(
                              blog['blog_image'] ?? 'https://via.placeholder.com/90',
                              width: 120.w,
                              height: 80.h,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 90.w,
                                height: 90.h,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.article,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog['blog_date'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                                Text(
                                  blog['blog_title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Gilroy',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
  }
}