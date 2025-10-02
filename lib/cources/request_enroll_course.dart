import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/home/home_main.dart';
import 'package:learn_megnagmet/widget/button.dart';
import 'package:learn_megnagmet/widget/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/api_constants.dart';
import '../../utils/cache_api_service.dart';
import '../../utils/screen_size.dart';
import '../home/home_screen.dart';
import '../login/sign_up/phone_number_field.dart';
import '../utils/custom_cache_manager.dart';

class RequestEnrollCourse extends StatefulWidget {
  final String courseId;

  const RequestEnrollCourse({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<RequestEnrollCourse> createState() => _RequestEnrollCourseState();
}

class _RequestEnrollCourseState extends State<RequestEnrollCourse> {
  bool ischeaked = false;
  bool isLoading = true;
  bool isSubmitting = false;

  final formkey = GlobalKey<FormState>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController learningGoalController = TextEditingController();
  TextEditingController trialDateController = TextEditingController();
  TextEditingController trialTimeController = TextEditingController();

  String phoneNumber = "";
  List<Map<String, dynamic>> timeSlots = [];
  bool isDateSelected = false;
  int? selectedSlotId;

  @override
  void initState() {
    super.initState();
    _fetchEnrollmentData();
  }

  Future<void> _fetchEnrollmentData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final url = '${ApiConstants.baseUrl}student/get_edit_enrollment_form_data/${widget.courseId}';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';
      final response = await http.get(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 200 && jsonResponse['data'] != null) {
          final data = jsonResponse['data'];

          setState(() {
            // Set form fields
            fullnameController.text = data['full_name'] ?? '';
            phoneNumber = data['whatsapp_number'] ?? '';
            ageController.text = data['age']?.toString() ?? '';
            learningGoalController.text = data['learning_goals'] ?? '';

            // Set available time slots
            if (data['availableSlots'] != null) {
              timeSlots = List<Map<String, dynamic>>.from(
                  data['availableSlots'].map((slot) => {
                    'slot_id': slot['slot_id'],
                    'slot_time': slot['slot_time'],
                  })
              );
            }

            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching enrollment data: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: today,
      lastDate: DateTime(2035),
      selectableDayPredicate: (DateTime date) {
        return date.isAfter(today.subtract(Duration(days: 1)));
      },
    );
    if (picked != null) {
      setState(() {
        trialDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-"
            "${picked.day.toString().padLeft(2, '0')}";
        isDateSelected = true;
      });
    }
  }

  void _selectTimeSlot(int slotId, String slotTime) {
    setState(() {
      selectedSlotId = slotId;
      trialTimeController.text = slotTime;
    });
  }

  Future<void> _submitForm() async {
    if (formkey.currentState!.validate()) {
      if (selectedSlotId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a time slot'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() {
        isSubmitting = true; // Show loading indicator on button
      });
      try {
        // Get token from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('auth_token') ?? '';

        final url = Uri.parse("${ApiConstants.baseUrl}student/submit_course_request");

        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'course_id': widget.courseId,
            'fullname': fullnameController.text,
            'phone': phoneNumber,
            'age': ageController.text,
            'learning_goals': learningGoalController.text,
            'preferDate': trialDateController.text,
            'preferSlot': selectedSlotId.toString(),
          },
        );
        setState(() {
          isSubmitting = false; // Hide loading indicator
        });
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
            // Success
            print('Enroll live course api response:${response.statusCode}');
            print('Enroll live course api response:${response.body}');
          Get.snackbar('Success', 'Enrollment request sent to admin!', snackPosition: SnackPosition.TOP);
          CustomCacheManager.instance.emptyCache();
          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeMainScreen()),
          );
          } else {
            print('Failed to submit request:${response.statusCode}');
            print('Enroll live course api response:${response.body}');

        }

      } catch (e) {
        setState(() {
          isSubmitting = false; // Hide loading indicator
        });

        print('Error submitting form: $e');
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
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Color(0xFF8CC13F),
          ),
        )
            : Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        back_button(),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Text(
                            'Live Course Enrollment Form',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    detailform(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              CustomButton(onTap: _submitForm,
                  isLoading: isSubmitting,
                  buttonText: "Submit Request"),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget detailform() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: fullnameController,
              hintText: "Full Name",
              validator: (val) {
                if (val!.isEmpty) return 'Enter the Full Name';
                return null;
              },
            ),
          ),
          SizedBox(height: 10.h),
          _buildRequiredFieldWithAsterisk(
            child: phone_number_field(
              // initialPhoneNumber: phoneNumber,
              onPhoneNumberChanged: (String phone) {
                setState(() {
                  phoneNumber = phone;
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter whatsapp number';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 10.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: ageController,
              hintText: "Age",
              validator: (val) {
                if (val!.isEmpty) return 'Enter your age';
                return null;
              },
            ),
          ),
          SizedBox(height: 10.h),
          _buildRequiredFieldWithAsterisk(
            child: customTextFormField(
              controller: learningGoalController,
              hintText: "Learning Goals",
              validator: (val) {
                if (val!.isEmpty) return 'Enter the learning goals';
                return null;
              },
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Pick a date and time for 1 hour free trial lesson",
            style: TextStyle(fontSize: 16.sp, fontFamily: 'Gilroy'),
          ),
          SizedBox(height: 10.h),
          _buildRequiredFieldWithAsterisk(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: customTextFormField(
                  controller: trialDateController,
                  hintText: "Select Date and Time",
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please select a trial date';
                    return null;
                  },
                  suffixIcon: Icon(Icons.calendar_today, color: Color(0xFF8CC13F)),
                ),
              ),
            ),
          ),
          if (isDateSelected && timeSlots.isNotEmpty) ...[
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
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Gilroy',
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5.h),
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
                final rowSlots = timeSlots.sublist(
                    start, end > timeSlots.length ? timeSlots.length : end);
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: rowSlots.map((slot) {
                      final isSelected = selectedSlotId == slot['slot_id'];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTimeSlot(
                              slot['slot_id'], slot['slot_time']),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 15.w),
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

  Widget back_button() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, true);
      },
      child: Image(
        image: const AssetImage("assets/back_arrow.png"),
        height: 24.h,
        width: 24.w,
      ),
    );
  }
}