import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:learn_megnagmet/quiz/leaderboard_screen.dart';
import 'package:learn_megnagmet/quiz/quiz_result.dart';

class QuizPage extends StatelessWidget {
  final List<Map<String, dynamic>> quizData = [
    {
      'name': 'Test Quiz',
      'type': 'True false',
      'totalQuestions': 5,
      'duration': '1 minutes',
    },
    {
      'name': 'Test Quiz 2',
      'type': 'Multiple choice',
      'totalQuestions': 5,
      'duration': '1 minutes',
    },
  ];

   QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quizData.length,
        itemBuilder: (context, index) {
          final quiz = quizData[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quiz Name',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      quiz['name'],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quiz Types',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      quiz['type'],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Question',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      '${quiz['totalQuestions']}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Time Duration',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      quiz['duration'],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                 SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width:160.w,
                      child: ElevatedButton(
                        onPressed: () {
                          navigator?.push(MaterialPageRoute(builder: (context)=>QuizResult()));

                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF78A03F)),
                        child: const Text('SEE RESULT',style: TextStyle(color: Colors.white,fontSize: 13),),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      width: 160.w,
                      child: ElevatedButton(
                        onPressed: () {
                          navigator?.push(MaterialPageRoute(builder: (context)=>LeaderboardScreen()));

                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF78A03F)),
                        child: const Text('LEADERBOARD',style: TextStyle(color: Colors.white,fontSize: 13),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}