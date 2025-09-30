// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/login/login_empty_state.dart';
import 'package:learn_megnagmet/widget/button.dart';

import '../utils/api_constants.dart';
import '../utils/screen_size.dart';
import '../widget/custom_text_form_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController verificationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool ispassHiden = true;
  bool ispassHiden1 = true;
  final _formKey = GlobalKey<FormState>();

  void toggle() {
    setState(() {
      ispassHiden = !ispassHiden;
    });
  }

  void toggle1() {
    setState(() {
      ispassHiden1 = !ispassHiden1;
    });
  }
  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final url = '${ApiConstants.baseUrl}reset-password';
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'otp': verificationController.text,
            'email': emailController.text,
            'password': passwordController.text,
            'password_confirmation': confirmpasswordController.text,
          }),
        );

        if (response.statusCode == 200) {
          // Success case
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              backgroundColor: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Image(
                          image: const AssetImage("assets/Privacy2.png"),
                          height: 88.13.h,
                          width: 76.33.w,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Changed!",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Your password has been changed successfully!",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          onTap: () {
                            Get.off(() => const EmptyState());
                          },
                          buttonText: "OK",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Error case
          Get.snackbar(
            'Error',
            'Failed to reset password. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child:Form(key: _formKey,
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        back_button(),
                        SizedBox(width: 20.w),
                        Center(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontFamily: 'Gilroy',
                              color: Color(0XFF000000),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 36.h),
                    Expanded(
                      child: ListView(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Enter password which are different from the previous paswords.",
                              style: TextStyle(
                                color: Color(0XFF000000),
                                fontSize: 15.sp,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          customTextFormField(
                            controller: verificationController,
                            hintText: 'Type your verification code',
                            labelText: 'Verification Code',
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Enter your verification code';
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          customTextFormField(
                            controller: emailController,
                            hintText: 'Email',
                            labelText: 'Email',
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Enter the email';
                              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)) {
                                return "Please enter valid email address";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          customTextFormField(
                            controller: passwordController,
                            hintText: 'Password',
                            labelText: 'Password',
                            obscureText: ispassHiden,
                            suffixIcon: ispassHiden
                                ? GestureDetector(
                              onTap: toggle,
                              child: Image(
                                image:
                                const AssetImage("assets/notvisible_eye.png"),
                                height: 20.h,
                                width: 20.w,
                              ),
                            )
                                : GestureDetector(
                              onTap: toggle,
                              child: Image(
                                image: const AssetImage("assets/visible_eye.png"),
                                height: 20.h,
                                width: 20.w,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Enter the password';
                              if (val.length < 6)
                                return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          customTextFormField(
                            controller: confirmpasswordController,
                            hintText: 'Confirm password',
                            labelText: 'Confirm Password',
                            obscureText: ispassHiden1,
                            suffixIcon: ispassHiden1
                                ? GestureDetector(
                              onTap: toggle1,
                              child: Image(
                                image:
                                const AssetImage("assets/notvisible_eye.png"),
                                height: 20.h,
                                width: 20.w,
                              ),
                            )
                                : GestureDetector(
                              onTap: toggle1,
                              child: Image(
                                image: const AssetImage("assets/visible_eye.png"),
                                height: 20.h,
                                width: 20.w,
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Enter the confirm password';
                              if (val != passwordController.text)
                                return 'Passwords do not match';
                              return null;
                            },
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(onTap: resetPassword,
                              isLoading: isLoading,
                              buttonText: 'Done')
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

  Widget back_button() {
    return TextButton(
      onPressed: () {
        Get.back();
      },
      child: Image(
        image: const AssetImage("assets/back_arrow.png"),
        height: 24.h,
        width: 24.w,
      ),
    );
  }
}