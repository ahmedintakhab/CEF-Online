import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCartItem extends StatelessWidget {
  final Map<String, dynamic> courseData;
  final Function onRemove;

  const CourseCartItem({
    Key? key,
    required this.courseData,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1.h),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: NetworkImage(courseData['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15.w),

          // Course Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseData['title'],
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0XFF000000),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // Rating
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(
                          index < (courseData['star_rating'] ?? 0).floor()
                              ? Icons.star
                              : index < (courseData['star_rating'] ?? 0)
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Color(0XFFFFC403),
                          size: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "(${courseData['rating_count'] ?? 0})",
                      style: TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Type
                Text(
                  courseData['type'] ?? "Course",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Price and Remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${courseData['price']} Rs",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF000000),
                ),
              ),
              SizedBox(height: 25.h),
              GestureDetector(
                onTap: () => onRemove(),
                child: Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}