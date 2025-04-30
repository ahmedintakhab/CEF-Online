import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/cart/custom_dropdown.dart';
import 'package:learn_megnagmet/widget/button.dart';
import 'package:learn_megnagmet/widget/custom_text_form_field.dart';

class CreateLiveClass extends StatefulWidget {
  @override
  _CreateLiveClassState createState() => _CreateLiveClassState();
}

class _CreateLiveClassState extends State<CreateLiveClass> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedLearningTool;

  final List<String> _learningTools = [ 'Zoom', 'BigBlueButton'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Start from today
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _topicController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Live Class',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0XFF78A03F),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Class Topic
            Text(
              'Live Class Topic',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            customTextFormField(controller: _topicController,
                hintText: 'Enter your topic', validator: (val) {
                if (val == null || val.isEmpty) return 'Enter your topic';
                return null;
              }, ),
            SizedBox(height: 16.h),

            // Live Class Date
            Text(
              'Live Class Date',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            customTextFormField(
              controller: _dateController,
              hintText: 'Select date (yyyy-MM-dd)',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                color: Color(0XFF78A03F),
                onPressed: () => _selectDate(context),
              ),
              validator: (value) =>
              value?.isEmpty ?? true ? 'Please select date' : null,
            ),


            SizedBox(height: 16.h),

            // Time Duration
            Text(
              'Time Duration (Write minutes)',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            customTextFormField(controller:_durationController, hintText: "Type duration in minutes",
              validator: (val){
                if (val!.isEmpty) return 'Enter the duration';
                return null;
              },),

            SizedBox(height: 16.h),

            // Learning Tool
            Text(
              'Learning Tool',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            CustomDropdown(hint: 'Select Option', value: _selectedLearningTool,
              items: _learningTools, onChanged: (String? newValue) {
        setState(() {_selectedLearningTool = newValue;
      });
      },),

            SizedBox(height: 24.h),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    buttonText: 'Back',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      // Add functionality for creating the meeting
                    },
                    buttonText: 'Create Meeting',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}