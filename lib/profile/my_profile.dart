import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/dashboard/billing_history_widget.dart';
import 'package:learn_megnagmet/dashboard/blog_widget.dart';
import 'package:learn_megnagmet/dashboard/class_details_widget.dart';
import 'package:learn_megnagmet/dashboard/enroll_courses_widget.dart';
import 'package:learn_megnagmet/dashboard/leaderboard_widget.dart';
import 'package:learn_megnagmet/dashboard/my_schedule%20widget.dart';
import 'package:learn_megnagmet/dashboard/overview_details_widget.dart';
import 'package:learn_megnagmet/dashboard/welcome_banner_widget.dart';
import 'package:learn_megnagmet/home/home_screen.dart';
import 'package:learn_megnagmet/instructor/view_live_class_details.dart';
import 'package:learn_megnagmet/profile/address_and_location.dart';
import 'package:learn_megnagmet/profile/change_password.dart';
import 'package:learn_megnagmet/profile/pending_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learn_megnagmet/profile/edit_screen.dart';
import 'package:learn_megnagmet/utils/api_constants.dart';
import 'package:learn_megnagmet/utils/screen_size.dart';
import 'package:learn_megnagmet/utils/shared_pref.dart';
import 'package:shimmer/shimmer.dart';

import '../My_cources/ongoing_completed_main_screen.dart';
import '../controller/controller.dart';
import '../home/home_main.dart';
import '../login/login_empty_state.dart';
import '../models/new_user_detail.dart';
import '../models/profile_option.dart';
import '../utils/slider_page_data_model.dart';
import 'classes_history_screen.dart';
import 'classes_schedule_screen.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key, required this.user_detail}) : super(key: key);
  final User user_detail;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = "User Name";
  String email = "Email";
  String userImage = "";
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString('user_name') ?? "User Name";
      email = prefs.getString('email') ?? "Email";
      userImage = prefs.getString('userImage') ?? '';
    });
  }

  Future<void> logoutApiCall() async {
    final String apiUrl = "${ApiConstants.baseUrl}logoutApi";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';
      print('Token check: $token');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Logout successful");
        Get.snackbar('Success', 'User Successfully Logout', snackPosition: SnackPosition.TOP);

        await prefs.remove('auth_token');
        await prefs.remove('user_name');
        await prefs.remove('email');
        await prefs.remove('role');
        await prefs.remove('phone_number');
        await prefs.remove('userImage');
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
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(),
        appBar: AppBar(
          leading: IconButton(onPressed:(){
            final HomeMainController controller = Get.find<HomeMainController>();
            controller.onChange(0);
            Get.offAll(() => const HomeMainScreen());
          } ,
              icon: Image.asset(
            "assets/back_arrow.png",
            height: 24.h,
            width: 24.w,
            fit: BoxFit.contain,)),
          title: Image.asset(
            "assets/cef_logo.png",
            height: 50.h,
            width: 150.w,
            fit: BoxFit.contain,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: ClipOval(
                  child: userImage.isNotEmpty
                      ? Image.network(
                    userImage,
                    height: 50.h,
                    width: 50.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF78A03F),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  )
                      : Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF78A03F),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
        body: GetBuilder(
          init: MyProfileController(),
          builder: (MyProfileController) => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  WelcomeBannerWidget(),
                  ClassDetailsWidget(),
                  OverviewDetailsWidget(),
                  MyScheduleWidget(),
                  EnrollCoursesWidget(),
                  BlogWidget(),
                  BillingHistoryWidget(),
                  Leaderboard()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: Color(0XFF78A03F),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: userImage.isNotEmpty
                        ? Image.network(
                      userImage,
                      height: 80.h,
                      width: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 80.h,
                          width: 80.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Color(0XFF78A03F),
                            size: 40,
                          ),
                        );
                      },
                    )
                        : Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Color(0XFF78A03F),
                        size: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(HomeScreen());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.book,
                  title: 'My Courses',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(OngoingCompletedScreen());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.storefront,
                  title: 'My Products',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.calendar_month,
                  title: 'Classes Schedule',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(ClassScheduleScreen());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.history,
                  title: 'Classes History',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(ClassHistoryScreen());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.pending_actions,
                  title: 'Pending Payment',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(PendingPayment());
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(EditScreen(user: widget.user_detail));
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.location_on_outlined,
                  title: 'Address & Location',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddressAndLocation()));
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                  },
                ),
                Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.pop(context);
                    showLogoutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Color(0XFF78A03F)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  void showLogoutDialog() {
    bool isLoggingOut = false;

    Get.defaultDialog(
      barrierDismissible: false,
      title: '',
      content: StatefulBuilder(
        builder: (context, setStateDialog) {
          return Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              children: [
                Text(
                  "Are you sure you want to Logout!",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gilroy',
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.h, bottom: 13.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: isLoggingOut
                              ? null
                              : () async {
                            setStateDialog(() => isLoggingOut = true);

                            try {
                              await logoutApiCall();
                              await PrefData.setLogin(false);

                              await Future.delayed(Duration(milliseconds: 300));

                              Get.offAll(() => const EmptyState());
                            } catch (e) {
                              print('Logout error: $e');
                              setStateDialog(() => isLoggingOut = false);
                            }
                          },
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.h),
                              color: const Color(0XFF78A03F),
                            ),
                            child: Center(
                              child: isLoggingOut
                                  ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                                  : Text(
                                "Yes",
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0XFFFFFFFF),
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: isLoggingOut ? null : () => Get.back(),
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF78A03F),
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
                                  fontSize: 18.sp,
                                ),
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
          );
        },
      ),
    );
  }
}