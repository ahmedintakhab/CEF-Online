import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:learn_megnagmet/quiz/leaderboard_screen.dart';
import 'package:learn_megnagmet/quiz/quiz_result.dart';
import 'package:learn_megnagmet/widget/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';

class QuizPage extends StatefulWidget {
  final List<dynamic> quizData;
  QuizPage({Key? key, required this.quizData}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<int, bool> _isLoading = {}; // Track loading state per index

  Future<Map<String, dynamic>> _fetchQuizResult(String quizId) async {
    const String apiUrl = '${ApiConstants.baseUrl}student/course/quiz-result';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'quiz_id': quizId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load quiz result data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.quizData.length,
        itemBuilder: (context, index) {
          final quiz = widget.quizData[index];
          // Initialize loading state for this index if not present
          _isLoading.putIfAbsent(index, () => false);

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
                    SizedBox(width: 80,),
                    Expanded(
                      child: Text(
                        quiz['quiz_name']?.toString() ?? '',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                        height: 55.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomButton(
                              onTap: _isLoading[index]!
                                  ? () {} // Disable button during loading
                                  : () async {
                                setState(() {
                                  _isLoading[index] = true;
                                });
                                try {
                                  final resultData = await _fetchQuizResult(quiz['quiz_id'].toString());
                                  Get.to(() => QuizResult(resultData: resultData));
                                } catch (e) {
                                  print('Error fetching quiz result: $e');
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading[index] = false;
                                    });
                                  }
                                }
                              },
                              buttonText: _isLoading[index]! ? '' : 'See Result',
                              buttonColor: const Color(0xFF78A03F),
                              textColor: Colors.white,
                            ),
                            if (_isLoading[index]!)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 55.h,
                        child: CustomButton(
                          onTap: () {
                            navigator?.push(MaterialPageRoute(
                                builder: (context) => LeaderboardScreen(quizId: quiz['quiz_id'].toString())));
                          },
                          buttonText: 'LeaderBoard',
                          buttonColor: const Color(0xFF78A03F),
                          textColor: Colors.white,
                        ),
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