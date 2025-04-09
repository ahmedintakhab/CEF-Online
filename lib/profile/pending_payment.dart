import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/cart/billing_address.dart';
import 'package:learn_megnagmet/widget/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/api_constants.dart';

class PendingPayment extends StatefulWidget {
  const PendingPayment({Key? key}) : super(key: key);

  @override
  State<PendingPayment> createState() => _PendingPaymentState();
}

class _PendingPaymentState extends State<PendingPayment> {
  List<dynamic> pendingPayments = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPendingPayments();
  }


  Future<void> _fetchPendingPayments() async {
    try {
      final url = Uri.parse("${ApiConstants.baseUrl}student/pending-payments");

      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      // Make the API request
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Successful API call
        print(" Pending Payment API Response: ${response.statusCode}");
        // print(" Pending Payment API data: ${response.body}");
        setState(() {
          pendingPayments = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // Handle API error
        print("API Error: ${response.statusCode} - ${response.body}");
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load pending payments. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Handle network errors
      print("Exception: $e");
      setState(() {
        isLoading = false;
        errorMessage = 'Network error occurred. Please try again.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // Initialize screen util for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(16.w), // Responsive padding
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Payment',
                        style: TextStyle(
                            fontSize: 20.sp, // Responsive font size
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF78A03F)
                        ),
                      ),
                      SizedBox(height: 20.h), // Responsive height
                      if(isLoading)
                        Center(child: CircularProgressIndicator(
                          color: Color(0XFF8CC13F),))
                      else
                        if(errorMessage.isNotEmpty)

                          Center(child: Text(errorMessage, style: TextStyle(
                              fontSize: 16.sp, color: Colors.red),),)
                        else
                          if (pendingPayments.isEmpty)
                            Center(
                              child: Text(
                                'No pending payments found',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            )
                          else
                            ...pendingPayments.map((payment) =>
                                _buildPaymentCard(payment)).toList(),
                    ]
                )
            )
        )
    );
  }
  Widget _buildPaymentCard(Map<String, dynamic> payment) {

           return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),  // Responsive radius
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),  // Responsive padding
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID: 1',
                            style: TextStyle(
                              fontSize: 16.sp,  // Responsive font size
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,  // Responsive padding
                              vertical: 6.h,     // Responsive padding
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),  // Responsive radius
                              border: Border.all(color: Color(0XFF8CC13F)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.access_time, color: Color(0XFF8CC13F), size: 16.w),  // Responsive icon size
                                SizedBox(width: 4.w),  // Responsive width
                                Text(
                                  'Pending Payment',
                                  style: TextStyle(
                                    color: Color(0XFF8CC13F),
                                    fontSize: 12.sp,  // Responsive font size
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),  // Responsive height
                      _buildInfoRow('Name', payment['payment_user_name']?.toString() ?? 'N/A'),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow(
                        'Course', payment['payment_course_name']?.toString() ?? 'N/A',
                        maxLines: 2,  // Limit to 2 lines
                      ),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow('Amount',payment['payment_amount']?.toString() ?? 'N/A',
                           valueColor: Colors.blue),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow('Issue Date',payment['issue_date']?.toString() ?? 'N/A'),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow('Issue Month',payment['issue_month']?.toString() ?? 'N/A'),
                      SizedBox(height: 24.h),  // Responsive height
                      CustomButton(onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>BillingAddress()));
                      }, buttonText: 'CHECKOUT')
                    ],
                  ),
                ),
              );
            }

  Widget _buildInfoRow(String label, String value, {Color? valueColor, int? maxLines}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,  // Responsive font size
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 8.w),  // Responsive width
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: maxLines ?? 1,  // Use provided maxLines or default to 1
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.sp,  // Responsive font size
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}