import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/profile/student_zoom_meeting.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualSchedule extends StatelessWidget {
  final List<dynamic> Classes;
  IndividualSchedule({required this.Classes});

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
          ...Classes.map((classData) => _buildClassItem(classData,context)).toList(),
        ],
      ),
    );
  }

  Widget _buildClassItem(Map<String, dynamic> classData,BuildContext? context) {
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
          _buildInfoRow('Status', classData['status']['btnText'] ?? 'N/A',
              isStatus: true,
              btnHref: classData['status']['btnHref'],
          learningTool: classData['learning_tool'],
          lessonId: classData['status']?['classDetails']?['lesson_id']?.toString(),
          meetingId: classData['status']?['classDetails']?['meeting_id'],
            context: context, // Pass context only for Status row
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false,
    String? btnHref,String? lessonId, String? learningTool,
    String? meetingId,BuildContext? context, })
  {
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
                ? value == 'In Progress' && btnHref != null
                ? SizedBox(height: 40.h,
              child: ElevatedButton(
                onPressed: () async {
                  if (learningTool == 'Zoom' && context != null) {
                    // Navigate to InstructorZoomMeeting for Zoom classes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  StudentZoomMeeting(lessonId: lessonId ?? 'N/A',
                          meetingId: meetingId ?? 'N/A',),
                      ),
                    );
                  } else if (learningTool == 'Google_Meet' &&
                      btnHref != 'javascript:void(0);' &&
                      context != null) {
                    // Launch URL for Google Meet classes
                    final url = Uri.parse(btnHref);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch $btnHref')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getStatusColor(value).withOpacity(0.2),
                  foregroundColor: _getStatusColor(value),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  elevation: 0,
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
              ),
            )
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: _getStatusColor(value).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: _getStatusColor(value),
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  ),
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
      case 'Pending':
        return Colors.orange;
      case 'Scheduled':
        return Colors.blue;

        case 'Start Class':
        return Colors.green;
        case 'In Progress':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }
}