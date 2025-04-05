import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/button.dart';
import '../widget/custom_text_form_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
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
                    "Change Password",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                      color: Color(0XFF78A03F),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
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
                      SizedBox(height: 16.h),
                      Text(
                        "Old Password",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          color: const Color(0xFF000080),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _oldPasswordController,
                        hintText: "Old Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Old password is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "New Password",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          color: const Color(0xFF000080),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      customTextFormField(
                        controller: _newPasswordController,
                        hintText: "New Password",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "New password is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      CustomButton(onTap: () {}, buttonText: 'Update')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:learn_megnagmet/widget/button.dart';
// import '../widget/custom_text_form_field.dart';
//
// class ChangePassword extends StatefulWidget {
//   const ChangePassword({Key? key}) : super(key: key);
//
//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }
//
// class _ChangePasswordState extends State<ChangePassword> {
//
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _zipCodeController = TextEditingController();
//
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     // _fetchCheckoutData();
//   }
//
//   // Future<void> _fetchCheckoutData() async {
//   //   try {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String token = prefs.getString('auth_token') ?? '';
//   //
//   //     final response = await http.get(
//   //       Uri.parse('${ApiConstants.baseUrl}student/checkout/1'),
//   //       headers: {
//   //         'Authorization': 'Bearer $token',
//   //         'Content-Type': 'application/json',
//   //       },
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final Map<String, dynamic> data = json.decode(response.body);
//   //       print('Checkout API response status code: ${response.statusCode}');
//   //
//   //       if (data['success'] == true) {
//   //         setState(() {
//   //           // Set countries list data
//   //           List<dynamic> countries = data['data']['countries'];
//   //           _countries.clear();
//   //           _countries.addAll(countries.map((country) => country['country_name'] as String));
//   //
//   //           // Prefill form with user info
//   //           Map<String, dynamic> userInfo = data['data']['userInfo'];
//   //           _addressController.text = userInfo['address'] ?? '';
//   //
//   //           _isLoading = false;
//   //         });
//   //       } else {
//   //         setState(() {
//   //           _errorMessage = data['message'] ?? 'Failed to load data';
//   //           _isLoading = false;
//   //         });
//   //       }
//   //     } else {
//   //       setState(() {
//   //         _errorMessage = 'Request failed with status: ${response.statusCode}';
//   //         _isLoading = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     setState(() {
//   //       _errorMessage = 'Error: $e';
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }
//
//   @override
//   void dispose() {
//     _addressController.dispose();
//     _zipCodeController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator(color: Color(0XFF78A03F)))
//             : _errorMessage.isNotEmpty
//             ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
//             : SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20.h),
//                 Center(
//                   child: Text(
//                     "Address & Location",
//                     style: TextStyle(
//                       fontSize: 26.sp,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Gilroy',
//                       color: Color(0XFF78A03F),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Container(
//                   padding: EdgeInsets.all(16.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10.r,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 16.h),
//                       _buildLabel("Postal Code", false),
//                       SizedBox(height: 8.h),
//                       customTextFormField(
//                         controller: _zipCodeController,
//                         hintText: "Postal code",
//                         validator: (value) => null,
//                       ),
//
//                       SizedBox(height: 16.h),
//                       _buildLabel("Address", true),
//                       SizedBox(height: 8.h),
//                       customTextFormField(
//                         controller: _addressController,
//                         hintText: "Address",
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Address is required";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 24.h),
//
//                       CustomButton(onTap: (){}, buttonText: 'Update')
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLabel(String label, bool isRequired) {
//     return Row(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Gilroy',
//             color: const Color(0xFF000080),
//           ),
//         ),
//         if (isRequired)
//           Text(
//             " *",
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w600,
//               fontFamily: 'Gilroy',
//               color: Colors.red,
//             ),
//           ),
//       ],
//     );
//   }
// }