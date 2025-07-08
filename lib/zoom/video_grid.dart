import 'package:flutter/material.dart';
import 'package:learn_megnagmet/zoom/zoom_event_handler.dart';

class VideoGrid extends StatelessWidget {
  final List<dynamic> users;
  final String? localUserId;

  const VideoGrid({
    super.key,
    required this.users,
    required this.localUserId,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty || localUserId == null) {
      // Fallback in case something goes wrong
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Only local user present — show own camera full screen
    if (users.length == 1 && users.first.userId.toString() == localUserId) {
      return VideoView(
        user: users.first,
        hasMultiCamera: false,
        sharing: false,
        preview: false,
        focused: true,
        multiCameraIndex: "0",
        videoAspect: null,
        fullScreen: true,
      );
    }

    // Multiple users — show grid
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: users.length <= 2 ? 1 : 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return VideoView(
          user: user,
          hasMultiCamera: false,
          sharing: false,
          preview: false,
          focused: false,
          multiCameraIndex: "0",
          videoAspect: null,
          fullScreen: false,
        );
      },
    );
  }
}
