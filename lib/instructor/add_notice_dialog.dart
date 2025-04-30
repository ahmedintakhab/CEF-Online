import 'package:flutter/material.dart';
import 'instructor_notice_board.dart';

class AddNoticeDialog extends StatelessWidget {
  final CourseNotice course;

  const AddNoticeDialog({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  }
}