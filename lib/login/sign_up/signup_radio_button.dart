import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:learn_megnagmet/login/sign_up/sign_up_empty_screen.dart';
import 'instructor_signup_screen.dart';

class SignupRadioButton extends StatefulWidget {
  const SignupRadioButton({super.key});

  @override
  State<SignupRadioButton> createState() => _SignupRadioButtonState();
}

class _SignupRadioButtonState extends State<SignupRadioButton>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  void initializeScreenSize(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SignUp',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/back_arrow.png', // Use same back arrow as in EmptyState/MyProfile
            height: 24.h,
            width: 24.w,
          ),
          onPressed: () {
            Get.back(); // Navigate to previous screen
          },
        ),
      ),
      body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Let's get your journey started",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                  color: const Color(0XFF000000),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Please enter your credentials",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20.h),
           Container(
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(22.h),
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
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
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
                    indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: "Student"),
                      Tab(text: "Instructor"),
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
            SizedBox(height: 20.h),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _tabController.animateTo(index);
                },
                children: const [
                  StudentSignupScreen(),
                  InstructorSignupScreen(),
                ],
              ),
            ),
          ],
        ),
      );
  }
}