// custom_text_form_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customTextFormField({
  required TextEditingController controller,
  required String hintText,
  required String? Function(String?) validator,
  bool isPasswordField = false,
  bool obscureText = false,
  Widget? suffixIcon,

}) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordField && obscureText, // Correctly apply obscureText
    cursorColor: const Color(0xFF78A03F),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15.sp,
        fontFamily: 'Gilroy',
        color: const Color(0XFF9B9B9B),
        fontWeight: FontWeight.bold,
      ),
      suffixIcon: suffixIcon, // Allow passing a custom suffix icon
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0XFF8CC13F), width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0XFFDEDEDE), width: 1.w),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
    ),
    validator: validator,
  );
}
