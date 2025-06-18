import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/quiz/leaderboard_container.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle:  TextStyle(color: Color(0xFF78A03F),
            fontSize: 26.sp, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h,),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFF1E90FF), // Navy blue background
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              ),
              child: const Text(
                'Your Position  Student Quiz Marks Your Marks Status',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(
                    '10',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white, size: 22),
                      ),
                       SizedBox(width: 8.w),
                       Text(
                        'MN Nouman',
                        style: TextStyle(fontSize: 16.sp, color: Colors.blue),
                      ),
                    ],
                  ),
                  Text(
                    '10(67%)',
                    style: TextStyle(fontSize: 16.sp, color: Colors.blue),
                  ),
                   Text(
                    '8/80%',
                    style: TextStyle(fontSize: 16.sp, color: Colors.blue),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:  Text(
                      'Passed',
                      style: TextStyle(fontSize: 14.sp, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h,),
            Expanded(
                child: LeaderboardContainer()),
          ],
        ),
      ),
    );
  }
}