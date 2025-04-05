import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/cart/billing_address.dart';
import 'package:learn_megnagmet/widget/button.dart';

class PendingPayment extends StatelessWidget {
  const PendingPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize screen util for responsiveness
    ScreenUtil.init(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),  // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pending Payment',
                style: TextStyle(
                  fontSize: 20.sp,  // Responsive font size
                  fontWeight: FontWeight.bold,
                    color: Color(0XFF78A03F)
                ),
              ),
              SizedBox(height: 20.h),  // Responsive height
              Card(
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
                      _buildInfoRow('Name', 'MN Nouman'),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow(
                        'Course',
                        'Tajweed ul Quran the easy way (English)',
                        maxLines: 2,  // Limit to 2 lines
                      ),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow('Amount', 'Rs 12000.00', valueColor: Colors.blue),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow('Issue Date', '02-11-2024'),
                      SizedBox(height: 12.h),  // Responsive height
                      _buildInfoRow('Issue Month', 'Nov'),
                      SizedBox(height: 24.h),  // Responsive height
                      CustomButton(onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>BillingAddress()));
                      }, buttonText: 'CHECKOUT')
                    ],
                  ),
                ),
              ),
            ],
          ),
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