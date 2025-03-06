// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/home/home_main.dart';
import 'package:learn_megnagmet/login/forgot_password.dart';
import 'package:learn_megnagmet/login/sign_up/sign_up_empty_screen.dart';
import 'package:learn_megnagmet/utils/shared_pref.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/widget/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_constants.dart';
import '../utils/screen_size.dart';

class EmptyState extends StatefulWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  State<EmptyState> createState() => _EmptyStateState();
}
bool isLoading = false;

class _EmptyStateState extends State<EmptyState> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool ispassHiden = false;
  bool isPasswordHidden = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }
  Future<void> saveUserData(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save user details
    prefs.setString('user_name', userDetails['name'] ?? '');
    prefs.setString('email', userDetails['email'] ?? '');
    prefs.setString('phone_number', userDetails['mobile_number'] ?? '');
    prefs.setString('avatar', userDetails['avatar'] ?? '');
    prefs.setString('auth_token', userDetails['auth_token'] ?? ''); // Save the token

    // Save any additional fields you need
  }

  Future<void> login(String email, String password) async {
    // Define the API URL
    final String apiUrl = "${ApiConstants.baseUrl}login";

    // Prepare the request body
    Map<String, String> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
        },
        body: jsonEncode(requestBody), // Convert the request body to JSON
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = jsonDecode(response.body);
        PrefData.setLogin(true); // Update login state
        print("Login successful!");
        await saveUserData(data['userDetails']);
        print("User data saved successfully!");
        // Include token in userDetails
        final userDetails = data['userDetails'];
        userDetails['auth_token'] = data['token']; // Add token to userDetails

        // Save userDetails with token
        await saveUserData(userDetails);

        print("User details and token saved successfully!");
        Get.to(const HomeMainScreen());

        // Process the response data as needed
      } else {
        Get.snackbar('Login Failed', 'Invalid email or password', snackPosition: SnackPosition.BOTTOM);
        print("Login failed: ${response.body}");
        // Handle errors
      }
    } catch (e) {
      print("Error: $e");
      // Handle exceptions
    }finally {
      // Stop the loading indicator after the API call finishes
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Padding(
            padding:  EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(exit(0));
                  },
                  child:  Image(
                    image: const AssetImage("assets/back_arrow.png"),
                    height: 24.h,
                    width: 24.w,
                  )
                ),

                Expanded(
                  flex: 1,
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              fontFamily: 'Gilroy',
                              color: Color(0XFF000000)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                          child: Text(
                            "Glad to meet you again!",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: const Color(0XFF000000),
                                fontSize: 15.sp,
                                fontFamily: 'Gilroy',
                                fontStyle: FontStyle.normal
                            ),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(height: 10.h),
                      email_password_form(),
                      SizedBox(height: 21.h),
                      forgotpassword(),
                      SizedBox(height: 40.h),
                      loginbutton(),
                      SizedBox(height: 40.h),
                      or_sign_in_with_text(),
                      SizedBox(height: 41.h),
                      login_google(),
                      SizedBox(height: 20.h),
                      login_facebook(),
                      //SizedBox(height: 97.h),

                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 30.h),
                  child: sign_up(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  toggle() {
    setState(() {
      ispassHiden = !ispassHiden;
    });
  }

  Widget forgotpassword() {
    return GestureDetector(
      onTap: () {
        Get.to(const ForgotPassword());
      },
      child:  Align(
        alignment: Alignment.topRight,
        child: Text(
          "Forgot password ?",
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
            color: Color(0XFF78A03F),
          ),
        ),
      ),
    );
  }

  Widget loginbutton() {
    return Center(
      child: GestureDetector(
        onTap: () async{
          if (formkey.currentState!.validate()) {
            setState(() {
              isLoading = true; // Start showing loading spinner
            });
            // PrefData.setLogin(true);
            await login(emailController.text, passwordController.text);
            //PrefData.setVarification(true);
          }


        },
        child: Container(
          height: 56.h,
          width: 374.w,
          //color: Color(0XFF23408F),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0XFF78A03F),
          ),
          child:  Center(
            child:isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ):Text("Log In",
                style: TextStyle(
                    color: Color(0XFFFFFFFF),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy')),
          ),
        ),
      ),
    );
  }

  Widget login_google() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Image(image: AssetImage("assets/google.png")),
            SizedBox(width: 10.w),
            Text(
              "Login with Google",
              style: TextStyle(color: Color(0XFF000000), fontSize: 18.sp,fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget login_facebook() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 56.h,
        width: 374.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(0.1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Image(image: AssetImage("assets/facebook.png")),
            SizedBox(width: 10.w),
            Text(
              "Login with Facebook",
              style: TextStyle(color: const Color(0XFF000000), fontSize: 18.sp,fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget sign_up() {
    return Center(
      child: RichText(
          text: TextSpan(
              text: 'Already have an account?',
              style:  TextStyle(color: Colors.black, fontSize: 15.sp,fontFamily: 'Gilroy'),
              children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.to(const SignInEmptyScreen());
                },
              text: ' Sign up',
              style:  TextStyle(
                color: Color(0XFF000000),
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy'
              ),
            )
          ])),
    );
  }

  Widget or_sign_in_with_text() {
    return Row(
      children: [
         Expanded(
          child: Divider(
            height: 0.h,
            thickness: 2,
            indent: 20,
            endIndent: 0,
            color: const Color(0XFFDEDEDE),
          ),
        ),
        GestureDetector(
          child:  Text("OR Sign in with",
              style: TextStyle(
                  color: const Color(0XFF000000),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Gilroy',fontStyle: FontStyle.normal)),
        ),
         Expanded(
          child: Divider(
            height: 0.h,
            thickness: 2,
            indent: 20,
            endIndent: 0,
            color: const Color(0XFFDEDEDE),
          ),
        )
      ],
    );
  }

  Widget email_password_form() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          customTextFormField(controller: emailController, hintText: "Email",
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Enter the  email';
                } else {
                  if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                      .hasMatch(val)) {
                    return 'Please enter valid email address';
                  }
                }
                return null;
              },),

           SizedBox(height: 15.h),
          customTextFormField(
            controller: passwordController,
            hintText: "Password",
            isPasswordField: true, // Specify it's a password field
            obscureText: isPasswordHidden, // Dynamically updating with state
            validator: (val) {
              if (val == null || val.isEmpty) return 'Enter the password';
              return null;
            },
            suffixIcon: GestureDetector(
              onTap: togglePasswordVisibility,
              child: Image(
                image: AssetImage(isPasswordHidden
                    ? "assets/notvisible_eye.png"
                    : "assets/visible_eye.png"),
                height: 20.h,
                width: 20.w,
                color: isPasswordHidden ? null : const Color(0XFF8CC13F),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
