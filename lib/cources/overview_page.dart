import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';

import '../models/overview_page_grid_model.dart';
import '../models/overviewpage_instructur.dart';
import '../utils/html_utils.dart';
import '../utils/screen_size.dart';
import '../utils/slider_page_data_model.dart';
import '../widget/button.dart';
import 'choose_plane_screen.dart';
import 'overview_container.dart';

class Overview extends StatefulWidget {
  final dynamic overviewData; // Add this to accept the overviewData passed from previous page
  final String fetchedCourseType;
  const Overview({Key? key, required this.overviewData, required this.fetchedCourseType, }) : super(key: key);

  @override
  State<Overview> createState() => _OverviewState();
}
class _OverviewState extends State<Overview> {
  late final dynamic overviewData;
  HomeController homecontroller = Get.put(HomeController());
  List<OverViewGrid> grid = [];
  // List<Instructor> instuctor = [];
  bool activevalue = false;
  List<String> selectedCategory = [];
  @override
  void initState() {
    grid = Utils.getOverView();
    super.initState();
    overviewData = widget.overviewData;  // Assign passed data
    print('check tha overview data on overview page: $overviewData');
    print("Check the fetch course type on overview page: ${widget.fetchedCourseType}");

  }
  @override
  Widget build(BuildContext context) {
    // List of items to pass to the OverviewContainer
    final List<Map<String, String>> items = [
      {'image': 'assets/gridview1.png', 'title': '${overviewData['total_lessons']} Lessons'},
      {'image': 'assets/gridview2.png', 'title': overviewData['level'] ?? 'No Level' },
      {'image': 'assets/gridview3.png', 'title': overviewData['duration'] ??'No Duration'},
      {'image': 'assets/gridview4.png', 'title': overviewData['language'] ??'No Language'},
      {'image': 'assets/gridview5.png', 'title': 'Certificate'},
      {'image': 'assets/gridview6.png', 'title': 'Fully Secure'},
    ];
    final List<dynamic> skills = overviewData['skills'] ?? [];
    initializeScreenSize(context);
    // Convert HTML description to plain text
    final plainTextDescription = convertHtmlToPlainText(overviewData['description'] ?? '');
    return GetBuilder(
        init: HomeController(),
        builder: (controller) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      overviewData['title'] ?? 'No Title',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0XFF000000),
                          fontFamily: 'Gilroy'),
                    ),
                    ExpandableText(
                      plainTextDescription,
                      expandText: 'Learn more.',
                      collapseText: 'Learn less.',
                      maxLines: 3,
                      linkStyle: TextStyle(
                        color: const Color(0XFF78A03F),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Gilroy',
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0XFF6E758A),
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    OverviewContainer(items: items,fetchedCourseType: widget.fetchedCourseType),

                    // SizedBox(
                    //   child: GridView.count(
                    //     primary: false,
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     crossAxisCount: 3,
                    //     crossAxisSpacing: 4.0,
                    //     mainAxisSpacing: 8.0,
                    //
                    //     //reverse: true,
                    //     children: grid
                    //         .map((e) => Padding(
                    //               padding: EdgeInsets.all(6.0.h),
                    //               child: Container(
                    //                   decoration: BoxDecoration(
                    //                       borderRadius:
                    //                           BorderRadius.circular(22.h),
                    //                       color: const Color(0XFFF3F6FF)),
                    //                   child: Column(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.center,
                    //                     children: [
                    //                       Image(
                    //                         image: AssetImage(e.image!),
                    //                         height: 30.h,
                    //                         width: 30.w,color: Color(0XFF8CC13F),
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //                       SizedBox(height: 10.h),
                    //                       Text(
                    //                         e.title!,
                    //                         style: TextStyle(
                    //                             fontSize: 14.sp,
                    //                             color: const Color(0XFf000000),
                    //                             fontWeight: FontWeight.bold,
                    //                             fontFamily: 'Gilroy'),
                    //                       )
                    //                     ],
                    //                   )),
                    //             ))
                    //         .toList(),
                    //   ),
                    // ),
                    // SizedBox(height: 21.sp),
                    // Text(
                    //   "Instructor",
                    //   style: TextStyle(
                    //       fontFamily: 'Gilroy',
                    //       fontSize: 18.sp,
                    //       color: const Color(0XFF000000),
                    //       fontWeight: FontWeight.w700),
                    // ),
                    // ListView.builder(
                    //     scrollDirection: Axis.vertical,
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: overviewData['instructors']?.length ?? 0, // Safely handle null or empty
                    //     itemBuilder: (BuildContext,int index) {
                    //       // Get instructor data dynamically
                    //       final instructor = overviewData['instructors'][index];
                    //       return Padding(
                    //         padding: EdgeInsets.only(
                    //             top: index == 0 ? 0.h : 8.h,
                    //           bottom: index == overviewData['instructors'].length - 1 ? 0.h : 8.h,),
                    //         child: Container(
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(22.h),
                    //                 color: const Color(0XFFFFFFFF),
                    //                 boxShadow: [
                    //                   BoxShadow(
                    //                     color: const Color(0XFF23408F)
                    //                         .withOpacity(0.14),
                    //                     blurRadius: 20.0.h,
                    //                   ),
                    //                 ]),
                    //             height: 95.h,
                    //             width: 374.w,
                    //             child: Padding(
                    //               padding:
                    //                   EdgeInsets.only(left: 10.w, right: 10.w),
                    //               child: Row(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.center,
                    //                 children: [
                    //                   Image(
                    //                       image: NetworkImage(
                    //                           instructor['image'] ?? ''),
                    //                       height: 71.h,
                    //                       width: 71.w),
                    //                   SizedBox(width: 10.w),
                    //                   Column(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceEvenly,
                    //                     children: [
                    //                       Text(
                    //                         instructor['name'] ?? 'No Name',
                    //                         style: TextStyle(
                    //                             fontSize: 16.sp,
                    //                             color: const Color(0XFF000000),
                    //                             fontWeight: FontWeight.bold,
                    //                             fontFamily: 'Gilroy'),
                    //                       ), //SizedBox(height: 5),
                    //                       Text(
                    //                         instructor['professional_title'] ?? '',
                    //                         style: TextStyle(
                    //                             fontSize: 16.sp,
                    //                             color: const Color(0XFF000000),
                    //                             fontFamily: 'Gilroy'),
                    //                       )
                    //                     ],
                    //                   )
                    //                 ],
                    //               ),
                    //             )),
                    //       );
                    //     }),
                    SizedBox(height: 20.h),

                    Text(
                      "Skill",
                      style: TextStyle(
                          fontFamily: 'Gilroy',
                          fontSize: 18.sp,
                          color: Color(0XFF000000),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        for (final skill in skills)
                          Padding(
                            padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 8.w),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!selectedCategory.contains(skill)) {
                                    selectedCategory.add(skill);
                                  } else {
                                    selectedCategory.remove(skill);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 13.w),
                                decoration: BoxDecoration(
                                  color: selectedCategory.contains(skill)
                                      ? const Color(0XFFEBF2C2)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(26.h),
                                  border: Border.all(
                                    color: selectedCategory.contains(skill)
                                        ? const Color(0XFF8CC13F)
                                        : const Color(0XFF6E758A),
                                    width: 1.w,
                                  ),
                                ),
                                child: Text(
                                  skill, // Use the skill directly here
                                  style: selectedCategory.contains(skill)
                                      ? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF78A03F),
                                    fontFamily: 'Gilroy',
                                  )
                                      : const TextStyle(
                                    color: Color(0XFF6E758A),
                                    fontFamily: 'Gilroy',
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),


                  ],
                ),
              ),
            ));
  }
}
