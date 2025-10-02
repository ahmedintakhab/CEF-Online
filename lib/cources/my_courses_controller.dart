import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:learn_megnagmet/Course_details_tabbar/tabbar_details.dart';
import 'package:learn_megnagmet/cart/cart_screen.dart';
import 'package:learn_megnagmet/cources/request_enroll_course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_constants.dart';
import '../utils/custom_cache_manager.dart';

class CourseController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;
  late PageController pController;
  List<dynamic>? ongoingCourses;
  String coursePreviewSrc = '';
  String previewSrcType = '';
  String courseType = '';

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
  Future<void> refreshCourseDetails(String slug) async {
    final detailUrl = '${ApiConstants.baseUrl}frontend/course/detail/$slug';
    await CustomCacheManager.instance.removeFile(detailUrl);
    print("🗑️ Cleared course detail cache for slug: $slug");
    await fetchCourseDetails(slug);
    await fetchOngoingCourses(); // Also refresh ongoing courses if needed
  }

  Future<Map<String, dynamic>> fetchCourseDetails(String slug) async {
    final url = '${ApiConstants.baseUrl}frontend/course/detail/$slug';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // Try loading from cache
      final fileInfo = await CustomCacheManager.instance.getFileFromCache(url);
      if (fileInfo != null && fileInfo.file != null) {
        print("✅ Loaded course details from cache");
        final cachedData = await fileInfo.file.readAsString();
        final data = json.decode(cachedData);
        coursePreviewSrc = data['course_image'] ?? data['course_preview_src'] ?? '';
        courseType = data['course_type'];
        previewSrcType = data['course_image'] != null &&
            data['course_image'].isNotEmpty &&
            (data['course_image'].endsWith('.png') ||
                data['course_image'].endsWith('.jpg') ||
                data['course_image'].endsWith('.jpeg'))
            ? 'course_intro_image'
            : data['course_preview_src_type'] ?? 'course_intro_youtube_video';
        print("check course type for tabs: $courseType");
        print("check previewSrcType: $previewSrcType");
        print("check coursePreviewSrc: $coursePreviewSrc");
        return data;
      }

      // Fetch from API if not in cache
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'content-Type': 'Application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save to cache
        await CustomCacheManager.instance.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
        );

        coursePreviewSrc = data['course_image'] ?? data['course_preview_src'] ?? '';
        courseType = data['course_type'];
        previewSrcType = data['course_image'] != null &&
            data['course_image'].isNotEmpty &&
            (data['course_image'].endsWith('.png') ||
                data['course_image'].endsWith('.jpg') ||
                data['course_image'].endsWith('.jpeg'))
            ? 'course_intro_image'
            : data['course_preview_src_type'] ?? 'course_intro_youtube_video';
        print("check course type for tabs: $courseType");
        print("check previewSrcType: $previewSrcType");
        print("check coursePreviewSrc: $coursePreviewSrc");
        return data;
      }

      throw Exception('Failed to load course details');
    } catch (e) {
      print('Error fetching course details: $e');
      throw Exception('Error fetching course details: $e');
    }
  }

  Future<void> fetchOngoingCourses() async {
    final url = Uri.parse("${ApiConstants.baseUrl}student/my-learning");
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
        print("API URL: $btnApiRoute");
        print("Course ID: $courseId");
        print("Auth Token: $token");
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
        print("Enroll API Response Code: ${response.statusCode}");
        print("Enroll API Response Body: ${response.body}");

        if (response.statusCode == 200) {
          print("Enroll API response status code: ${response.statusCode}");
          print("API Successfully Enroll Course.");
// 🧹 Invalidate course detail cache after enrollment
          final detailUrl = '${ApiConstants.baseUrl}frontend/course/detail/$slug';
          await CustomCacheManager.instance.removeFile(detailUrl);
          print("🗑️ Cleared course detail cache for slug: $slug");
          // 🔄 Fetch fresh data before navigation
          await refreshCourseDetails(slug);
          // 🔄 Fetch fresh data before navigation
          // Navigate to TabBarDetails and remove MyCourses from stack
          Get.off(() => TabBarDetails(courseType: courseType, slug: slug));
          // await fetchCourseDetails( slug);

          Get.snackbar(
            'Success',
            'Successfully enrolled in the course',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.2),
            colorText: Colors.black,
            borderRadius: 10,
            margin: EdgeInsets.all(15),
            duration: Duration(seconds: 3),
          );
        }
      }

      else if (btnText == "Go to Course") {
        final response = await http.get(
          Uri.parse(btnApiRoute),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          print("Go to Course API response status code: ${response.statusCode}");
          print("API Successfully move on Course details.");
          final selectedCourse = ongoingCourses?.firstWhere(
                (course) => course['courseID'].toString() == courseId || course['courseSlug'] == slug,
            orElse: () => null,
          );

          if (selectedCourse != null) {
            Get.to(() => TabBarDetails(courseType: courseType,slug: slug));
            //Before Adding Tabbar
            // Get.to(() => CourceDetail(corcedetail: selectedCourse));
          }
        }
      }
      else if (btnText == "Request Enrollment"){
        Get.to(()=> RequestEnrollCourse(courseId: courseId,));
      }
      else if (btnText == "Buy Now") {
        print("API URL: $btnApiRoute");
        print("Course ID: $courseId");
        print("Auth Token: $token");
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
        print("Enroll API Response Code: ${response.statusCode}");
        print("Enroll API Response Body: ${response.body}");

        if (response.statusCode == 200) {
          print("Buy Now Course API response status code: ${response.statusCode}");
// 🧹 Invalidate course detail cache after enrollment
          final detailUrl = '${ApiConstants.baseUrl}frontend/course/detail/$slug';
          await CustomCacheManager.instance.removeFile(detailUrl);
          print("🗑️ Cleared course detail cache for slug: $slug");
          // 🔄 Fetch fresh data before navigation
          await refreshCourseDetails(slug);
          // 🔄 Fetch fresh data before navigation
          // Navigate to TabBarDetails and remove MyCourses from stack
          Get.off(() => CartScreen());
          // await fetchCourseDetails( slug);

          Get.snackbar(
            'Success',
            'Successfully added to cart!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.2),
            colorText: Colors.black,
            // borderRadius: 10,
            // margin: EdgeInsets.all(15),
            // duration: Duration(seconds: 3),
          );
        }
      }

    }
    catch (e) {
      print('Error during API call: $e');
    }
  }
}
