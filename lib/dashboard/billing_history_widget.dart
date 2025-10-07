import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:learn_megnagmet/dashboard/all_billing_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_constants.dart';

class BillingHistoryWidget extends StatefulWidget {

  BillingHistoryWidget({Key? key}) : super(key: key);

  @override
  State<BillingHistoryWidget> createState() => _BillingHistoryWidgetState();
}

class _BillingHistoryWidgetState extends State<BillingHistoryWidget> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic>? billingHistoryData;

  // List of colors for avatar backgrounds (cycling like static data)
  final List<Color> avatarColors = [
    Colors.blue.shade100,
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.purple.shade100,
  ];
  @override
  void initState(){
    super.initState();
    fetchBillingHistory();

  }

  Future<void> fetchBillingHistory() async {
    print("🔄 Fetching Billing History API...");
    final url = "${ApiConstants.baseUrl}student/billing-history";

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
        print("✅ Billing History API fetched successfully! Data: ${data['billing_history']}");
        setState(() {
          billingHistoryData = data['billing_history'] ?? [];
          isLoading = false;
        });
      } else {
        print("❌ Billing History API Error: ${response.statusCode}");
        setState(() {
          errorMessage = "Failed to load data (Code: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Exception in Billing History API: $e");
      setState(() {
        errorMessage = "An error occurred: $e";
        isLoading = false;
      });
    }
  }
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(left:16.w, right: 16.w , top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Billing History',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context)=>AllBillingHistory(billingHistoryData: billingHistoryData ?? [],)));
                    // Navigate to full leaderboard
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF78A03F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
          // Loading/Error/Empty States
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Color(0xFF78A03F)),
              ),
            )
          else if (billingHistoryData == null || billingHistoryData!.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No Billing History',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
          else
          // Scrollable List with fixed height
          Container(
            // height: 300.h, // Fixed height for scrolling
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount:  billingHistoryData!.length > 4 ? 4 : billingHistoryData!.length ,
              itemBuilder: (context, index) {
                final item =  billingHistoryData![index];
                final color = avatarColors[index % avatarColors.length]; // Cycle colors
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Rank number
                      Container(
                        width: 35.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            '${item['id']}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),

                      // Avatar with flag
                      Stack(
                        children: [
                          Container(
                            width: 80.r,  // same as radius*2
                            height: 80.r,
                            decoration: BoxDecoration(
                              color: color,
                              image: DecorationImage(
                                image: NetworkImage(item['courseImage'] ?? 'https://via.placeholder.com/56'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.r), // make square with slightly rounded corners
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 12.w),

                      // Name, course, price and points
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   item['name'],
                            //   style: TextStyle(
                            //     fontSize: 16.sp,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.black87,
                            //   ),
                            // ),
                            SizedBox(height: 4.h),
                            Text(
                              item['course_name'] ?? "N/A",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Text(
                                  ' Rs ${item['grand_total'] ?? '0'}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Container(
                                  width: 80,height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${item['payment_status'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 6.h),
                            // Issue Date
                            Text(
                              'Issue: ${item['issue_date'] ?? ''}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}





// import 'package:flutter/material.dart';
//
// class BillingHistoryWidget extends StatelessWidget {
//   const BillingHistoryWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with title and View All button
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Billing History',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Handle View All action
//                   },
//                   child: Text(
//                     'View All',
//                     style: TextStyle(color: const Color(0xFF78A03F),
//                         fontWeight: FontWeight.bold
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // SizedBox(height: 8),
//
//             // Divider
//             Divider(color: Colors.grey.shade300),
//             // SizedBox(height: 16),
//             _buildAndroidContent(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAndroidContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Row 1: Course Name
//         Row(
//           children: [
//             Container(
//               width: 100,
//               child: Text(
//                 'Course Name',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade700,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child:
//                   Text(
//                     'MAIMAAR CONNECT V.2',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//               ),
//             ),
//           ],
//         ),
//
//         SizedBox(height: 16),
//         Row(
//           children: [
//             Container(
//               width: 100,
//                 child: Text('Amount',style: TextStyle(color: Colors.grey.shade700,
//                     fontSize: 14,fontWeight:FontWeight.w600 ),)),
//             SizedBox(width: 16),
//              Text('Rs 3.0', style: TextStyle(
//                color: Colors.black,
//                fontSize: 14,
//                fontWeight: FontWeight.w500,
//              ),)
//           ],
//         ),
//         SizedBox(height: 16),
//         Row(
//           children: [
//             Container(
//               width: 100,
//                 child: Text('Issue Date',style: TextStyle(color: Colors.grey.shade700,
//                     fontSize: 14,fontWeight:FontWeight.w600 ),)),
//             SizedBox(width: 16),
//              Text('12-09-2025 04:13 PM', style: TextStyle(
//                color: Colors.black,
//                fontSize: 14,
//                fontWeight: FontWeight.w500,
//              ),)
//           ],
//         ),
//         SizedBox(height: 16),
//
//         // Row 3: Status
//         Row(
//           children: [
//             Container(
//               width: 100,
//               child: Text(
//                 'Status',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade700,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade200,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 'Checkout',
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }