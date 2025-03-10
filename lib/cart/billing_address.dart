import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/custom_text_form_field.dart';
import 'billing_summary.dart';
import 'order_review.dart';
import 'payment_method.dart';
import 'custom_dropdown.dart'; // Import the custom dropdown widget

class BillingAddress extends StatefulWidget {
  const BillingAddress({Key? key}) : super(key: key);

  @override
  State<BillingAddress> createState() => _BillingAddressState();
}

class _BillingAddressState extends State<BillingAddress> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  final List<String> _countries = ['USA', 'Canada', 'UK', 'Pakistan', 'India', 'Australia'];
  final List<String> _states = ['Select state'];
  final List<String> _cities = ['Select city'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                      color: Color(0XFF78A03F),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Order Review Section - Added new widget
                const OrderReview(),
                // Billing Address Form

                Container(
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
                        "Billing Address",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Gilroy',
                          color: const Color(0xFF78A03F),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("First Name", true),
                                SizedBox(height: 8.h),
                                customTextFormField(
                                  controller: _firstNameController,
                                  hintText: "First Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "First name is required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Last Name", true),
                                SizedBox(height: 8.h),
                                customTextFormField(
                                  controller: _lastNameController,
                                  hintText: "Last Name",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Last name is required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _buildLabel("Email Address", true),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _emailController,
                        hintText: "Email Address",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      _buildLabel("Address", true),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _addressController,
                        hintText: "Address",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Address is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      _buildLabel("Country", false),
                      SizedBox(height: 8.h),
                      CustomDropdown(
                        hint: "Select Country",
                        value: _selectedCountry,
                        items: _countries,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCountry = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("State", false),
                                SizedBox(height: 8.h),
                                CustomDropdown(
                                  hint: "Select State",
                                  value: _selectedState,
                                  items: _states,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedState = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("City", false),
                                SizedBox(height: 8.h),
                                CustomDropdown(
                                  hint: "Select City",
                                  value: _selectedCity,
                                  items: _cities,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCity = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Zip Code", false),
                                SizedBox(height: 8.h),
                                customTextFormField(
                                  controller: _zipCodeController,
                                  hintText: "Zip code",
                                  validator: (value) => null,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Phone", true),
                                SizedBox(height: 8.h),
                                customTextFormField(
                                  controller: _phoneController,
                                  hintText: "Type your phone number",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Phone number is required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Payment Method Section
                const PaymentMethod(),
                SizedBox(height: 16.h),

                // Order Summary Section - Added new widget
                const OrderSummary(),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
            color: const Color(0xFF000080),
          ),
        ),
        if (isRequired)
          Text(
            " *",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Gilroy',
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}