import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/login/sign_up/phone_number_field.dart';
import 'package:learn_megnagmet/login/sign_up/term_and_condition.dart';

import '../../cart/custom_dropdown.dart';
import '../../utils/api_constants.dart';
import '../../utils/screen_size.dart';
import '../../widget/custom_text_form_field.dart';
import '../../widget/file_choosen_widget.dart';
import '../login_empty_state.dart';
class InstructorSignupScreen extends StatefulWidget {
  const InstructorSignupScreen({super.key});

  @override
  State<InstructorSignupScreen> createState() => _InstructorSignupScreenState();
}

class _InstructorSignupScreenState extends State<InstructorSignupScreen> {

  bool ischeaked = false;
  bool ispassHiden = true;
  bool ispassHiden1 = true;


  String passworderror = '';
  final formkey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController timezoneController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  String phoneNumber = "";

  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  String? selectedFilePath; // To store the selected file path
  String? fileError; // To store file validation error
  String? selectedAccountType; // To store the selected dropdown value
  bool isLoading = false; // loader state


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
  Future<void> _registerInstructor() async {
    if (!formkey.currentState!.validate() || selectedAccountType == null || selectedFilePath == null) {
      if (selectedFilePath == null) {
        setState(() {
          fileError = "Please choose a CV file";
        });
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // map dropdown value to int
      int accountType = selectedAccountType == "Instructor" ? 2 : 4;

      var uri = Uri.parse('${ApiConstants.baseUrl}sign-up-as-instructor');

      var request = http.MultipartRequest("POST", uri);
      request.fields.addAll({
        "first_name": firstnameController.text.trim(),
        "last_name": lastnameController.text.trim(),
        "account_type": accountType.toString(),
        "professional_title": professionController.text.trim(),
        "address": addressController.text.trim(),
        "about_me": bioController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "mobile_number": phoneNumber.trim(),
      });

      if (selectedFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath("cv_file", selectedFilePath!));
      }

      // 🔹 Print all data before hitting API
      print("======= Instructor Signup Request =======");
      request.fields.forEach((key, value) {
        print("$key : $value");
      });
      if (selectedFilePath != null) {
        print("cv_file : $selectedFilePath");
      }
      print("========================================");

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print('Signup instructor api response: ${response.statusCode}');
        Get.snackbar('Success', 'Instructor Successfully Registered!',
            snackPosition: SnackPosition.TOP);
        Get.off(const EmptyState());
      } else {
        print('Instructor signup api Failed: ${responseBody}');
        Get.snackbar('Failed', '${response.statusCode}',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      print('Instructor signup api Failed: $e');
      Get.snackbar('Failed', '$e',
          snackPosition: SnackPosition.TOP);
    } finally {
      setState(() {
        isLoading = false;
      });
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

// Add this widget method to your _InstructorSignupScreenState class

  Widget _buildRequiredFieldWithAsterisk({required Widget child, bool isRequired = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRequired)
          Padding(
            padding: EdgeInsets.only(left: 15.w, bottom: 3.h),
            child: Text(
              "*",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy',
                color: Colors.red,
              ),
            ),
          ),
        child,
      ],
    );
  }

// Updated detailform method with asterisks for required fields
  Widget detailform() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: firstnameController,
              hintText: "First Name",
              validator: (val) {
                if (val!.isEmpty) return 'Enter the First Name';
                return null;
              },
            ),
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: lastnameController,
              hintText: "Last Name",
              validator: (val){
                if (val!.isEmpty) return 'Enter the Last Name';
                return null;
              },
            ),
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: emailController,
              hintText: "Email",
              validator: (val) {
                if (val!.isEmpty)
                  return 'Enter the email';
                else {
                  if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val)) {
                    return "Please enter valid email address";
                  }
                }
                return null;
              },
            ),
          ),

          SizedBox(height: 20.h),
          // Account Type - appears to be optional based on no validator
          CustomDropdown(
            hint: "Account Type",
            value: selectedAccountType,
            items: const ["Instructor", "Organization"],
            onChanged: (String? newValue) {
              setState(() {
                selectedAccountType = newValue;
              });
            },
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: phone_number_field(
              onPhoneNumberChanged: (String phone) {
                setState(() {
                  phoneNumber = phone;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: passwordController,
              hintText: "Password",
              isPasswordField: true,
              obscureText: isPasswordHidden,
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
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: confirmpasswordController,
              hintText: "Confirm Password",
              isPasswordField: true,
              obscureText: isConfirmPasswordHidden,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Enter the confirm password';
                return null;
              },
              suffixIcon: GestureDetector(
                onTap: toggleConfirmPasswordVisibility, // Fixed: was using togglePasswordVisibility
                child: Image(
                  image: AssetImage(isConfirmPasswordHidden
                      ? "assets/notvisible_eye.png"
                      : "assets/visible_eye.png"),
                  height: 20.h,
                  width: 20.w,
                  color: isConfirmPasswordHidden ? null : const Color(0XFF8CC13F),
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: professionController,
              hintText: "Professional Title",
              validator: (val){
                if (val!.isEmpty) return 'Enter the professional title';
                return null;
              },
            ),
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: addressController,
              hintText: "Address",
              validator: (val){
                if (val!.isEmpty) return 'Enter the address';
                return null;
              },
            ),
          ),

          SizedBox(height: 20.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: bioController,
              hintText: "Bio",
              validator: (val){
                if (val!.isEmpty) return 'Enter the Bio';
                return null;
              },
            ),
          ),

          SizedBox(height: 20.h),
          // File upload - assuming it's required based on the error handling
          _buildRequiredFieldWithAsterisk(
            child: FileChoosenWidget(
              onFileSelected: (filePath) {
                setState(() {
                  selectedFilePath = filePath;
                  fileError = null;
                });
              },
              errorText: fileError,
            ),
          ),
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
        onPressed: ischeaked && !isLoading ? _registerInstructor : null,
        child: isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
            : Text("Sign Up",
            style: TextStyle(
                color: Colors.white,
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
    confirmpasswordController.dispose();
    super.dispose();
  }
}
