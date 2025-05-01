import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/widget/button.dart';

class PastLiveScreen extends StatelessWidget {
  PastLiveScreen({super.key});

  // Static list of classes for Past screen
  final List<Map<String, String>> classes = [
    {
      'Topic': 'Urdu translation',
      'Date Time': '2025-04-01 08:44:00',
      'Time Duration': '20 minutes',
      'Learning Tool': 'BigBlueButton',
      'Status': 'Completed',
    },
    {
      'Topic': 'Arabic language',
      'Date Time': '2025-04-15 22:00:00',
      'Time Duration': '45 minutes',
      'Learning Tool': 'Zoom',
      'Status': 'Missed',
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Missed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final classData = classes[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30.h,
                                child: const Text(
                                  'Topic',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: const Text(
                                  'Date & Time',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: const Text(
                                  'Time Duration',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: const Text(
                                  'Learning Tool',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: const Text(
                                  'Status',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                                child: const Text(
                                  'Action',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30.h,
                                child: Text(classData['Topic'] ?? ''),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: Text(classData['Date Time'] ?? ''),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: Text(classData['Time Duration'] ?? ''),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: Text(classData['Learning Tool'] ?? ''),
                              ),
                              SizedBox(
                                height: 30.h,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(classData['Status'] ?? '').withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    classData['Status'] ?? '',
                                    style: TextStyle(
                                      color: _getStatusColor(classData['Status'] ?? ''),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              SizedBox(
                                height: 40.h,
                                width: 100.w,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomButton(onTap: () {}, buttonText: 'Back')),
              SizedBox(width: 10,),
              Expanded(child: CustomButton(onTap: () {}, buttonText: 'Add Live Class')),
            ],
          ),
        ],
      ),
    );
  }
}