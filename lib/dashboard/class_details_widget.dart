import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../utils/api_constants.dart'; // Import your ApiConstants

class ClassDetailsWidget extends StatefulWidget {
  @override
  _ClassDetailsWidgetState createState() => _ClassDetailsWidgetState();
}

class _ClassDetailsWidgetState extends State<ClassDetailsWidget> {
  bool isLoading = true;
  String errorMessage = '';
  dynamic classData; // Assuming single object or first item from array

  @override
  void initState() {
    super.initState();
    fetchTodayClass();
  }

  Future<void> fetchTodayClass() async {
    print("🔄 Fetching Today's Live Class API...");
    final url = "${ApiConstants.baseUrl}student/TodayLiveClass";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Today's Live Class API response code: ${response.statusCode}");
        setState(() {
          classData = data is List ? data.isNotEmpty ? data[0] : null : data;
          isLoading = false;
        });
      } else {
        print("❌ Today's Live Class API Error: ${response.statusCode}");
        setState(() {
          errorMessage = "Failed to load data (Code: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Exception in Today's Live Class API: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Class',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
          if (isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Color(0xFF8CC13F)),
              ),
            )
          else if (classData == null)
              Center(
                child: Text(
                  'No class for today',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                    fontFamily: 'Gilroy',
                  ),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 10.h),
                  Center(
                    child: Icon(
                      Icons.laptop,
                      size: 128.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  // SizedBox(height: 10.h),

                  Text(
                    classData['courseName'] ?? 'No Course',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: Text(
                      classData['Date_Time'] ?? 'No Date',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: Container(
                      width: 120.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: classData['Btn_Status'] == 'Pending'
                            ? Colors.yellow
                            : classData['Btn_Status'] == 'Missed'
                            ? Colors.red[400]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          classData['Btn_Status'] ?? 'Upcoming',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: classData['Btn_Status'] == 'Missed'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}