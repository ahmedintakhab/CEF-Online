import 'package:flutter/material.dart';
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
  TabBarDetails({Key? key, required this.courseType}) : super(key: key);

  @override
  State<TabBarDetails> createState() => _TabBarDetailsState();
}

class _TabBarDetailsState extends State<TabBarDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  // Initialize tabs based on courseType
  late List<String> tabs;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();

    // Set tabs and pages based on courseType
    if (widget.courseType == 'Live') {
      tabs = [
        'Overview',
        'Content',
        'Notice',
        'Live Class',
        'Discussion',
        'Certificate',
        'Review',
      ];
      pages = [
        OverviewPage(),
        ContentPage(),
        NoticePage(),
        LiveClassPage(),
        DiscussionPage(),
        CertificatePage(),
        ReviewPage(),
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
      pages = [
        OverviewPage(),
        ContentPage(),
        QuizPage(),
        AssignmentPage(),
        NoticePage(),
        LiveClassPage(),
        DiscussionPage(),
        CertificatePage(),
        ReviewPage(),
      ];
    }

    _tabController = TabController(length: tabs.length, vsync: this);
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
      body: Column(
        children: [
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Course Details",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTabBar(),
          Expanded(
            child: _buildTabBarPages(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
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
          borderRadius: BorderRadius.circular(22),
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