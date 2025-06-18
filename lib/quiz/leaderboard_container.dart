import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaderboardContainer extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {"rank": 1, "name": "Ahmed", "score1": "10(67%)", "score2": "8(80%)", "status": "Passed"},
    {"rank": 2, "name": "Nouman", "score1": "6(60%)", "score2": "6(60%)", "status": "Fail"},
    {"rank": 3, "name": "Nouman", "score1": "6(60%)", "score2": "6(60%)", "status": "Fail"},
    {"rank": 4, "name": "Nouman", "score1": "6(60%)", "score2": "6(60%)", "status": "Fail"},
    {"rank": 5, "name": "Nouman", "score1": "4(40%)", "score2": "4(40%)", "status": "Fail"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFB300),
      padding: EdgeInsets.all(16.0.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leaderboard',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: ListView.builder(
              itemCount: leaderboardData.length,
              itemBuilder: (context, index) {
                final data = leaderboardData[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  padding: EdgeInsets.all(8.0.r),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 20.w,
                        child: Text('${data['rank']}', style: TextStyle(fontSize: 16.sp)),
                      ),
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, size: 22.sp, color: Colors.white),
                      ),
                      SizedBox(
                        width: 80.w,
                        child: Text(data['name'], style: TextStyle(fontSize: 16.sp)),
                      ),
                      SizedBox(
                        width: 70.w,
                        child: Text(data['score1'], style: TextStyle(fontSize: 16.sp)),
                      ),
                      SizedBox(
                        width: 70.w,
                        child: Text(data['score2'], style: TextStyle(fontSize: 16.sp)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.0.w, vertical: 4.0.h),
                        decoration: BoxDecoration(
                          color: data['status'] == 'Passed' ? Colors.green : Colors.redAccent,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          data['status'],
                          style: TextStyle(fontSize: 14.sp, color: Colors.white),
                        ),
                      ),
                    ],
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