import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupSchedule extends StatelessWidget {
  final List<Map<String, String>> classes = [
    {
      'No': '1',
      'Instructor': 'Ali Hassan',
      'Course': 'Tajweed ul Quran the easy way (English) - Group',
      'Date Time': '08-04-2025 Thu 10:00 AM',
      'Status': 'Missed'
    },
    {
      'No': '2',
      'Instructor': 'Nouman Ab',
      'Course': 'Tajweed ul Quran the easy way (English) - Group',
      'Date Time': '08-04-2025 Thu 11:00 AM',
      'Status': 'Waiting'
    },
    {
      'No': '3',
      'Instructor': 'Nouman Ab',
      'Course': 'Tajweed ul Quran the easy way (English) - Group',
      'Date Time': '15-04-2025 Thu 10:00 AM',
      'Status': 'Scheduled'
    },
    {
      'No': '4',
      'Instructor': 'Ali Hassan',
      'Course': 'Tajweed ul Quran the easy way (English) - Group',
      'Date Time': '15-04-2025 Thu 11:00 AM',
      'Status': 'Scheduled'
    },
  ];

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
              'Group Schedule',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Color(0XFF78A03F),
              ),
            ),
          ),
          Divider(height: 0),
          ...classes.map((classData) => _buildClassItem(classData)).toList(),
        ],
      ),
    );
  }

  Widget _buildClassItem(Map<String, String> classData) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          _buildInfoRow('No', classData['No']!),
          _buildInfoRow('Instructor', classData['Instructor']!),
          _buildInfoRow('Course', classData['Course']!),
          _buildInfoRow('Date', classData['Date Time']!),
          _buildInfoRow('Status', classData['Status']!, isStatus: true),
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