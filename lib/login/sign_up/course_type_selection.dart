import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/widget/button.dart';

class CourseSelectionScreen extends StatefulWidget {
  final Function(int courseTypeId) onNext;

  const CourseSelectionScreen({required this.onNext, super.key});

  @override
  _CourseSelectionScreenState createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  String? _selectedCourse;
  String? _errorText;

  void _nextStep() {
    if (_selectedCourse == null) {
      setState(() {
        _errorText = 'Please select the course type';
      });
    } else {
      setState(() {
        _errorText = null;
      });

      int courseTypeId = _selectedCourse == 'Live' ? 1 : 2;
      widget.onNext(courseTypeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Select Course Type',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'Live',
                    groupValue: _selectedCourse,
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value;
                        _errorText = null;
                      });
                    },
                  ),
                  Text('Live', style: TextStyle(fontSize: 16.sp)),
                  const SizedBox(width: 20.0),
                  Radio<String>(
                    value: 'Self Learning',
                    groupValue: _selectedCourse,
                    onChanged: (value) {
                      setState(() {
                        _selectedCourse = value;
                        _errorText = null;
                      });
                    },
                  ),
                  Text('Self Learning', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
              if (_errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorText!,
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(height: 45.h,
              child: CustomButton(onTap: _nextStep, buttonText: 'NEXT')),
        ),
        // SizedBox(height: 10.0),
      ],
    );
  }
}
