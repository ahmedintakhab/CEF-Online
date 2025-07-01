import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/home/home_screen.dart';
import 'package:learn_megnagmet/instructor/all_students.dart';
import 'package:learn_megnagmet/instructor/instructor_basic_information.dart';
import 'package:learn_megnagmet/instructor/instructor_classes_history.dart';
import 'package:learn_megnagmet/instructor/instructor_classes_schedule.dart';
import 'package:learn_megnagmet/instructor/instructor_courses.dart';
import 'package:learn_megnagmet/instructor/instructor_notice_board.dart';
import 'package:learn_megnagmet/instructor/live_class_screen.dart';
import 'package:learn_megnagmet/profile/profile_field_container.dart';
import 'package:learn_megnagmet/profile/rateus_dialogue_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_megnagmet/profile/edit_screen.dart';
import 'package:learn_megnagmet/utils/api_constants.dart';
import 'package:learn_megnagmet/utils/screen_size.dart';
import 'package:learn_megnagmet/utils/shared_pref.dart';

import '../controller/controller.dart';
import '../login/login_empty_state.dart';
import '../models/new_user_detail.dart';
import '../models/profile_option.dart';
import '../utils/slider_page_data_model.dart';
import '../widget/button.dart';
import 'instructor_address_and_location.dart';

class InstructorPanel extends StatefulWidget {
  const InstructorPanel({Key? key, required this.user_detail}) : super(key: key);
  final User user_detail;

  @override
  State<InstructorPanel> createState() => _InstructorPanelState();
}

