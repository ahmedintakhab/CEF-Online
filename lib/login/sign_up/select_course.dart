import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/widget/button.dart';
import 'package:learn_megnagmet/login/sign_up/courses_dropdown.dart';

class SelectCourse extends StatefulWidget {
  final Function(int courseTypeId, String courseName, int courseId) onNext;
  final VoidCallback onBack;
  final int courseTypeId;

  const SelectCourse({
    required this.onNext,
    required this.onBack,
    required this.courseTypeId,
    super.key,
  });

  @override
  _SelectCourseState createState() => _SelectCourseState();
}

class _SelectCourseState extends State<SelectCourse> {
  final TextEditingController courseController = TextEditingController();
  String? _errorText;
  int? _selectedCourseId;
  String? _selectedCourseName;

  void _nextStep() {
    if (_selectedCourseId == null || _selectedCourseName == null) {
      setState(() {
        _errorText = 'Please select a course';
      });
    } else {
      setState(() {
        _errorText = null;
      });
      widget.onNext(widget.courseTypeId, _selectedCourseName!, _selectedCourseId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CoursesDropdown(
            controller: courseController,
            hintText: 'Select Course',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Please select a course';
              return null;
            },
            courseTypeId: widget.courseTypeId,
            onCourseSelected: (int courseId, String courseName) {
              setState(() {
                _selectedCourseId = courseId;
                _selectedCourseName = courseName;
                _errorText = null;
              });
            },
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Text(
              _errorText!,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomButton(onTap: widget.onBack, buttonText: 'BACK')),
              SizedBox(width: 30.w),
              Expanded(child: CustomButton(onTap: _nextStep, buttonText: 'NEXT')),
            ],
          ),
        ),
      ],
    );
  }
}