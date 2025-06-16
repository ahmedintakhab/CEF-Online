import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:learn_megnagmet/Course_details_tabbar/course_footer.dart';
import '../utils/html_utils.dart'; // Import the utility function

class OverviewPage extends StatelessWidget {
  final Map<String, dynamic> overviewData;

  const OverviewPage({Key? key, required this.overviewData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> apiKeyPoints = overviewData['keyPoints'] ?? [];
    final List<String> keyPoints = apiKeyPoints.isNotEmpty
        ? apiKeyPoints.map((point) => point['name'] as String).toList()
        : [];

    // Convert HTML description to plain text
    final plainTextDescription = convertHtmlToPlainText(overviewData['description'] ?? '');

    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Overview Page',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Gilroy',
                ),
              ),
              SizedBox(height: 10.h),

            // Key Points (only shown if keyPoints is not empty)
            if (keyPoints.isNotEmpty) ...[
          ...keyPoints.map((point) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: TextStyle(fontSize: 16.sp)),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                  ],
                ),

              )),
              SizedBox(height: 20.h),
  ],

              // Expandable Plain Text Description
              ExpandableText(
                plainTextDescription,
                expandText: 'Learn more',
                collapseText: 'Learn less',
                maxLines: 4,
                linkColor: Colors.green,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  fontFamily: 'Gilroy',
                ),
              ),
              SizedBox(height: 20.h),

              // Constrain CourseFooter to prevent layout issues
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 20.h, // Ensure a minimum height
                  // maxHeight: MediaQuery.of(context).size.height * 0.1, // Limit max height
                ),
                child: overviewData.containsKey('footer_section')
                    ? CourseFooter(footerData: overviewData['footer_section'])
                    : CourseFooter(),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}