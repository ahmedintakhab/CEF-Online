import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndividualSchedule extends StatelessWidget {
  final List<dynamic> Classes;
  IndividualSchedule({required this.Classes});

  // final List<Map<String, String>> classes = [
  //   {
  //     'No': '1',
  //     'Instructor': 'Nouman Ab',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '07-04-2025 Wed 02:00 PM',
  //     'Status': 'Missed'
  //   },
  //   {
  //     'No': '2',
  //     'Instructor': 'Nouman Ab',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '07-04-2025 Wed 03:00 PM',
  //     'Status': 'Waiting'
  //   },
  //   {
  //     'No': '3',
  //     'Instructor': 'Nouman Ab',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '14-04-2025 Wed 02:00 PM',
  //     'Status': 'Scheduled'
  //   },
  //   {
  //     'No': '4',
  //     'Instructor': 'Nouman Ab',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '14-04-2025 Wed 03:00 PM',
  //     'Status': 'Scheduled'
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.h),
            child: Text(
              'Individual Schedule',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Color(0XFF78A03F),
              ),
            ),
          ),
          Divider(height: 0),
          ...Classes.map((classData) => _buildClassItem(classData)).toList(),
        ],
      ),
    );
  }

  Widget _buildClassItem(Map<String, dynamic> classData) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          _buildInfoRow('No', classData['sr_no']?.toString() ?? 'N/A'),
          _buildInfoRow('Instructor', classData['instructor'] ?? 'N/A'),
          _buildInfoRow('Course', classData['course'] ?? 'N/A'),
          _buildInfoRow('Date', classData['date_time'] ?? 'N/A'),
          _buildInfoRow('Status', classData['status']['btnText'] ?? 'N/A', isStatus: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
                fontSize: 17.sp,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isStatus
                ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _getStatusColor(value).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: _getStatusColor(value),
                  fontWeight: FontWeight.w500,
                  fontSize: 17.sp,
                ),
              ),
            )
                : Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Missed':
        return Colors.red;
      case 'Waiting':
        return Colors.orange;
      case 'Scheduled':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}