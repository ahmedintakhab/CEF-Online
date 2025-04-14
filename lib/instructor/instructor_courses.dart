import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorCourses extends StatelessWidget {
  const InstructorCourses({Key? key}) : super(key: key);

  // Static data for courses (to be replaced with API data later)
  final List<Map<String, dynamic>> courses = const [
    {
      'image': 'https://assets.blurb.com/pages/website-assets/lp-homepage/3_Tradebooks-922752db04177f3417c8505ff1970f9d88be19f966cff7ce4654bd85c5073ac3.png', // Placeholder image
      'name': '25 Character Workshops for Grade 6 to 12',
      'price': 'Rs 4999.00',
      'rating': 4.3,
      'reviews': 3,
      'status': 'Published',
    },
    {
      'image': 'https://static.vecteezy.com/system/resources/thumbnails/040/534/371/small/ai-generated-enchanting-open-magic-book-colorful-generate-ai-photo.jpg', // Placeholder image
      'name': '25 Character Traits for Success: A Comprehensive Guide',
      'price': 'Rs 4999.00',
      'rating': 4.0,
      'reviews': 4,
      'status': 'Published',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize screen size for responsive design
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), // Standard mobile design size
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instructor Courses',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            children: courses.map((course) => _buildCourseCard(course)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF23408F).withOpacity(0.14),
            offset: const Offset(-4, 5),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Course Image and Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  course['image'],
                  height: 150.h,
                  width: 200.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // Course Name
              SizedBox(
                width: 190.w, // Adjust width to fit mobile screen
                child: Text(
                  course['name'],
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5.h),
              // Price and Rating
              Row(
                children: [
                  Text(
                    course['price'],
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Row(
                    children: [
                      Text(
                        course['rating'].toString(),
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Row(
                        children: List.generate(
                          5,
                              (index) => Icon(
                            index < course['rating'].floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '(${course['reviews']})',
                        style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              // Status
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF8CC13F),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  course['status'],
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Right Side: Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(
                text: 'Resources',
                color: const Color(0xFF23408F),
                onTap: () {
                  // Add functionality for Resources button
                  print('Resources button tapped');
                },
              ),
              SizedBox(height: 18.h),
              _buildButton(
                text: 'Quiz',
                color: const Color(0xFF8CC13F),
                onTap: () {
                  // Add functionality for Quiz button
                  print('Quiz button tapped');
                },
              ),
              SizedBox(height: 18.h),
              _buildButton(
                text: 'Assignment',
                color: const Color(0xFF7B3F8C),
                onTap: () {
                  // Add functionality for Assignment button
                  print('Assignment button tapped');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}