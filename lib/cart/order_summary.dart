import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummary extends StatelessWidget {
  final int itemCount;
  final double totalAmount;
  final double platformCharge;

  const OrderSummary({
    Key? key,
    required this.itemCount,
    required this.totalAmount,
    this.platformCharge = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Color(0XFF000000),
            ),
          ),
          SizedBox(height: 16.h),

          // Items count and price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Items ($itemCount) :",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16.sp,
                  color: Color(0XFF000000),
                ),
              ),
              Text(
                "Rs ${totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF000000),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Platform charge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Platform Charge (0%):",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16.sp,
                  color: Color(0XFF000000),
                ),
              ),
              Text(
                "Rs ${platformCharge.toStringAsFixed(0)}",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0XFF000000),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),
          // Platform info
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.grey,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "This is for using the platform and get support lifetime",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          Divider(height: 32.h, thickness: 1.h),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF000000),
                ),
              ),
              Text(
                "Rs ${totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF000000),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Agreement checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Color(0xFF78A03F),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "By placing your order, you agree with our company privacy policy and conditions of use.",
                  style: TextStyle(
                    fontFamily: 'Gilroy',
                    fontSize: 14.sp,
                    color: Color(0XFF000000),
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