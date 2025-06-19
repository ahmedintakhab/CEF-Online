import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructorIndividualScheduleClass extends StatelessWidget {
  final List<dynamic> Classes;
  InstructorIndividualScheduleClass({required this.Classes});

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
          // Padding(
          //   padding: EdgeInsets.all(16.h),
          //   child: Text(
          //     'Individual Schedule',
          //     style: TextStyle(
          //       fontSize: 18.sp,
          //       fontWeight: FontWeight.bold,
          //       color: Color(0XFF78A03F),
          //     ),
          //   ),
          // ),
          // Divider(height: 0),
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
          _buildInfoRow('Student', classData['student_name'] ?? 'N/A'),
          _buildInfoRow('Course', classData['course_title'] ?? 'N/A'),
          _buildInfoRow('Date', classData['class_date'] ?? 'N/A'),
          _buildInfoRow(
            'Status',
            classData['status'] ?? 'N/A',
            isStatus: true,
            btnHref: classData['btnHref'], // Use btnHref if provided in API
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false, String? btnHref}) {
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
                ? value == 'Start Class' && btnHref != null
                ? ElevatedButton(
              onPressed: () async {
                final url = Uri.parse(btnHref);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $btnHref';
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _getStatusColor(value).withOpacity(0.2),
                foregroundColor: _getStatusColor(value),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                elevation: 0, // Remove shadow to match Container
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(
                  color: _getStatusColor(value),
                  fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                ),
              ),
              child: Text(value),
            )
                :Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: _getStatusColor(value).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: _getStatusColor(value),
                  fontWeight: FontWeight.w600,
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

      case 'Start Class':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }
}