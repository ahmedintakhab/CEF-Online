import 'package:flutter/material.dart';

class GroupClassHistory extends StatelessWidget {
  final List<dynamic> Classes;
  GroupClassHistory({required this.Classes});


  // final List<Map<String, String>> classes = [
  //   {
  //     'No': '1',
  //     'Instructor': 'Ali Hassan',
  //     'Type': 'Group',
  //     'Status': 'Completed',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '03-01-2025 Fri 09:39 PM'
  //   },
  //   {
  //     'No': '2',
  //     'Instructor': 'Nouman Ab',
  //     'Type': 'Group',
  //     'Status': 'Completed',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '31-12-2024 Tue 02:58 PM'
  //   },
  //   {
  //     'No': '3',
  //     'Instructor': 'Nouman Ab',
  //     'Type': 'Group',
  //     'Status': 'Completed',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '28-12-2024 Sat 11:56 AM'
  //   },
  //   {
  //     'No': '4',
  //     'Instructor': 'Nouman Ab',
  //     'Type': 'Group',
  //     'Status': 'Completed',
  //     'Course': 'Tajweed ul Quran the easy way (English)',
  //     'Date Time': '27-12-2024 Fri 06:16 PM'
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
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
            padding: EdgeInsets.all(16),
            child: Text(
              'Group Class History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                  color: Color(0XFF78A03F)

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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          _buildInfoRow('No', classData['sr_no']?.toString() ?? 'N/A'),
          _buildInfoRow('Instructor', classData['instructor'] ?? 'N/A'),
          _buildInfoRow('Type', classData['type'] ?? 'N/A'),
          _buildInfoRow('Status', classData['status']?.toString() ?? 'N/A',
              isStatus: true),
          _buildInfoRow('Course', classData['course'] ?? 'N/A'),
          _buildInfoRow('Date', classData['date_time'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
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
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isStatus
                ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: value == 'Completed'
                    ? Colors.green[100]
                    : Colors.red[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: value == 'Completed'
                      ? Colors.green[800]
                      : Colors.red[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}