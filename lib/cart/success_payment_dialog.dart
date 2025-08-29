import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessPaymentDialog extends StatelessWidget {
  final VoidCallback onOkPressed;

  const SuccessPaymentDialog({Key? key, required this.onOkPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none, // Allow the icon to extend outside the container
        alignment: Alignment.center,
        children: [
          // Main dialog content
          Container(
            padding: EdgeInsets.only(top: 50.h, left: 24.w, right: 24.w, bottom: 24.h), // Extra top padding for icon
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Thank You!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontFamily: 'Gilroy',
                  ),
                ),
                SizedBox(height: 12.h),
                // Message
                Text(
                  'Your payment has been successfully\nprocessed. Thanks!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontFamily: 'Gilroy',
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24.h),
                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onOkPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF78A03F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Gilroy',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Success Icon positioned at the top edge
          Positioned(
            top: -50.h, // Position the icon 50 units above the container
            child: CircleAvatar(
              radius: 35.r,
              backgroundColor: const Color(0xFF8CC13F),
              child: Icon(
                Icons.check,
                size: 35.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}