class _InstructorPanelState extends State<InstructorPanel> {
  String userName = "User Name"; // Default placeholder
  String email = "Email"; // Default placeholder
  @override
  void initState() {
    super.initState();
    _loadUserData();
    StartClassFunction();

  }
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('user_name') ?? "User Name";
      email = prefs.getString('email') ?? "Email";
    });
  }
  Future<void> StartClassFunction() async {
    final String apiUrl = "${ApiConstants.baseUrl}instructor/checkLessonStartTime";

    try {
      // Assuming the token is saved in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token in the header
        },
      );

      if (response.statusCode == 200) {
        // Successfully logged out
        print("Check start lesson function api response: ${response.statusCode}");

      } else {
        print("Start lesson function api failed: ${response.body}");
      }
    } catch (e) {
      print("Start lesson function api error: $e");
    }
  }

  Future<void> logoutApiCall() async {
    final String apiUrl = "${ApiConstants.baseUrl}logoutApi";

    try {
      // Assuming the token is saved in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';
      print('Token check: $token');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include token in the header
        },
      );

      if (response.statusCode == 200) {
        // Successfully logged out
        print("Logout successful");
        // Clear user data from SharedPreferences
        prefs.clear(); // Optionally clear all saved data
      } else {
        print("Logout failed: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  MyProfileController myProfileController = Get.put(MyProfileController());
  List<ProfileOption> profileoption = Utils.getProfileOption();
  HomeMainController controller = Get.put(HomeMainController());

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: GetBuilder(
            init: MyProfileController(),
            builder: (MyProfileController) =>
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                },
                                child: Image(
                                  image: AssetImage("assets/back_arrow.png"),
                                  height: 24.h,
                                  width: 24.w,
                                )),
                            SizedBox(width: 15.w),
                            Text(
                              "My Profile",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 24.sp, fontFamily: 'Gilroy'),
                            ),
                            SizedBox(width: 40.w),
                            // SizedBox(width: 180.w, height: 35.h,
                            //     child: CustomButton(onTap: (){}, buttonText: 'Instructor Panel'))
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Image(
                        image: AssetImage(widget.user_detail.image!), height: 100.h,
                        width: 100.w,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        userName,
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w700,
                            color: const Color(0XFF000000)),
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditScreen(
                                        user: widget.user_detail,
                                      )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Edit Profile",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0XFF000000))),
                            Image(
                              image: AssetImage("assets/editsymbol.png"),
                              height: 16.h,
                              width: 16.w,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          primary: true,
                          shrinkWrap: false,
                          children: [
                            // My Certification
                            ProfileFieldContainer(
                              title: 'Home',
                              icon: Icon(Icons.home, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(HomeScreen());
                                // Get.to(MyCertification());
                              },
                            ),
                            // My Project
                            ProfileFieldContainer(
                              title: 'My Courses',
                              icon: Icon(Icons.book, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(InstructorCourses());
                              },
                            ),
                            // Saved Course
                            ProfileFieldContainer(
                              title: 'All Students',
                              icon: Icon(Icons.storefront, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(AllStudents());

                              },
                            ),
                            // Certificate Payment
                            ProfileFieldContainer(
                              title: 'Classes Schedule',
                              icon: Icon(Icons.calendar_month, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(InstructorClassesSchedule());
                                // Get.to(FeedBack());
                              },
                            ),
                            // Help Center
                            ProfileFieldContainer(
                              title: 'Classes History',
                              icon: Icon(Icons.history, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(InstructorClassesHistory());
                                // Get.to(PrivacyPolicy());
                              },
                            ),
                            // Privacy Policy
                            ProfileFieldContainer(
                              title: 'Notice Board',
                              icon: Icon(Icons.pending_actions, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(InstructorNoticeBoard());
                                // Get.to(CertificatePayment());

                                // Disabled as per original code
                              },
                            ),
                            ProfileFieldContainer(
                              title: 'Live Class',
                              icon: Icon(Icons.class_, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(LiveClassScreen());

                              },
                            ),
                            ProfileFieldContainer(
                              title: 'Discussion',
                              icon: Icon(Icons.message, color: Color(0XFF78A03F)),
                              onTap: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context)=>ChangePassword()));
                              },
                            ),
                            // Feedback
                            ProfileFieldContainer(
                              title: 'Basic Information',
                              icon: Icon(Icons.person, color: Color(0XFF78A03F)),
                              onTap: () {
                                Get.to(InstructorEditScreen(user: widget.user_detail));
                              },
                            ),
                            // Rate Us
                            ProfileFieldContainer(
                              title: 'Address & Location',
                              icon: Icon(Icons.location_on_outlined, color: Color(0XFF78A03F)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>InstructorAddressAndLocation()));
                              },
                            ),

                            SizedBox(height: 30.h),
                            Padding(
                              padding: EdgeInsets.only(bottom: 40.h, left: 20.h, right: 20.h),
                              child: GestureDetector(
                                onTap: () {
                                  showLogoutDialog();
                                },
                                child: Container(
                                  height: 56.h,
                                  width: 374.w,
                                  decoration: BoxDecoration(
                                    color: Color(0XFF78A03F),
                                    border: Border.all(
                                      color: const Color(0xFF78A03F),
                                      style: BorderStyle.solid,
                                      width: 1.0.w,
                                    ),
                                    borderRadius: BorderRadius.circular(20.h),
                                  ),
                                  child: Center(
                                    child: Text("Logout",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Gilroy')),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  void showRateUsDialog() {
    RateUsDialog.show(
      onSubmit: () {
        Get.back();
        controller.onChange(0);
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: '',
      content: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            Text(
              "Are you sure you want to Logout!",
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy'),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top: 25.h, bottom: 13.h),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Call logout API
                        await logoutApiCall();
                        PrefData.setLogin(false);
                        Get.off(EmptyState());
                      },
                      child: Container(
                        height: 56.h,
                        width: double.infinity.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.h),
                          color: const Color(0XFF78A03F),
                        ),
                        child: Center(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                color: Color(0XFFFFFFFF),
                                fontStyle: FontStyle.normal,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 56.h,
                        width: double.infinity.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF78A03F),
                            style: BorderStyle.solid,
                            width: 1.0.w,
                          ),
                          borderRadius: BorderRadius.circular(22.h),
                        ),
                        child: Center(
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF78A03F),
                                fontStyle: FontStyle.normal,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
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