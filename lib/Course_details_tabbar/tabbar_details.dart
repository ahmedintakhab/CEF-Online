import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add this import
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON parsing
import '../utils/api_constants.dart';
import 'overview_page.dart';
import 'content_page.dart';
import 'quiz_page.dart';
import 'assignment_page.dart';
import 'notice_page.dart';
import 'live_class_page.dart';
import 'discussion_page.dart';
import 'certificate_page.dart';
import 'review_page.dart';

class TabBarDetails extends StatefulWidget {
  final String courseType;
  final String slug;
  TabBarDetails({Key? key, required this.courseType, required this.slug}) : super(key: key);

  @override
  State<TabBarDetails> createState() => _TabBarDetailsState();
}

class _TabBarDetailsState extends State<TabBarDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  // Initialize tabs based on courseType
  late List<String> tabs;
  late List<Widget> pages;
  List<dynamic> liveCourses = [];
  List<dynamic> nonLiveCourses = [];
  String courseId = '';


  // API Data
  Map<String, dynamic>? apiData;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();

    // Initialize tabs and pages
    initializeTabsAndPages();

    // Fetch data after the page is fully loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StudentCourseDetails();
    });
  }

  void initializeTabsAndPages() {
    // Set tabs and pages based on courseType
    if (widget.courseType == 'Live') {
      tabs = [
        'Overview',
        'Content',
        'Notice',
        'Discussion',
        'Review',
      ];
    } else {
      tabs = [
        'Overview',
        'Content',
        'Quiz',
        'Assignment',
        'Notice',
        'Live Class',
        'Discussion',
        'Certificate',
        'Review',
      ];
    }

    _tabController = TabController(length: tabs.length, vsync: this);
    _pageController = PageController();

    // Fetch API data
  }

  // Fetch data from API
  Future<void> StudentCourseDetails() async {
    final String apiUrl = '${ApiConstants.baseUrl}student/my-course/${widget.slug}';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }
      );

      if (response.statusCode == 200) {
        print("Student course details Api response: ${response.statusCode}");
        setState(() {
          apiData = json.decode(response.body);
          courseId = apiData!['course_id'].toString();
          print("Discussion Data: ${apiData!['course_discussion_tab']}");


          // Extract course content data
          if (widget.courseType == 'Live') {
            liveCourses = apiData?['course_content_tab']?['course_content_list_section'] ?? [];
            print('Live Courses: $liveCourses');

          } else {
            nonLiveCourses = apiData?['course_content_tab']?['course_content_list_section'] ?? [];
            print('Non Live Courses: $nonLiveCourses');

          }

          isLoading = false;
        });
        updatePages();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  void handleLectureOpen() {
    // Refresh the data when a lecture is opened
    StudentCourseDetails();
  }

  // Update pages with fetched data
  void updatePages() {
    if (apiData != null) {
      setState(() {
        pages = [
          OverviewPage(overviewData: apiData!['course_overview_tab']),
          ContentPage(
            courseType: widget.courseType,
            courseContent: widget.courseType == 'Live' ? liveCourses : nonLiveCourses,
            onLectureOpen: handleLectureOpen,
          ),
          if (widget.courseType != 'Live') QuizPage(),
          if (widget.courseType != 'Live') AssignmentPage(assignmentData: apiData!['course_assignment_tab']),
          NoticePage(noticeData: apiData!['course_notice_tab']),
          if (widget.courseType != 'Live')LiveClassPage(),
          DiscussionPage(discussionData: apiData!['course_discussion_tab'],courseId:courseId), // Pass the list
          if (widget.courseType != 'Live')CertificatePage(),
          ReviewPage(reviewData: apiData!['course_review_tab'],courseId :courseId),
        ];
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
      body: Column(
        children: [
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                apiData?['pageTitle'] ?? '',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTabBar(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Color(0XFF8CC13F),)) // Show loader while loading
                : _buildTabBarPages(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return  Container(
        height: 74,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0XFF23408F).withOpacity(0.20),
              blurRadius: 16,
            ),
          ],
          color: const Color(0XFFFFFFFF),
          // borderRadius: BorderRadius.circular(22),
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          unselectedLabelColor: const Color(0XFF6E758A),
          labelColor: const Color(0XFF78A03F),
          indicator: ShapeDecoration(
            color: const Color(0XFFEBF2C2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
          indicatorSize: TabBarIndicatorSize.tab,
          tabAlignment: TabAlignment.start,
          tabs: tabs.map((tab) => Tab(
            child: Text(
              tab,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          )).toList(),
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
    );
  }

  Widget _buildTabBarPages() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController.animateTo(index);
      },
      children: pages,
    );
  }
}