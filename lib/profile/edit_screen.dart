import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:learn_megnagmet/models/new_user_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/controller.dart';
import '../utils/screen_size.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key, required User user}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  EditScreenController editScreenController = Get.put(EditScreenController());
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  String? avatarUrl; // To store the avatar URL


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('user_name') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    phoneController.text = prefs.getString('phone_number') ?? '';
    avatarUrl = prefs.getString('avatar'); // Load avatar URL
    setState(() {}); // To refresh the UI with loaded data
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
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      SizedBox(width: 16.w),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 24.sp,
                            fontFamily: 'Gilroy'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView(
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 50.h,
                          backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                              ? NetworkImage(avatarUrl!)
                              : const AssetImage("assets/person.png") as ImageProvider,
                        ),
                        SizedBox(height: 30.h),
                        // Name Field
                        name_email_phone("assets/profileicon1st.png",
                            nameController, "Enter your name"),
                        SizedBox(height: 20.h),
                        // Email Field
                        name_email_phone("assets/profileicon2nd.png",
                            emailController, "Enter your email"),
                        SizedBox(height: 20.h),
                        // Phone Field
                        name_email_phone("assets/profileicon3rd.png",
                            phoneController, "Enter your phone number"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: save_button(),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  // Updated Function with Controller
  Widget name_email_phone(String icon, TextEditingController controller, String hint) {
    return Container(
      height: 60.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.h),
          boxShadow: [
            BoxShadow(
                color: const Color(0XFF23408F).withOpacity(0.14),
                offset: const Offset(-4, 5),
                blurRadius: 16),
          ],
          color: Colors.white),
      child: Padding(
        padding: EdgeInsets.all(8.0.h),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              contentPadding:
              EdgeInsets.only(left: 18.w, top: 18.h, bottom: 18.h),
              prefixIcon: Padding(
                padding: EdgeInsets.all(7.0.h),
                child: Container(
                  height: 24.h,
                  width: 24.h,
                  child: Image(
                    image: AssetImage(icon),
                    color: Color(0XFF8CC13F),
                  ),
                ),
              ),
              border: InputBorder.none,
              hintText: hint),
          style: TextStyle(
              fontSize: 15.sp,
              color: Color(0XFF6E758A),
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // Save Button
  Widget save_button() {
    return GestureDetector(
      onTap: () {
        // Implement save functionality here
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h, top: 15.h),
        child: Container(
          height: 56.h,
          width: 374.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.h),
            color: const Color(0XFF78A03F),
          ),
          child: Center(
            child: Text("Save",
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
}
