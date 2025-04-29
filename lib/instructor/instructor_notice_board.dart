import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorNoticeBoard extends StatefulWidget {
  const InstructorNoticeBoard({Key? key}) : super(key: key);

  @override
  State<InstructorNoticeBoard> createState() => _InstructorNoticeBoardState();
}

class _InstructorNoticeBoardState extends State<InstructorNoticeBoard> {
  // Static data for courses that can be replaced with API data later
  final List<CourseNotice> _courseNotices = [
    CourseNotice(
      id: '1',
      courseName: 'Tajweed ul Quran Asaan Treeqy (Urdu)',
      totalNotices: 2,
      courseImage: 'assets/tajweed_quran.png',
    ),
    CourseNotice(
      id: '2',
      courseName: 'Learn Quranic Arabic the easy way (52 Hours Course)',
      totalNotices: 1,
      courseImage: 'assets/quranic_arabic.png',
    ),
    CourseNotice(
      id: '3',
      courseName: 'Islamic Studies Fundamentals',
      totalNotices: 3,
      courseImage: 'assets/islamic_studies.png',
    ),
    CourseNotice(
      id: '4',
      courseName: 'Arabic Conversation Practice',
      totalNotices: 0,
      courseImage: 'assets/arabic_conversation.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title:  Center(
          child: Text(
            'Notice Board',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF78A03F),fontSize: 22),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Course Notices',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(
                              'Active Courses: 4',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Color(0XFF78A03F),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _courseNotices.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            return CourseNoticeItem(
                              courseNotice: _courseNotices[index],
                              onAddNotice: () {
                                // Function to handle add notice
                                _showAddNoticeDialog(context, _courseNotices[index]);
                              },
                              onViewList: () {
                                // Function to handle view list
                                _showNoticeListDialog(context, _courseNotices[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNoticeDialog(BuildContext context, CourseNotice course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String noticeTitle = '';
        String noticeContent = '';

        return AlertDialog(
          title: Text('Add Notice for ${course.courseName}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Notice Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    noticeTitle = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Notice Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    noticeContent = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                // TODO: Add notice logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notice added to ${course.courseName}'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoticeListDialog(BuildContext context, CourseNotice course) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notices for ${course.courseName}'),
          content: course.totalNotices > 0
              ? ListView.builder(
            shrinkWrap: true,
            itemCount: course.totalNotices,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Notice ${index + 1}'),
                subtitle: Text('Posted on ${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // View notice details
                },
              );
            },
          )
              : const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('No notices available for this course.'),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CourseNoticeItem extends StatelessWidget {
  final CourseNotice courseNotice;
  final VoidCallback onAddNotice;
  final VoidCallback onViewList;

  const CourseNoticeItem({
    Key? key,
    required this.courseNotice,
    required this.onAddNotice,
    required this.onViewList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.h, // Adjusted container height to prevent overflow
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout
          final isSmallScreen = constraints.maxWidth < 400;

          if (isSmallScreen) {
            // Stack layout for small screens
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top part: Image and Course Info
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image on left
                      _buildCourseImage(),
                      const SizedBox(width: 12),
                      // Course name and notices
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCourseName(),
                            const SizedBox(height: 6),
                            _buildNoticesInfo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom part: Buttons
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildAddButton()),
                    const SizedBox(width: 8),
                    Expanded(child: _buildViewButton()),
                  ],
                ),
              ],
            );
          } else {
            // Row layout for larger screens
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top part: Image and Course Info
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image on left
                      _buildCourseImage(),
                      const SizedBox(width: 16),
                      // Course name and notices
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCourseName(),
                            const SizedBox(height: 6),
                            _buildNoticesInfo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom part: Buttons
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildAddButton()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildViewButton()),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCourseImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          courseNotice.courseImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(
                Icons.book,
                color: Colors.grey[600],
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourseName() {
    return Text(
      courseNotice.courseName,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNoticesInfo() {
    return Row(
      children: [
        const Icon(
          Icons.notifications,
          size: 16,
          color: Colors.grey,
        ),
        const SizedBox(width: 4),
        Text(
          'Notices: ${courseNotice.totalNotices}',
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: onAddNotice,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0XFF78A03F),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        minimumSize: const Size(0, 38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('ADD NOTICE', style: TextStyle(fontSize: 13)),
    );
  }

  Widget _buildViewButton() {
    return OutlinedButton(
      onPressed: onViewList,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0XFF78A03F),
        side: const BorderSide(color: Color(0XFF78A03F)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        minimumSize: const Size(0, 38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('VIEW LIST', style: TextStyle(fontSize: 13)),
    );
  }
}

class CourseNotice {
  final String id;
  final String courseName;
  final int totalNotices;
  final String courseImage;

  CourseNotice({
    required this.id,
    required this.courseName,
    required this.totalNotices,
    required this.courseImage,
  });
}