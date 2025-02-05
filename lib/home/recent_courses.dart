// lib/widgets/recent_courses.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../home/recent_added_cource_detail.dart';

class RecentCourses extends StatefulWidget {
  final Map<String, dynamic> apiData;

  const RecentCourses({
    Key? key,
    required this.apiData,
  }) : super(key: key);

  @override
  State<RecentCourses> createState() => _RecentCoursesState();
}

class _RecentCoursesState extends State<RecentCourses> {
  @override
  Widget build(BuildContext context) {
    final newCourses = widget.apiData['latestCourses'] ?? [];
    List<Map<String, dynamic>> recentAdded = List.generate(
      newCourses.length,
          (index) => {'buttonStatus': false},
    );

    if (newCourses.isEmpty) {
      return Center(
        child: Text(
          'No latest courses available',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Container(
      color: const Color(0XFFFFFFFF),
      height: 323.h,
      width: double.infinity.w,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        physics: const BouncingScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        itemCount: newCourses.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          final latest = newCourses[index];
          return _buildCourseCard(latest, index, recentAdded);
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> latest, int index, List<Map<String, dynamic>> recentAdded) {
    return GestureDetector(
      onTap: () {
        Get.to(RecentCourceDetail(corcedetail: latest));
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
                    blurRadius: 16
                ),
              ],
              color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCourseImage(latest, index, recentAdded),
                _buildCourseRating(latest),
                SizedBox(height: 11.h),
                _buildCourseTitle(latest),
                SizedBox(height: 11.h),
                _buildCourseFooter(latest),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseImage(Map<String, dynamic> latest, int index, List<Map<String, dynamic>> recentAdded) {
    return Container(
      height: 158.h,
      width: 276.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(latest['image'].toString()),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: 230.w, bottom: 120.h, top: 10.h),
        child: Container(
          height: 20.h,
          width: 20.w,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white
          ),
          child: IconButton(
            splashRadius: 10,
            onPressed: () {
              setState(() {
                recentAdded[index]['buttonStatus'] = !recentAdded[index]['buttonStatus'];
              });
            },
            icon: Center(
              child: Image.asset(
                recentAdded[index]['buttonStatus']
                    ? "assets/saveboldblue.png"
                    : "assets/savebold.png",
                height: 10.h,
                width: 9.w,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseRating(Map<String, dynamic> latest) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, top: 10.h),
          child: Container(
            height: 25.h,
            width: 58.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0XFFFAF4E1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: const AssetImage("assets/staricon.png"),
                  height: 17.h,
                  width: 17.w,
                ),
                Text(
                  latest['star_rating'].toString(),
                  style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: const Color(0XFFFFC403),
                      fontSize: 15.sp
                  ),
                ),
              ],
            ),
          ),
        ),
        if (latest['duration'] != null && latest['duration'] != 0)
          Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: Row(
              children: [
                Image(
                  image: const AssetImage("assets/clock.png"),
                  height: 17.h,
                  width: 17.w,
                  color: const Color(0XFF8CC13F),
                ),
                SizedBox(width: 4.w),
                Text(
                  "${latest['duration']} Day's",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0XFF000000),
                    fontFamily: 'Gilroy',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCourseTitle(Map<String, dynamic> latest) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Text(
        latest['title'].toString(),
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: const Color(0XFF000000),
            fontFamily: 'Gilroy'
        ),
      ),
    );
  }

  Widget _buildCourseFooter(Map<String, dynamic> latest) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: NetworkImage(latest['user_pic'].toString()),
                height: 40.h,
                width: 40.w,
              ),
              SizedBox(width: 10.w),
              Text(
                latest['user_name'].toString(),
                style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w400,
                    color: const Color(0XFF5E8421),
                    fontSize: 15.sp
                ),
              ),
            ],
          ),
          if (latest['price'] != null && latest['price'].toString() != "Rs 0.00")
            Container(
              height: 35.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0XFFEBF2C2),
              ),
              child: Center(
                child: Text(
                  latest['price'].toString(),
                  style: TextStyle(
                      color: const Color(0XFF78A03F),
                      fontFamily: 'Gilroy',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}