import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/login/sign_up/custom_progress_bar.dart';
import 'package:learn_megnagmet/login/sign_up/select_course.dart';
import 'package:learn_megnagmet/login/sign_up/sign_up_empty_screen.dart';
import 'package:learn_megnagmet/login/sign_up/signup_submit_screen.dart';
import 'course_type_selection.dart';
import 'instructor_signup_screen.dart';

class SignupTab extends StatefulWidget {
  const SignupTab({super.key});

  @override
  State<SignupTab> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentStep = 1;
  int _currentTabIndex = 0;
  int? _selectedCourseTypeId;
  String? _selectedCourseName;
  int? _selectedCourseId;
  Map<String, dynamic>? _formData;

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

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return CourseSelectionScreen(
          onNext: (int courseTypeId) {
            setState(() {
              _selectedCourseTypeId = courseTypeId;
            });
            _nextStep();
          },
        );
      case 2:
        return SelectCourse(
          onNext: (int courseTypeId, String courseName, int courseId) {
            setState(() {
              _selectedCourseTypeId = courseTypeId;
              _selectedCourseName = courseName;
              _selectedCourseId = courseId;
            });
            _nextStep();
          },
          onBack: _previousStep,
          courseTypeId: _selectedCourseTypeId!,
        );
      case 3:
        return StudentSignupScreen(
          onNext: (Map<String, dynamic> formData) {
            setState(() {
              _formData = formData;
            });
            _nextStep();
          },
          onBack: _previousStep,
          courseTypeId: _selectedCourseTypeId!,
          courseName: _selectedCourseName!,
          courseId: _selectedCourseId!,
        );
      case 4:
        return SignupSubmitScreen(
          onBack: _previousStep,
          courseTypeId: _selectedCourseTypeId!,
          courseName: _selectedCourseName!,
          courseId: _selectedCourseId!,
          formData: _formData!,
        );
      default:
        return Container();
    }
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
            'assets/back_arrow.png',
            height: 24.h,
            width: 24.w,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
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
            height: 54.h,
            width: double.infinity,
            decoration: BoxDecoration(
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
          if (_currentTabIndex == 0)
            CustomProgressBar(currentStep: _currentStep, totalSteps: 4),
          SizedBox(height: 20.h),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
                _tabController.animateTo(index);
              },
              children: [
                _buildStepContent(),
                InstructorSignupScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}