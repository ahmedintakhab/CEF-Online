import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_megnagmet/cart/custom_dropdown.dart';
import 'package:learn_megnagmet/models/new_user_detail.dart';
import 'package:learn_megnagmet/widget/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../controller/controller.dart';
import '../utils/screen_size.dart';
import '../widget/custom_text_form_field.dart';

class InstructorEditScreen extends StatefulWidget {
  const InstructorEditScreen({Key? key, required User user}) : super(key: key);

  @override
  State<InstructorEditScreen> createState() => _InstructorEditScreenState();
}

class _InstructorEditScreenState extends State<InstructorEditScreen> {
  EditScreenController editScreenController = Get.put(EditScreenController());
  late TextEditingController firstnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController lastNameController;
  late TextEditingController professionalTitleController;
  late TextEditingController avatarUrlController;
  late TextEditingController phoneNumberController;
  late TextEditingController bioController;
  late TextEditingController skillsController;
  String? avatarUrl;
  File? _selectedImage;
  String? _selectedGender;
  final List<String> _gender = ['Male', 'Female', 'Others'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    firstnameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    lastNameController = TextEditingController();
    professionalTitleController = TextEditingController();
    avatarUrlController = TextEditingController();
    phoneNumberController = TextEditingController();
    bioController = TextEditingController();
    skillsController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firstnameController.text = prefs.getString('first_name') ?? '';
    lastNameController.text = prefs.getString('last_name') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    phoneNumberController.text = prefs.getString('phone_number') ?? '';
    professionalTitleController.text = prefs.getString('professional_title') ?? '';
    bioController.text = prefs.getString('about_me') ?? '';
    skillsController.text = prefs.getString('skills') ?? '';
    avatarUrl = prefs.getString('avatar');
    setState(() {});
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatar', image.path);
      }
    } catch (e) {
      print("Error picking image: $e");
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // _buildLabel("Select Your Picture", true),
                  SizedBox(height: 10.h),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50.h,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (avatarUrl != null && avatarUrl!.isNotEmpty
                              ? NetworkImage(avatarUrl!)
                              : const AssetImage("assets/person.png")) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 17.h,
                              backgroundColor: Color(0XFF78A03F),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Center(
                    child: Text(
                      "Accepted image files: .JPEG, .JPG, .PNG\nAccepted Size: 300 x 300 (1MB)",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'Gilroy',
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("First Name", true),
                            SizedBox(height: 10.h),
                            customTextFormField(
                              controller: firstnameController,
                              hintText: "First Name",
                              validator: (value) => value!.isEmpty ? "Enter your name" : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          children: [
                            _buildLabel("Last Name", true),
                            SizedBox(height: 10.h),
                            customTextFormField(
                              controller: lastNameController,
                              hintText: "Last Name",
                              validator: (value) => value!.isEmpty ? "Enter your last name" : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Email", true),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: emailController,
                    hintText: "Email",
                    validator: (value) => value!.isEmpty ? "Enter your email" : null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Professional Title", false),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: professionalTitleController,
                    hintText: "Title",
                    validator: (value) => null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Phone Number", true),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: phoneNumberController,
                    hintText: "3035454888",
                    validator: (value) => value!.isEmpty ? "Enter your phone number" : null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Bio", false),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: bioController,
                    hintText: "Bio",
                    validator: (value) => null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Gender", false),
                  SizedBox(height: 10.h),
                  CustomDropdown(
                    hint: 'Select Gender',
                    value: _selectedGender,
                    items: _gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Social Links", false),
                  _buildLabel("Facebook", false),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: TextEditingController(),
                    hintText: "https://facebook.com",
                    validator: (value) => null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Linkedin", false),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: TextEditingController(),
                    hintText: "https://linkedin.com",
                    validator: (value) => null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Twitter", false),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: TextEditingController(),
                    hintText: "https://twitter.com",
                    validator: (value) => null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Pinterest", false),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: TextEditingController(),
                    hintText: "https://pinterest.com",
                    validator: (value) => null,
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel("Skills", false),
                  SizedBox(height: 10.h),
                  customTextFormField(
                    controller: skillsController,
                    hintText: "",
                    validator: (value) => null,
                  ),
                  SizedBox(height: 40.h),
                  CustomButton(onTap: () {}, buttonText: 'Update Profile'),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildLabel(String label, bool isRequired) {
  return Row(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Gilroy',
          color: const Color(0xFF000080),
        ),
      ),
      if (isRequired)
        Text(
          " *",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
            color: Colors.red,
          ),
        ),
    ],
  );
}