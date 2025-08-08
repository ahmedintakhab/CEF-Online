import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/login/login_empty_state.dart';
import 'package:learn_megnagmet/login/sign_up/phone_number_field.dart';
import 'package:learn_megnagmet/widget/button.dart';
import 'package:learn_megnagmet/widget/custom_text_form_field.dart';
import '../../cart/custom_dropdown.dart';
import '../../utils/api_constants.dart';
import '../../utils/screen_size.dart';
import 'countries_dropdown.dart';

class StudentSignupScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onNext;
  final VoidCallback onBack;
  final int courseTypeId;
  final String courseName;
  final int courseId;

  const StudentSignupScreen({
    Key? key,
    required this.onNext,
    required this.onBack,
    required this.courseTypeId,
    required this.courseName,
    required this.courseId,
  }) : super(key: key);

  @override
  State<StudentSignupScreen> createState() => _StudentSignupScreenState();
}

class _StudentSignupScreenState extends State<StudentSignupScreen> {

  bool ischeaked = false;
  bool ispassHiden = true;
  bool ispassHiden1 = true;
  String passworderror = '';

  final formkey = GlobalKey<FormState>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController parentController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController studentsController = TextEditingController();
  TextEditingController trialDateController = TextEditingController();
  TextEditingController trialTimeController = TextEditingController();



  String phoneNumber = "";
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;
  int? selectedCountryId; // To store the selected country ID
  String? _selectedGender;
  final List<String> _gender = ['Male', 'Female', 'Either'];
  List<Map<String, dynamic>> timeSlots = [];
  bool isDateSelected = false;
  int? selectedSlotId; // To store the selected slot_id


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
  @override
  void initState() {
    super.initState();
    // Set initial trial date to today if needed
    // final today = DateTime.now();
    // trialDateController.text = "${today.day}/${today.month}/${today.year}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: today, // Disable past dates
      lastDate: DateTime(2035), // Set a reasonable future limit
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(today.subtract(Duration(days: 1))); // Enable today and future
      },
    );
    if (picked != null) {
      setState(() {
        trialDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-"
            "${picked.day.toString().padLeft(2, '0')}";
        isDateSelected = true;
        _fetchTimeSlots(picked);
      });
    }
  }

  Future<void> _fetchTimeSlots(DateTime selectedDate) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}frontend/get-time-slots'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          timeSlots = jsonResponse.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch time slots: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching time slots: $e');
    }
  }

  void _selectTimeSlot(int slotId, String slotTime) {
    setState(() {
      selectedSlotId = slotId;
      trialTimeController.text = slotTime;
    });
  }

  void _submitForm() {
    if (formkey.currentState!.validate()) {
      if (passwordController.text != confirmpasswordController.text) {
        setState(() {
          passworderror = 'Passwords do not match';
        });
        return;
      }
      if (selectedSlotId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a time slot')),
        );
        return;
      }
      final formData = {
        'fullname': fullnameController.text,
        'phone': phoneNumber,
        'email': emailController.text,
        'city': cityController.text,
        'country': selectedCountryId?.toString(),
        'age': ageController.text,
        'school_grade': schoolController.text,
        'parent_name': parentController.text,
        'password': passwordController.text,
        'gender': _selectedGender,
        'how_many_students': studentsController.text,
        'preferDate': trialDateController.text,
        'preferSlot': selectedSlotId.toString(),
      };
      widget.onNext(formData);
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
                    // term_condition_cheakbox(),
                    // SizedBox(height: 25.h),
                    // sign_up_button(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: CustomButton(onTap: widget.onBack, buttonText: 'BACK')),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: CustomButton(
                        onTap: _submitForm,
                        buttonText: 'NEXT',
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(bottom: 20.h),
              //   child: already_login_button(),
              // ),
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
          customTextFormField(controller: fullnameController, hintText: "Full Name",
              validator: (val) {
                     if (val!.isEmpty) return 'Enter the Full Name';
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
                return 'Please enter whatsapp number';
              }
              return null;
            },
          ),
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
          customTextFormField(controller:cityController, hintText: "City",
              validator: (val){
                   if (val!.isEmpty) return 'Enter the City';
                   return null;
                 },),

          SizedBox(height: 20.h),
          CountriesDropdown(
            controller: countryController,
            hintText: "Select Country",
            validator: (val) {
              // if (val == null || val.isEmpty) return 'Please select a country';
              // return null;
            },
            onCountryIdChanged: (int? countryId) {
              setState(() {
                selectedCountryId = countryId; // Store the selected country ID
                print('Selected Country ID: $selectedCountryId'); // For debugging
              });
            },
          ),
          SizedBox(height: 20.h),
          customTextFormField(controller:ageController, hintText: "Age",
            validator: (val){
              if (val!.isEmpty) return 'Enter the Age';
              return null;
            },),
          SizedBox(height: 20.h),
          customTextFormField(controller:schoolController, hintText: "School Grade",
            validator: (val){
              // if (val!.isEmpty) return 'Enter the school grade';
              // return null;
            },),
          SizedBox(height: 20.h),
          customTextFormField(controller:parentController, hintText: "Parent's Name",
            validator: (val){
              // if (val!.isEmpty) return 'Enter the parent name';
              // return null;
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
        customTextFormField(
          controller: confirmpasswordController,
          hintText: "Confirm Password",
          isPasswordField: true,
          obscureText: isConfirmPasswordHidden, // Dynamically updating with state
          validator: (val) {
            if (val == null || val.isEmpty) return 'Enter the confirm password';
            return null;
          },
          suffixIcon: GestureDetector(
            onTap: toggleConfirmPasswordVisibility,
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
          SizedBox(height: 20.h),
          CustomDropdown(
            hint: "Gender",
            value: _selectedGender,
            items: _gender,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
          ),
        SizedBox(height: 20.h),
          customTextFormField(controller: studentsController, hintText: "Number of Students Join",
            validator: (val) {},),
          SizedBox(height: 20.h),
          Text(
            "Pick a date and time for 1 hour free trial lesson",
            style: TextStyle(fontSize: 16.sp, fontFamily: 'Gilroy'),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: customTextFormField(
                controller: trialDateController,
                hintText: "Select Date and Time",
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please select a trial date';
                  return null;
                },
                suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF8CC13F)),              ),
            ),
          ),
          if (isDateSelected) ...[
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.wb_sunny, color: Colors.orange, size: 20.sp),
                SizedBox(width: 5.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Time Slots",
                      style: TextStyle(fontSize: 16.sp, fontFamily: 'Gilroy', color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5.h), // Space between lines
                    Text(
                      "Select your preferred time",
                      style: TextStyle(fontSize: 16.sp, fontFamily: 'Gilroy'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (timeSlots.length / 4).ceil(),
              itemBuilder: (context, index) {
                final start = index * 4;
                final end = start + 4;
                final rowSlots = timeSlots.sublist(start, end > timeSlots.length ? timeSlots.length : end);
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: rowSlots.map((slot) {
                      final isSelected = selectedSlotId == slot['slot_id'];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTimeSlot(slot['slot_id'], slot['slot_time']),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              slot['slot_time'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ],

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
}