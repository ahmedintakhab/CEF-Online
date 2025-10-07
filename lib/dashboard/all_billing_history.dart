import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllBillingHistory extends StatefulWidget {
  final List<dynamic> billingHistoryData;

  AllBillingHistory({Key? key, required this.billingHistoryData}) : super(key: key);

  @override
  State<AllBillingHistory> createState() => _AllBillingHistoryState();
}

class _AllBillingHistoryState extends State<AllBillingHistory> {

  @override
  Widget build(BuildContext context) {
    // Define avatarColors here (copy from above)
    final List<Color> avatarColors = [
      Colors.blue.shade100,
      Colors.pink.shade100,
      Colors.blue.shade100,
      Colors.purple.shade100,
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        title: const Text(
          'Billing Result',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child:
             widget.billingHistoryData.isEmpty
                  ? const Center(child: Text('No Billing History'))
                  : ListView.builder(
               itemCount: widget.billingHistoryData.length,
                itemBuilder: (context, index) {
                  final item = widget.billingHistoryData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                                  // color: avatarColors,
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
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}