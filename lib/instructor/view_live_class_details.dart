import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/instructor/current_live_screen.dart';
import 'package:learn_megnagmet/instructor/past_live_screen.dart';
import 'package:learn_megnagmet/instructor/upcoming_live_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/api_constants.dart';



class ViewLiveClassDetails extends StatefulWidget {
  final String courseuuid; // Add uuid parameter

  const ViewLiveClassDetails({Key? key, required this.courseuuid}) : super(key: key);

  @override
  State<ViewLiveClassDetails> createState() => _ViewLiveClassDetailsState();
}

class _ViewLiveClassDetailsState extends State<ViewLiveClassDetails> with TickerProviderStateMixin {
  late TabController _tabController;

  String courseTitle = '';
  List<Map<String, dynamic>> upcomingData = [];
  List<Map<String, dynamic>> currentData = [];
  List<Map<String, dynamic>> pastData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0;
    fetchLiveClasses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchLiveClasses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('auth_token') ?? '';

    String apiUrl = "${ApiConstants.baseUrl}instructor/live-class-list/${widget.courseuuid}";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("View Live classes API response:${response.statusCode}");
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            courseTitle = data['data']['course']['title'];
            upcomingData = List<Map<String, dynamic>>.from(data['data']['upcoming_live_classes']);
            currentData = List<Map<String, dynamic>>.from(data['data']['current_live_classes']);
            pastData = List<Map<String, dynamic>>.from(data['data']['past_live_classes']);
            isLoading = false;
          });
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load live classes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching live classes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching live classes: $e')),
      );
    }
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
        title:  Text(courseTitle,style: TextStyle(color: Color(0XFF78A03F),
            fontSize: 22.sp,fontWeight: FontWeight.bold),maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0XFF8CC13F),))
          :Column(
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
                UpcomingLiveScreen(classes: upcomingData,
                  courseuuid: widget.courseuuid,
                ),
                CurrentLiveScreen(classes: currentData),
                PastLiveScreen(classes: pastData,
                  courseuuid: widget.courseuuid
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}