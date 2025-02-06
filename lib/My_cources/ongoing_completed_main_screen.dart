import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';

import '../utils/screen_size.dart';
import 'completed_screen.dart';
import 'ongoing_screen.dart';

class OngoingCompletedScreen extends StatefulWidget {
  const OngoingCompletedScreen({Key? key}) : super(key: key);

  @override
  State<OngoingCompletedScreen> createState() => _OngoingCompletedScreenState();
}

class _OngoingCompletedScreenState extends State<OngoingCompletedScreen> {
  final OngoingCompletedController ongoingCompletedController =
  Get.put(OngoingCompletedController()); // GetX Controller

  final List<Widget> courcesClass = [
    OngoingScreen(),
    CompletedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: GetBuilder<OngoingCompletedController>(
          init: OngoingCompletedController(),
          builder: (controller) => Column(
            children: [
              SizedBox(height: 73.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        SystemChannels.platform.invokeMethod(
                            'SystemNavigator.pop');
                      },
                      child: Image(
                        image: const AssetImage("assets/back_arrow.png"),
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "My Courses",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 54,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.h),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0XFF23408F).withOpacity(0.14),
                          offset: const Offset(-4, 5),
                          blurRadius: 16.h),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w, right: 8.w),
                    child: TabBar(
                      controller: controller.tabController,
                      unselectedLabelColor: const Color(0XFF6E758A),
                      padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                      labelStyle: TextStyle(
                          color: const Color(0XFF23408F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          fontFamily: 'Gilroy'),
                      labelColor: const Color(0XFF78A02A),
                      unselectedLabelStyle: TextStyle(
                          color: const Color(0XFF23408F),
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          fontFamily: 'Gilroy'),
                      indicator: ShapeDecoration(
                        color: const Color(0XFFEBF2C2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.h),
                        ),
                      ),
                      indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: "Ongoing"),
                        Tab(text: "Completed"),
                      ],
                      onTap: (index) {
                        controller.pController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: PageView(
                  controller: controller.pController,
                  onPageChanged: (index) {
                    controller.tabController.animateTo(index);
                  },
                  children: courcesClass,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
