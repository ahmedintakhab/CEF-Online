import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/api_constants.dart';

class InstructorContainer extends StatefulWidget {
  final TextEditingController replyController;
  final String courseId;
  final int? discussionId;
  final Function(List<dynamic>)? onDiscussionUpdated;

  const InstructorContainer({
    Key? key,
    required this.replyController,
    required this.courseId,
    required this.discussionId,
    this.onDiscussionUpdated,
  }) : super(key: key);

  @override
  State<InstructorContainer> createState() => _InstructorContainerState();
}

class _InstructorContainerState extends State<InstructorContainer> {
  bool _isLoading = false;
  String _replyText = '';

  @override
  void initState() {
    super.initState();
    widget.replyController.addListener(_updateReplyText);
  }

  @override
  void dispose() {
    widget.replyController.removeListener(_updateReplyText);
    super.dispose();
  }

  void _updateReplyText() {
    _replyText = widget.replyController.text;
  }

  void _clearTextField() {
    widget.replyController.text = '';
    widget.replyController.clear();
    setState(() {
      _replyText = '';
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          if (widget.replyController.text.isNotEmpty) {
            widget.replyController.clear();
          }
        });
      }
    });
  }

  Future<List<dynamic>?> _fetchDiscussionList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final url = '${ApiConstants.baseUrl}student/course/discussion-list/${widget.courseId}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Discussion list fetched successfully: ${response.body}');
        return responseData as List<dynamic>;
      } else {
        print('Failed to fetch discussion list: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching discussion list: $e');
      return null;
    }
  }

  Future<void> _postReply() async {
    if (widget.discussionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No discussion found to reply to')),
      );
      return;
    }

    final String replyText = _replyText.trim();

    if (replyText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reply')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _clearTextField();

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');

      if (authToken == null || authToken.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You need to log in to post a reply')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final url = Uri.parse('${ApiConstants.baseUrl}student/course/create-discussion-reply');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'discussion_id': widget.discussionId,
          'course_id': widget.courseId,
          'reply_comment': replyText,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          _clearTextField();
      print('Call the discussion list api after leave reply');
          // Fetch updated discussion list
          final newDiscussionData = await _fetchDiscussionList();
          if (newDiscussionData != null && widget.onDiscussionUpdated != null) {
            widget.onDiscussionUpdated!(newDiscussionData);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reply posted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Failed to post reply')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to post reply. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      _clearTextField();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: widget.replyController,
            cursorColor: const Color(0XFF8CC13F),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Leave a reply...',
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF78A03F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                if (widget.replyController.text.trim().isNotEmpty) {
                  _postReply();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a reply')),
                  );
                }
              },
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Reply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}