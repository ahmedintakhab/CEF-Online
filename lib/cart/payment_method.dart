import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? _selectedPaymentMethod;
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash_on_delivery',
      'title': 'Cash On Delivery',
      'description': '',
    },
    {
      'id': 'faysal_bank',
      'title': 'Faysal Bank',
      'description': 'You will be redirected to the Faysal Bank platform after submitting your order',
    },
    {
      'id': 'meezan_bank',
      'title': 'Meezan Bank',
      'description': 'You will be redirected to the Meezan Bank platform after submitting your order',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            "Payment Method",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Gilroy',
              color: const Color(0XFF78A03F),
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(
            _paymentMethods.length,
                (index) => _buildPaymentOption(_paymentMethods[index]),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0XFF78A03F),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  "We protect your payment information using encryption to provide bank-level security",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Gilroy',
                    color: const Color(0xFF444444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(Map<String, dynamic> paymentMethod) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFDEDEDE),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: RadioListTile<String>(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: Text(
          paymentMethod['title'],
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Gilroy',
            color: const Color(0xFF000080),
            // color: const Color(0xFF78A03F),
          ),
        ),
        subtitle: paymentMethod['description'].isNotEmpty
            ? Text(
          paymentMethod['description'],
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Gilroy',
            color: const Color(0xFF666666),
          ),
        )
            : null,
        value: paymentMethod['id'],
        groupValue: _selectedPaymentMethod,
        activeColor: const Color(0xFF78A03F),
        onChanged: (String? value) {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
      ),
    );
  }
}