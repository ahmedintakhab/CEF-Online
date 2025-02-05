// lib/widgets/category_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryList extends StatelessWidget {
  final List<dynamic>? categories;

  const CategoryList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories == null || categories!.isEmpty) {
      return _buildShimmerList();
    }

    return Container(
      height: 150.h,
      width: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories!.length,
        itemBuilder: (BuildContext context, index) {
          final category = categories![index];
          return _buildCategoryItem(category, index);
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return Container(
      height: 150.h,
      width: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0.w : 6.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 120.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, int index) {
    return Padding(
      padding: EdgeInsets.only(left: index == 0 ? 0.w : 6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image(
              image: NetworkImage(category['image']),
              height: 100.h,
              width: 100.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 120.w,
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
            child: Text(
              category['name'] ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0XFF000000),
                fontSize: 12.sp,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}