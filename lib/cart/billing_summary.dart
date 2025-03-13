import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummary extends StatefulWidget {
  final Map<String, dynamic> billingSummaryData;

  const OrderSummary({Key? key, required this.billingSummaryData,
  }) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {


  // Checkbox state
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    // Extract billing summary data
    final subtotal = widget.billingSummaryData['subtotal'] ?? 0;
    final discount = widget.billingSummaryData['discount'] ?? 0;
    final platformCharge = widget.billingSummaryData['platform_charge'] ?? 0;
    final grandTotal = widget.billingSummaryData['grand_total'] ?? 0;
    final conversionRate = widget.billingSummaryData['conversion_rate'] ?? "1 PKR = ?";
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Billing Summary",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
              color: const Color(0xFF78A03F),
            ),
          ),
          SizedBox(height: 18.h),

          // Subtotal row
          _buildSummaryRow(
            title: "Subtotal",
            value: "Rs ${subtotal.toStringAsFixed(2)}",
            isBold: false,
          ),
          SizedBox(height: 16.h),

          // Discount row
          _buildSummaryRow(
            title: "Discount",
            value: "- Rs ${discount.toStringAsFixed(2)}",
            isBold: false,
          ),

          Divider(
            color: Colors.grey[300],
            thickness: 1.h,
            height: 32.h,
          ),

          // Grand Total row
          _buildSummaryRow(
            title: "Grand Total",
            value: "Rs ${grandTotal.toStringAsFixed(2)}",
            isBold: true,
          ),

          SizedBox(height: 16.h),

          // Conversion Rate row
          _buildSummaryRow(
            title: "Conversion Rate",
            value: "$conversionRate",
            isBold: false,
          ),

          Divider(
            color: Colors.grey[300],
            thickness: 1.h,
            height: 32.h,
          ),

          // Currency selection row
          Row(
            children: [
              Text(
                "In",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy',
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Terms and conditions checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF78A03F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Please check to acknowledge our ",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontFamily: 'Gilroy',
                        ),
                      ),
                      TextSpan(
                        text: "Privacy & Terms Policy",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF006080),
                          fontFamily: 'Gilroy',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        // You can add a gesture recognizer here for tapping on the policy link
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Pay button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Process payment
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF78A03F),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "PAY",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String title,
    required String value,
    required bool isBold,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'Gilroy',
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'Gilroy',
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}