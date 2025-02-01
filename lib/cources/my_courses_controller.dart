import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/home/home_main.dart';
import '../My_cources/cources_details.dart';

class CourseController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  late PageController pController;
  List<dynamic>? ongoingCourses;
  String coursePreviewSrc = '';

  void initializeController(int length) {
    tabController = TabController(length: length, vsync: this);
    pController = PageController();
  }

  @override
  void onClose() {
    tabController.dispose();
    pController.dispose();
    super.onClose();
  }

  Future<Map<String, dynamic>> fetchCourseDetails(String slug) async {
    final url = 'https://cefonlineacademy.com/api/frontend/course/detail/$slug';
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'content-Type': 'Application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        coursePreviewSrc = data['course_preview_src'] ?? '';
        return data;
      }
      throw Exception('Failed to load course details');
    } catch (e) {
      print('Error fetching course details: $e');
      throw Exception('Error fetching course details: $e');
    }
  }

  Future<void> fetchOngoingCourses() async {
    final url = Uri.parse("https://cefonlineacademy.com/api/student/my-learning");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ongoingCourses = data['on_going'];
      } else {
        print("Error: Failed to fetch data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  Future<void> enrollInCourse(String courseId, String slug, String btnText, String btnApiRoute) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      if (btnText == "Enroll Now") {
        final response = await http.post(
          Uri.parse(btnApiRoute),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'course_id': courseId,
          }),
        );

        if (response.statusCode == 200) {
          Get.to(() => HomeMainScreen());
          Get.snackbar(
            'Success',
            'Successfully enrolled in the course',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.2),
            colorText: Colors.black,
            borderRadius: 10,
            margin: EdgeInsets.all(15),
            duration: Duration(seconds: 3),
          );
        }
      } else if (btnText == "Go to Course") {
        final response = await http.get(
          Uri.parse(btnApiRoute),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final selectedCourse = ongoingCourses?.firstWhere(
                (course) => course['courseID'].toString() == courseId || course['courseSlug'] == slug,
            orElse: () => null,
          );

          if (selectedCourse != null) {
            Get.to(() => CourceDetail(corcedetail: selectedCourse));
          }
        }
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }
}
