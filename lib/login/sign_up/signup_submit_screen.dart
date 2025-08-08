import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:learn_megnagmet/login/login_empty_state.dart';
import 'package:learn_megnagmet/widget/button.dart';
import '../../utils/api_constants.dart';
import '../../utils/screen_size.dart';

class SignupSubmitScreen extends StatefulWidget {
  final VoidCallback onBack;
  final int courseTypeId;
  final String courseName;
  final int courseId;
  final Map<String, dynamic> formData;

  const SignupSubmitScreen({
    required this.onBack,
    required this.courseTypeId,
    required this.courseName,
    required this.courseId,
    required this.formData,
    super.key,
  });

  @override
  _SignupSubmitScreenState createState() => _SignupSubmitScreenState();
}

class _SignupSubmitScreenState extends State<SignupSubmitScreen> {
  bool _isLoading = false;

  Future<void> _submitSignup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiUrl = '${ApiConstants.baseUrl}register';
      final headers = {'Content-Type': 'application/json'};

      // Print individual fields before passing to API
      print('course_type: ${widget.courseTypeId}');
      print('course: ${widget.courseId}');
      print('fullname: ${widget.formData['fullname']}');
      print('phone: ${widget.formData['phone']}');
      print('email: ${widget.formData['email']}');
      print('city: ${widget.formData['city']}');
      print('country: ${widget.formData['country']}');
      print('age: ${widget.formData['age']}');
      print('school_grade: ${widget.formData['school_grade']}');
      print('parent_name: ${widget.formData['parent_name']}');
      print('preferred_teacher: ${widget.formData['gender']}');
      print('how_many_students: ${widget.formData['how_many_students']}');
      print('preferDate: ${widget.formData['preferDate']}');
      print('preferSlot: ${widget.formData['preferSlot']}');
      print('password: ${widget.formData['password']}');

      final body = json.encode({
        'course_type': widget.courseTypeId,
        'course': widget.courseId,
        'fullname': widget.formData['fullname'],
        'phone': widget.formData['phone'],
        'area_code': '+92',
        'email': widget.formData['email'],
        'city': widget.formData['city'],
        'country': widget.formData['country'],
        'age': widget.formData['age'],
        'school_grade': widget.formData['school_grade'],
        'parent_name': widget.formData['parent_name'],
        'preferred_teacher': widget.formData['gender'],
        'how_many_students': widget.formData['how_many_students'],
        'preferDate': widget.formData['preferDate'],
        'preferSlot': widget.formData['preferSlot'],
        'password': widget.formData['password'],
      });

      // Print full request details
      print('API Request URL: $apiUrl');
      print('API Request Headers: $headers');
      print('API Request Body: $body');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      // Print response details
      print('API Response Status Code: ${response.statusCode}');
      print('API Response Headers: ${response.headers}');
      print('API Response Body: ${response.body}');

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        print('Signup successful!');
        Get.snackbar('Success', 'User Successfully Registered!', snackPosition: SnackPosition.TOP);

        Get.off(() => const EmptyState());
      } else {
        print('Signup failed with status code: ${response.statusCode}');
        Get.snackbar('Failed', 'User Registration Failed ', snackPosition: SnackPosition.TOP);

      }
    } catch (e) {
      print('Error during API call: $e');
      setState(() {
        _isLoading = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      Get.snackbar('Failed', 'User Registration Failed ', snackPosition: SnackPosition.TOP);

      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Your Selection',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                'You selected the course: ${widget.courseName}',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'Gilroy'),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: CustomButton(onTap: widget.onBack, buttonText: 'BACK')),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomButton(
                          onTap: _isLoading ? () {} : () => _submitSignup(),
                          buttonText: 'SUBMIT',
                        ),
                        if (_isLoading)
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                      ],
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