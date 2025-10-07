import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllLeaderboardResult extends StatelessWidget {
  final List<dynamic> leaderboardData;

  const AllLeaderboardResult({super.key, required this.leaderboardData});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            fontFamily: 'Gilroy',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: leaderboardData.isEmpty
                ? Center(
              child: Text(
                'No Leaderboard Data',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                  fontFamily: 'Gilroy',
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: leaderboardData.length, // Show all items
              itemBuilder: (context, index) {
                final item = leaderboardData[index];
                final statusColor = item['status'] == 'Passed' ? Colors.green.shade100 : Colors.red.shade100;
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        // Rank number (using id)
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5FF),
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
                        SizedBox(width: 16.w),

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
                        SizedBox(width: 16.w),

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
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Text(
                                    '${item['obtainedPercentage'] ?? 0}%',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Gilroy',
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}