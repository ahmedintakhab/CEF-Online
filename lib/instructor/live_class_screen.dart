import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_megnagmet/widget/button.dart';

import 'create_live_class.dart';

class LiveClassScreen extends StatelessWidget {
  // Static data for the courses
  final List<Map<String, dynamic>> courses = [
    {
      'image': 'https://foundr.com/wp-content/uploads/2021/09/Best-online-course-platforms.png', // Replace with your image path
      'course_name': 'Tajweed Ul Quran Asaan Treeqy sy (Urdu)',
      'upcoming': 0,
      'current': 0,
      'past': 0,
    },
    {
      'image': 'https://img.freepik.com/premium-vector/online-training-courses-landing-page-design-concept_254538-184.jpg', // Replace with your image path
      'course_name': 'Learn Quranic Arabic the easy way (52 Hours Course)',
      'upcoming': 0,
      'current': 0,
      'past': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Live Class',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Color(0XFF78A03F),
          ),
        ),
        // backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.network(
                      course['image'],
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Course Details Row
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child:  Text(
                                'Course',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                course['course_name'],
                                style:  TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Upcoming Live Class',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                course['upcoming'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child:  Text(
                                'Current Live Class',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                course['current'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child:  Text(
                                'Past Live Class',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                course['past'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Buttons Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(child: CustomButton(onTap: (){}, buttonText: 'View List')),

                        const SizedBox(width: 16),
                        Expanded(child: CustomButton(onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateLiveClass()),
                          );
                        }, buttonText: 'Create CLass')),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}