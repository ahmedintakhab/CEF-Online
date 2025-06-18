import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizResult extends StatelessWidget {
  final List<Map<String, dynamic>> resultData = [
    {
      'module': 'Module 01',
      'selectedAnswer': 'True',
      'isCorrect': true,
    },
    {
      'module': 'Module 02',
      'selectedAnswer': 'False',
      'isCorrect': false,
    },
    {
      'module': 'Module 03',
      'selectedAnswer': 'False',
      'isCorrect': true,
    },
    {
      'module': 'Module 04',
      'selectedAnswer': 'False',
      'isCorrect': true,
    },
    {
      'module': 'Module 05',
      'selectedAnswer': 'True',
      'isCorrect': true,
    },
  ];

   QuizResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Test Quiz(Your Result)'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle:  TextStyle(color: Color(0xFF78A03F),
            fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  'Total Score: 10',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18.sp),
                ),
                Text(
                  'Your Score: 8',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 18.sp),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: resultData.length,
                itemBuilder: (context, index) {
                  final module = resultData[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module['module'],
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Update selection logic can be added here if needed
                            },
                            child: Row(
                              children: [
                                Text(
                                  'True',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: module['selectedAnswer'] == 'True' ? Colors.green : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  module['selectedAnswer'] == 'True' ? Icons.check : null,
                                  color: module['selectedAnswer'] == 'True' ? Colors.green : null,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              // Update selection logic can be added here if needed
                            },
                            child: Row(
                              children: [
                                Text(
                                  'False',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: module['selectedAnswer'] == 'False' ? Colors.red : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  module['selectedAnswer'] == 'False' ? Icons.close : null,
                                  color: module['selectedAnswer'] == 'False' ? Colors.red : null,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 170.w,height: 55.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child:  Text('BACK TO QUIZ',style: TextStyle(color: Colors.black,fontSize: 16.sp)),
                    ),
                  ),
                   SizedBox(width: 8.w),
                  Container(
                    width: 170.w,height: 55.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF78A03F)),
                      child:  Text('LEADERBOARD',style: TextStyle(color: Colors.white,fontSize: 16.sp)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}