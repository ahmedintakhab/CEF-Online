import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:learn_megnagmet/quiz/leaderboard_screen.dart';
import 'package:learn_megnagmet/quiz/quiz_result.dart';
import 'package:learn_megnagmet/widget/button.dart';

class QuizPage extends StatefulWidget {
  final List<dynamic> quizData;
   QuizPage({Key? key, required this.quizData}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  @override
  Widget build(BuildContext context) {
    print('Check the quiz data on Quiz screen: ${widget.quizData}');
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.quizData.length,
        itemBuilder: (context, index) {
          final quiz = widget.quizData[index];
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
                      quiz['quiz_name']?.toString() ?? '',
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
                      quiz['quiz_type']?.toString() ?? '',
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
                      quiz['total_questions']?.toString() ?? '',
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
                      quiz['time_duration']?.toString() ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                 SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(

                      child: SizedBox(
                        height: 50.h,
                        child: CustomButton(onTap: (){
                          navigator?.push(MaterialPageRoute(builder: (context)=>QuizResult()));
                        }, buttonText: 'See Result'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: CustomButton(onTap: (){
                          navigator?.push(MaterialPageRoute(builder:
                              (context)=>LeaderboardScreen(quizId : quiz['quiz_id'].toString())));
                        }, buttonText: 'LeaderBoard'),
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