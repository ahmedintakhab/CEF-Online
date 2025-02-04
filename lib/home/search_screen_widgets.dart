import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../cources/cources.dart';
import 'filter_sheet.dart';
import 'search_screen_controller.dart';

class SearchTextField extends StatelessWidget {
  final SearchScreenController controller;

  const SearchTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: TextFormField(
        controller: controller.searchController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0XFF78A03F), width: 1.w),
            borderRadius: BorderRadius.circular(22.h),
          ),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: const Color(0XFF9B9B9B),
            fontSize: 15.sp,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Image.asset('assets/search.png', height: 24.h, width: 24.w),
          suffixIcon: GestureDetector(
            onTap: () {
              final query = controller.searchController.text.trim();
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.h),
                ),
                context: context,
                builder: (context) => FilterSheet(
                  query: query,
                  categoryData: controller.categoryData,
                  subcategoriesData: controller.subcategoriesData,
                  onFilterApplied: (filteredCourses) {
                    controller.courseSuggestions = List<Map<String, dynamic>>.from(filteredCourses);
                    controller.courseResult = controller.courseSuggestions;
                    controller.update();
                    controller.searchController.clear();
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 5.h,
                width: 5.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/filtericon.png"),
                    colorFilter: ColorFilter.mode(
                      Color(0xFF8CC13F),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.h)),
        ),
      ),
    );
  }
}

class HorizontalDesign extends StatelessWidget {
  final SearchScreenController controller;

  const HorizontalDesign({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: double.infinity.w,
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categorywithimages.length,
        itemBuilder: (BuildContext context, index) {
          final category = controller.categorywithimages[index];
          // print('check the ,,,,,,,,,,,,data: $category');
          return GestureDetector(
              onTap: () {
                // Fetch category-wise courses on click
                controller.fetchCategoryWiseCourses(category['id']);
              },
          child: Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0.w : 6.w),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.h),
                  child: Image.network(
                    category['image'] ?? 'No image',
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 120.w,
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                  child: Text(
                    category['name'] ?? 'No Name',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0XFF000000),
                      fontSize: 14.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          )
          );
        },
      ),
    );
  }
}

class TrendingCourses extends StatelessWidget {
  final SearchScreenController controller;

  const TrendingCourses({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller.courseResult.isEmpty) {
      return FutureBuilder(
        future: Future.delayed(Duration(seconds: 5)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0XFF8CC13F),
              ),
            );
          } else {
            return Center(
              child: Text(
                'No Result found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          }
        },
      );
    }
    return SizedBox(
      height: 302.h,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.courseResult.length,
        itemBuilder: (BuildContext context, int index) {
          final courses = controller.courseResult[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: GestureDetector(
              onTap: () {
                final slug = courses['course_slug'];
                if (slug != null) {
                  Get.to(() => MyCources(slug: slug));
                } else {
                  print("Slug is null");
                }
              },
              child: Container(
                height: 302.h,
                width: 177.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.h),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0XFF23408F).withOpacity(0.14),
                      offset: const Offset(-4, 5),
                      blurRadius: 16.h,
                    ),
                  ],
                  color: const Color(0XFFFFFFFF),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 165.h,
                      width: 190.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(courses['course_image'].toString()),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12.h),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10.h,
                          left: 10.w,
                          bottom: 130.h,
                          right: 130.w,
                        ),
                        child: Container(
                          height: 30.h,
                          width: 30.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/like.png",
                              height: 13.08.h,
                              width: 13.08.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.w, right: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),
                          Text(
                            courses['course_title'].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Gilroy',
                              color: const Color(0XFF000000),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 27.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.h),
                                    color: const Color(0XFFFAF4E1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/staricon.png",
                                        height: 15.h,
                                        width: 15.w,
                                      ),
                                      Text(
                                        courses['star_rating'].toString(),
                                        style: TextStyle(
                                          color: const Color(0XFFFFC403),
                                          fontFamily: 'Gilroy',
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (courses['duration'] != null && courses['duration'] != 0)
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/clock.png",
                                        height: 17.h,
                                        width: 17.w,
                                        color: Color(0XFF8CC13F),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${courses['duration'].toString()} Days',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: const Color(0XFF000000),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Gilroy',
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (courses['course_price'] != null && courses['course_price'].toString() != "Rs 0.00")
                                  ...[
                                    Text('Price:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                    Container(
                                      height: 35.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.h),
                                        color: const Color(0XFFEBF2C2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          courses['course_price'] ?? 'Null',
                                          style: TextStyle(
                                            color: Color(0XFF78A03F),
                                            fontFamily: 'Gilroy',
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                              ],
                            ),
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
    );
  }
}