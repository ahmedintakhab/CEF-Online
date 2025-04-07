import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'group_class_schedule.dart';
import 'individual_class_schedule.dart';


class ClassScheduleScreen extends StatefulWidget {
  @override
  _ClassScheduleScreenState createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Classes Schedule',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Color(0XFF78A03F),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(90.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 64.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.h),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0XFF23408F).withOpacity(0.14),
                        offset: const Offset(-4, 5),
                        blurRadius: 16.h,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w, right: 8.w),
                    child: TabBar(
                      controller: _tabController,
                      unselectedLabelColor: const Color(0XFF6E758A),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                      labelStyle: TextStyle(
                        color: const Color(0XFF23408F),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        fontFamily: 'Gilroy',
                      ),
                      labelColor: const Color(0XFF78A02A),
                      unselectedLabelStyle: TextStyle(
                        color: const Color(0XFF23408F),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                        fontFamily: 'Gilroy',
                      ),
                      indicator: ShapeDecoration(
                        color: const Color(0XFFEBF2C2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.h),
                        ),
                      ),
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: "Individual"),
                        Tab(text: "Group"),
                      ],
                      onTap: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
        children: [
          // Individual Schedule Tab
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: IndividualSchedule(),
            ),
          ),

          // Group Schedule Tab
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GroupSchedule(),
            ),
          ),
        ],
      ),
    );
  }
}