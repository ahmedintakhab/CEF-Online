import 'package:flutter/material.dart';
import 'package:learn_megnagmet/Course_details_tabbar/conversation_container.dart';
import 'package:learn_megnagmet/Course_details_tabbar/instructor_container.dart';

class DiscussionPage extends StatefulWidget {
  final List<dynamic> discussionData;
  final int courseID;

  const DiscussionPage({
    Key? key,
    required this.discussionData,
    required this.courseID,
  }) : super(key: key);

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late List<dynamic> _discussionList;
  final TextEditingController _replyController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late Map<String, dynamic> _authUserImages;

  @override
  void initState() {
    super.initState();

    // Extract discussion items and auth_user_images
    _discussionList = [];
    _authUserImages = {};

    for (var item in widget.discussionData) {
      if (item is Map<String, dynamic> && item.containsKey('auth_user_images')) {
        _authUserImages = item['auth_user_images'];
      } else if (item is Map<String, dynamic> && item.containsKey('discussion_id')) {
        _discussionList.add(item);
      }
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Method to handle new discussion being posted
  void _onMessagePosted(Map<String, dynamic> newDiscussion) {
    setState(() {
      // Add the new discussion to the top of the list
      _discussionList.insert(0, newDiscussion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // First container with Start Conversation
              ConversationContainer(
                messageController: _messageController,
                courseID: widget.courseID,
                onMessagePosted: _onMessagePosted, // Pass the callback
              ),
              const SizedBox(height: 20),

              // Message container (only show if discussionData is not empty)
              if (_discussionList.isNotEmpty)
                ..._discussionList.map((discussion) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: _getImageProvider(
                                discussion['discussion_user_image'],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          discussion['discussion_user_name'] ?? 'Unknown User',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (discussion['discussion_user_type'] == "Instructor")
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[100],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              "Instructor",
                                              style: TextStyle(
                                                color: Colors.blue[800],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(discussion['discussion_comment'] ?? 'No comment'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 56, top: 8),
                          child: Row(
                            children: [
                              Text(
                                discussion['discussion_created_at'] ?? 'Unknown date',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Icon(Icons.message, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    (discussion['discussion_total_replies'] ?? 0).toString(),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Reply message (indented) - only show if discussion_replies_list is not empty
                        if (discussion['discussion_replies_list'] != null &&
                            discussion['discussion_replies_list'].isNotEmpty)
                          ...(discussion['discussion_replies_list'] ?? []).map((reply) {
                            return Container(
                              margin: const EdgeInsets.only(left: 40, top: 16, bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: _getImageProvider(
                                      reply['reply_user_image'],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                reply['reply_user_name'] ?? 'Unknown User',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              if (reply['reply_user_type'] == "Instructor")
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[100],
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    "Instructor",
                                                    style: TextStyle(
                                                      color: Colors.blue[800],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(reply['reply_comment'] ?? 'No comment'),
                                          const SizedBox(height: 4),
                                          Text(
                                            reply['reply_created_at'] ?? '',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  );
                }).toList(),

              // Leave a reply container
              InstructorContainer(
                replyController: _replyController,
                courseID: widget.courseID,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to handle image URLs
  ImageProvider _getImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty || !Uri.parse(imageUrl).isAbsolute) {
      // Use a local fallback image if the URL is invalid
      return const AssetImage('assets/avatar.png');
    } else {
      // Use the provided image URL
      return NetworkImage(imageUrl);
    }
  }
}