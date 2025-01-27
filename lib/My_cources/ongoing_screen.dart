import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/controller/controller.dart';
import 'package:learn_megnagmet/utils/slider_page_data_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/screen_size.dart';
import 'cources_details.dart';

class OngoingScreen extends StatefulWidget {
  const OngoingScreen({Key? key}) : super(key: key);

  @override
  State<OngoingScreen> createState() => _OngoingScreenState();
}

class _OngoingScreenState extends State<OngoingScreen> {
  OngoingController ongoingController = Get.put(OngoingController());
  CompletedController completedController = Get.put(CompletedController());
  List ongoingCource = Utils.getOngoingCource();
  bool isLoading = true; // To show a loading indicator
  String errorMessage = '';
  List< dynamic>? ongoingCourses;
  List <dynamic>? completeCourses;

  @override
  void initState() {
    super.initState();
    fetchOngoingCourses();
  }
  Future<void> fetchOngoingCourses() async {
    final url = Uri.parse("https://cefonlineacademy.com/api/student/my-learning");
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // Make the API request
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json', // Set content type
          // Add Authorization token if required
           'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("API fetched data successfully!");
        final data = json.decode(response.body);
        print("API Data on Ongoing Page: $data"); // Debug: Print the full API data
        ongoingCourses = data['on_going']; // Adjust key based on API response
        print("API fetched ongoing course data!: $ongoingCource");
        completeCourses = data['completed'];
        print('Complete courses data strore in completeCourses: $completeCourses');
        completedController.setCompletedCourses(completeCourses ?? []);

        setState(() {
          isLoading = false;

        });
      } else {
        // Debug errors
        print("Error: Failed to fetch data. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        setState(() {
          errorMessage = "Failed to fetch data. Status: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      // Catch and debug exceptions
      print("Exception occurred: $e");
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0XFF8CC13F),),
      );
    }
    return GetBuilder(
        init: OngoingController(),
        builder: (OngoingController) => ListView.builder(

            itemCount: ongoingCourses?.length,
            itemBuilder: (context, index) {
              final ongoing = ongoingCourses?[index];
              String courseType = ongoing['courseType']; // Fetch courseType from API
              // print('Check the ongoing data inside function: $ongoing');
              return Padding(
                padding:  EdgeInsets.only(
                    top: 8.h, bottom: 8.h, right: 15.w, left: 15.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CourceDetail(
                                corcedetail:ongoing)));
                  },
                  child: Container(
                    height: 124,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0XFF23408F)
                                  .withOpacity(0.14),
                              offset: const Offset(-4, 5),
                              blurRadius: 16),
                        ],
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10),
                      child: Row(
                        children: [
                          Image(
                            image: NetworkImage(
                                ongoing['courseImage'] ?? 'No image loaded'),
                            height: 100,
                            width: 100,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  ongoing['courseName'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Gilroy',
                                      fontStyle: FontStyle.normal),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),
                                if (courseType == 'General') ...[
                                  Text(
                                    '${ongoing['lecturesRemaining']} Lectures to go',
                                    style: const TextStyle(color: Color(0XFF292929)),
                                  ),
                                  const SizedBox(height: 10),
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    width: 170.0,
                                    lineHeight: 6.0,
                                    percent: ongoing['progress'] / 100, // Progress dynamic
                                    trailing: Padding(
                                      padding: EdgeInsets.only(left: 4.w),
                                      child: Text(
                                        '${ongoing['progress']}%', // Dynamic progress
                                        style: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    backgroundColor: const Color(0XFFDEDEDE),
                                    progressColor: const Color(0XFF8CC13F),
                                    barRadius: const Radius.circular(22),
                                  ),
                                ],

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}

