import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:learn_megnagmet/dashboard/all_leaderboard_result.dart';
import '../utils/api_constants.dart'; // Import your ApiConstants

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic>? leaderboardData;

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    print("🔄 Fetching Leaderboard API...");
    final url = "${ApiConstants.baseUrl}student/latestLeaderBoard";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Leaderboard API fetched successfully! Data length: ${data.length}");
        print("✅ Leaderboard API response code: ${response.statusCode}");
        setState(() {
          leaderboardData = data;
          isLoading = false;
        });
      } else {
        print("❌ Leaderboard API Error: ${response.statusCode}");
        setState(() {
          errorMessage = "Failed to load data (Code: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Exception in Leaderboard API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(left:16.w, right: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Gilroy',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to AllLeaderboardResult, passing full data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllLeaderboardResult(
                          leaderboardData: leaderboardData ?? [],
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF78A03F),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),

          // Loading/Error/Empty States
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(color: Color(0xFF78A03F)),
              ),
            )
          else if (leaderboardData == null || leaderboardData!.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'No Leaderboard Data',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
            else
            // ListView with dynamic height
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView.builder(
                  shrinkWrap: true, // Makes ListView take only the space it needs
                  physics: const BouncingScrollPhysics(),
                  itemCount: leaderboardData!.length > 10 ? 10 : leaderboardData!.length, // Limit to 10
                  itemBuilder: (context, index) {
                    final item = leaderboardData![index];
                    final statusColor = item['status'] == 'Passed' ? Colors.green.shade100 : Colors.red.shade100;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Rank number (using id)
                          Container(
                            width: 35.w,
                            height: 35.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                '${item['id']}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontFamily: 'Gilroy',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),

                          // Avatar with image (fixed to fill full radius)
                          CircleAvatar(
                            radius: 28.r,
                            backgroundImage: NetworkImage(
                              item['studentImage'] ?? 'https://via.placeholder.com/56',
                            ),
                            child: ClipOval(
                              child: Image.network(
                                item['studentImage'] ?? 'https://via.placeholder.com/56',
                                fit: BoxFit.cover,
                                width: 56.r * 2, // Match diameter to ensure full coverage
                                height: 56.r * 2,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Course, percentage, and status
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.h),
                                Text(
                                  item['courseName'] ?? 'No Course',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade600,
                                    fontFamily: 'Gilroy',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Text(
                                      '${item['obtainedPercentage'] ?? 0}%',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade600,
                                        fontFamily: 'Gilroy',
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Container(
                                      width: 90.w,
                                      height: 20.h,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${item['status'] ?? ''}',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                            fontFamily: 'Gilroy',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}