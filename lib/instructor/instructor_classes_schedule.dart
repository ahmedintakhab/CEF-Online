import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/instructor/instructor_group_class_history.dart';
import 'package:learn_megnagmet/instructor/instructor_group_schedule_class.dart';
import 'package:learn_megnagmet/instructor/instructor_individual_class_history.dart';
import 'package:learn_megnagmet/instructor/instructor_individual_schedule_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class InstructorClassesSchedule extends StatefulWidget {
  @override
  _InstructorClassesScheduleState createState() => _InstructorClassesScheduleState();
}

class _InstructorClassesScheduleState extends State<InstructorClassesSchedule>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  Map <String, dynamic> classScheduleData = {};
  bool isLoading = true;
  String errorMessage = '';


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _fetchClassSchedule();
  }
  Future<void> _fetchClassSchedule() async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}instructor/classes-schedule");

      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // Make the API request
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Successful API call
        print("Instructor Classes Schedule API Response: ${response.statusCode}");
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            classScheduleData = responseData['data'];
            isLoading = false;
          });
          print("Parsed Schedule data: $classScheduleData");
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'API returned unsuccessful response';
          });
        }
      } else {
        // Handle API error
        print("API Error: ${response.statusCode} - ${response.body}");
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Handle network errors
      print("Exception: $e");
      setState(() {
        isLoading = false;
        errorMessage = 'Network error occurred. Please try again.';
      });
    }
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
            fontSize: 24.sp,
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 7.h),
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
                      indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 3),
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
      body: _buildBody(),
    );
  }
  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0XFF8CC13F),));
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(fontSize: 16.sp, color: Colors.red),
        ),
      );
    }

    // Get data for individual and group classes from the API response
    final individualClasses = classScheduleData['individual_classes'] ?? [];
    final groupClasses = classScheduleData['group_classes'] ?? [];

    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController.animateTo(index);
      },
      children: [
        // Individual Schedule Tab
        SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: InstructorIndividualScheduleClass(Classes: individualClasses)),
        ),


        // Group Schedule Tab
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: InstructorGroupScheduleClass(Classes: groupClasses),
          ),
        ),
      ],
    );
  }
}