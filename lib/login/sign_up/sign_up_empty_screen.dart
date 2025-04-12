import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/login/login_empty_state.dart';
import 'package:learn_megnagmet/login/sign_up/phone_number_field.dart';
import 'package:learn_megnagmet/login/sign_up/sign_in_phonenumber.dart';
import 'package:learn_megnagmet/login/sign_up/term_and_condition.dart';
import 'package:learn_megnagmet/widget/custom_text_form_field.dart'; // Update the import path if necessary
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/api_constants.dart';
import '../../utils/screen_size.dart';
import '../../widget/dropdown_button.dart';

class StudentSignupScreen extends StatefulWidget {
  const StudentSignupScreen({Key? key}) : super(key: key);

  @override
  State<StudentSignupScreen> createState() => _StudentSignupScreenState();
}

class _StudentSignupScreenState extends State<StudentSignupScreen> {

  bool ischeaked = false;
  bool ispassHiden = true;
  bool ispassHiden1 = true;

  String passworderror = '';
  final formkey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController referralcodeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";



  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordHidden = !isPasswordHidden;
    });
  }
  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordHidden = !isConfirmPasswordHidden;
    });
  }
  Future<void> registerUser() async {
    final url = '${ApiConstants.baseUrl}register';

    // Prepare the data for the API
    final data = {
      'first_name': firstnameController.text,
      'last_name': lastnameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'time_zone': timezoneController.text,
      'phone_number': phoneNumber,
      'referral_code': referralcodeController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Successfully registered
        final responseData = json.decode(response.body);
        // Handle the response data as needed
        print('Signup successful: $responseData');
        Get.to(const EmptyState()); // Redirect to phone number screen
      } else {
        // Error handling
        print('Signup failed: ${response.body}');
        // Show error message to the user
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
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
        body: Padding(
          padding:  EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  SizedBox(height: 60.h),
              // back_button(),
              //  SizedBox(height: 20.h),
              //  Center(
              //   child: Text(
              //     "Create an account",
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 24.sp,
              //         fontFamily: 'Gilroy',
              //         color: const Color(0XFF000000)),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
             //  SizedBox(height: 20.h),
              Expanded(
                child:ListView(
                  children: [
                    detailform(),
                    SizedBox(height: 25.h),
                    term_condition_cheakbox(),
                    SizedBox(height: 25.h),
                    sign_up_button(),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(bottom: 30.h),
                child: already_login_button(),
              ),
              //Checkbox
            ],
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
  toggle1() {
    setState(() {
      ispassHiden1 = !ispassHiden1;
    });
  }

  Widget detailform() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          customTextFormField(controller: firstnameController, hintText: "First Name",
              validator: (val) {
                     if (val!.isEmpty) return 'Enter the First Name';
                    return null;
                  },),

          SizedBox(height: 20.h),
          customTextFormField(controller:lastnameController, hintText: "Last Name",
              validator: (val){
                   if (val!.isEmpty) return 'Enter the Last Name';
                   return null;
                 },),

          SizedBox(height: 20.h),
          customTextFormField(controller: emailController, hintText: "Email",
              validator: (val) {
                if (val!.isEmpty)
                  return 'Enter the  email';
                else {
                  if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)) {
                    return "Please enter valid email address";
                  }
                }
                return null;
              },),

           SizedBox(height: 20.h),
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

           SizedBox(height: 20.h),
          DropdownButtonWidget(controller: timezoneController, hintText: "Select Time Zone",
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please select time zone ';
                return null;
              },),


          SizedBox(height: 20.h),
        phone_number_field(
          onPhoneNumberChanged: (String phone) {
            setState(() {
              phoneNumber = phone; // Store the phone number
            });
          },
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
        ),

        SizedBox(height: 10.h),

          customTextFormField(controller: referralcodeController, hintText: "Referral Code",
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please enetr Referral code  ';
              return null;
            },),
        ],

      ),
    );
  }

  Widget term_condition_cheakbox() {
    return Row(
      children: [
        Checkbox(

          activeColor: const Color(0XFF78A03F),
          side: const BorderSide(color: Color(0XFFDEDEDE)),
          value: ischeaked,
          onChanged: (value) {
            setState(() {
              ischeaked = value!;
            });
          },
        ),
        RichText(
            text: TextSpan(
                text: 'I Agree with ',
                style:  TextStyle(color: Colors.black, fontSize: 15.sp, fontFamily: 'Gilroy',fontWeight: FontWeight.w400),
                children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {

                    Get.to(const TermCondition());
                  },
                text: 'Terms and condition',
                style: const TextStyle(
                    color: Color(0XFF78A03F),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Gilroy'),
              )
            ])),
      ],
    );
  }

  Widget sign_up_button() {
    return Container(
      height: 56.h,
      width: 374.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0XFF78A03F),
      ),
      child: TextButton(
        onPressed: ischeaked
            ? () {
                if (formkey.currentState!.validate()) {
                  // if (confirmpassController.value == passwordController.value) {
                  //   Get.to(const SignInPhonenumber());
                    registerUser(); // Call your register function here

                  }
                }

            : null,
        child:  Text("Sign Up",
            style: TextStyle(
                color: Color(0XFFFFFFFF),
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy')),
      ),
    );
  }

  Widget already_login_button() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
          text: TextSpan(
              text: 'Already have an account? ',
              style:  TextStyle(color: Colors.black, fontSize: 15.sp,fontFamily: 'Gilroy'),
              children: [
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.off(const EmptyState());
                },
              text: 'Login',
              style:  TextStyle(
                  color: const Color(0XFF000000),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy'),
            )
          ])),
    );
  }

  Widget back_button() {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context, true);
        },
        child: Image(
          image: const AssetImage("assets/back_arrow.png"),
          height: 24.h,
          width: 24.w,
        ));
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpassController.dispose();
    super.dispose();
  }
}

