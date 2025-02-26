// overview_page.dart
import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:learn_megnagmet/Course_details_tabbar/course_footer.dart';

class OverviewPage extends StatelessWidget {
  final Map<String, dynamic> overviewData;

  const OverviewPage({Key? key, required this.overviewData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("Check the new overview data:$overviewData");
    // Static data for now
    final String title = 'Overview Page';
    final List<String> keyPoints = [
      'Key Point 1: This is the first key point.',
      'Key Point 2: This is the second key point.',
      'Key Point 3: This is the third key point.',
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Key Points
            ...keyPoints.map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(fontSize: 16)), // Bullet point
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: 20),

            // Expandable Description
            ExpandableText(
              overviewData['description'],
              expandText: 'Learn more',
              collapseText: 'Learn less',
              maxLines: 4,
              linkColor: Colors.green, // Customize the link color
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            // SizedBox(height: 50),
            Spacer(),

            // Using the footer with footerData
            overviewData.containsKey('footer_section')
                ? CourseFooter(footerData: overviewData['footer_section'])
                : CourseFooter(), // Fallback to static data if API data not available
             SizedBox(height: 20),

          ]
        )
      ),
    );
  }
}