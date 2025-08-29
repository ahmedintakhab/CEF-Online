import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/api_constants.dart';
import '../cart/privacy_and_terms_policy.dart';
import '../widget/button.dart';
import 'checkout_webview_screen.dart';

class BillingSummary extends StatefulWidget {
  final Map<String, dynamic> billingSummaryData;
  final int paymentId;
  final int paymentType;
  final String? selectedPaymentMethodId;

  const BillingSummary({
    Key? key,
    required this.billingSummaryData,
    required this.paymentId,
    required this.paymentType,
    this.selectedPaymentMethodId,
  }) : super(key: key);

  @override
  State<BillingSummary> createState() => _BillingSummaryState();
}

class _BillingSummaryState extends State<BillingSummary> {
  bool isChecked = false;
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    print('Check id: ${widget.paymentId}');
    print('Check Type: ${widget.paymentType}');
    print('Check method: ${widget.selectedPaymentMethodId}');

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
          _buildSummaryRow(
            title: "Subtotal",
            value: "Rs ${subtotal.toStringAsFixed(2)}",
            isBold: false,
          ),
          SizedBox(height: 16.h),
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
          _buildSummaryRow(
            title: "Grand Total",
            value: "Rs ${grandTotal.toStringAsFixed(2)}",
            isBold: true,
          ),
          SizedBox(height: 16.h),
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
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyAndTermsPolicyScreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (errorMessage != null) ...[
            SizedBox(height: 16.h),
            Text(
              errorMessage!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
                fontFamily: 'Gilroy',
              ),
            ),
          ],
          SizedBox(height: 24.h),
          Stack(
            alignment: Alignment.center,
            children: [
              CustomButton(
                onTap: isLoading
                    ? () {} // Empty callback to disable button
                    : () {
                  // Wrap async function in synchronous callback
                  if (!isChecked) {
                    setState(() {
                      errorMessage = "Please accept the Privacy & Terms Policy";
                    });
                    return;
                  }
                  if (widget.selectedPaymentMethodId == null) {
                    setState(() {
                      errorMessage = "Please select a payment method";
                    });
                    return;
                  }
                  _generateSecureCheckoutUrl(context); // Call async function
                },
                buttonText: "PAY", // Always show "PAY" text
                buttonColor: isLoading ? Colors.grey : const Color(0xFF78A03F), // Grey out when loading
              ),
              if (isLoading)
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.w,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generateSecureCheckoutUrl(BuildContext context) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}student/generate-secure-checkout-url'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'payment_id': widget.paymentId,
          'payment_type': widget.paymentType,
          'payment_method': widget.selectedPaymentMethodId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String? secureCheckoutUrl = data['secure_checkout_url'];
        final String? expiresAt = data['expires_at'];

        if (secureCheckoutUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutWebviewScreen(url: secureCheckoutUrl),
            ),
          );
        } else {
          setState(() {
            errorMessage = 'Secure checkout URL not found in response';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to generate checkout URL: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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