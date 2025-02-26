// course_footer.dart
import 'package:flutter/material.dart';

class CourseFooter extends StatelessWidget {
  // Optional parameters to make it work both statically and dynamically
  final List<String>? enrolledStudentsImages;
  final int? totalEnrolledStudents;
  final String? courseLastUpdate;
  // Add the global data that will be used when individual params are not provided
  final Map<String, dynamic>? footerData;

  const CourseFooter({
    Key? key,
    this.enrolledStudentsImages,
    this.totalEnrolledStudents,
    this.courseLastUpdate,
    this.footerData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use provided specific data if available, otherwise use from footerData
    final images = enrolledStudentsImages ??
        (footerData != null ? List<String>.from(footerData!['enrolled_students_image']) :
        [
          "https://dev.cefonlineacademy.com/uploads/default/instructor-default.png",
          "https://dev.cefonlineacademy.com/uploads/default/instructor-default.png",
          "https://dev.cefonlineacademy.com/uploads/default/instructor-default.png",
        ]);

    final enrolledCount = totalEnrolledStudents ??
        (footerData != null ? footerData!['total_enrolled_students'] : 29);

    final lastUpdate = courseLastUpdate ??
        (footerData != null ? footerData!['course_last_update'] : "25 Feb 2025");

    // Use Row directly without Container for the footer
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - Enrolled users with avatars
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 36,
              child: Stack(
                children: [
                  // Display up to 3 avatars in a stack
                  for (int i = 0; i < images.length && i < 5; i++)
                    Positioned(
                      left: i * 20.0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(images[i]),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$enrolledCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'ENROLLED',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Right side - Last update info
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Last update',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              lastUpdate,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}