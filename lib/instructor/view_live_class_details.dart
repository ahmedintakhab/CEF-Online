import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/instructor/current_live_screen.dart';
import 'package:learn_megnagmet/instructor/past_live_screen.dart';
import 'package:learn_megnagmet/instructor/upcoming_live_screen.dart';

import '../Course_details_tabbar/current_screen.dart';
import '../Course_details_tabbar/upcoming_screen.dart';


class ViewLiveClassDetails extends StatefulWidget {
  const ViewLiveClassDetails({super.key});

  @override
  State<ViewLiveClassDetails> createState() => _ViewLiveClassDetailsState();
}

class _ViewLiveClassDetailsState extends State<ViewLiveClassDetails> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0; // Set default tab to Upcoming
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> _buildTabs() {
    return [
      Tab(text: 'Upcoming'),
      Tab(text: 'Current'),
      Tab(text: 'Past'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Tajweed ul Quran Asaan Treeqy sy (Urdu)',style: TextStyle(color: Color(0XFF78A03F),
            fontSize: 22.sp,fontWeight: FontWeight.bold),maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              height: 74.h,
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
                unselectedLabelColor: const Color(0XFF6E758A),
                labelColor: const Color(0XFF78A03F),
                indicator: ShapeDecoration(
                  color: const Color(0XFFEBF2C2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.h),
                  ),
                ),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: _buildTabs(),
                onTap: (index) {
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                 UpcomingLiveScreen(),
                CurrentLiveScreen(),
                 PastLiveScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}