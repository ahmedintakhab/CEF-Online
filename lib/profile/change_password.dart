import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import 'package:http/http.dart' as http;
import '../widget/button.dart';
import '../widget/custom_text_form_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
  Future<void> _changePassword() async {
    if (_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // API endpoint for changing password (adjust the endpoint as per your API)
      final url = Uri.parse("${ApiConstants.baseUrl}student/update-password");

      // Prepare the request body
      final body = jsonEncode({
        'old_password': _oldPasswordController.text,
        'new_password': _newPasswordController.text,
      });

      // Make the POST API request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Change Password Api response: ${response.statusCode}');
        Get.snackbar('Password Change','Password Update Successfully', snackPosition: SnackPosition.BOTTOM);

        // Clear the fields
        _oldPasswordController.clear();
        _newPasswordController.clear();
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Failed to update password')),
        );
      }
    } catch (e) {
      print('API error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  // Add this new void function
  // void _handleUpdate() {
  //   _changePassword(); // Call the async function without awaiting
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                      color: Color(0XFF78A03F),
                    ),
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
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10.r,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        "Old Password",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          color: const Color(0xFF000080),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _oldPasswordController,
                        hintText: "Old Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Old password is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "New Password",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          color: const Color(0xFF000080),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _newPasswordController,
                        hintText: "New Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "New password is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      CustomButton(
                        onTap: _isLoading ? () {} : _changePassword,
                        buttonText: _isLoading ? 'Updating...' : 'Update',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
