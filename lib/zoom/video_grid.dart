import 'package:flutter/material.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:learn_megnagmet/zoom/zoom_event_handler.dart';

class VideoGrid extends StatelessWidget {
  final List<ZoomVideoSdkUser> users;
  final String? localUserId;
  final ZoomVideoSdkUser? sharingUser;
  final bool isSharing;

  const VideoGrid({
    super.key,
    required this.users,
    required this.localUserId,
    required this.sharingUser,
    required this.isSharing,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty || localUserId == null) {
      print('� Bellamy VideoGrid: Empty users or null localUserId');
      return const Center(child: CircularProgressIndicator());
    }

    print('� Bellamy VideoGrid: Rendering ${users.length} users');
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: users.length <= 2 ? 1 : 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1.0,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isUserSharing = sharingUser != null && sharingUser!.userId == user.userId;
        print('� Bellamy VideoGrid: Rendering user ${user.userId}, sharing: $isUserSharing');
        return Stack(
          children: [
            VideoView(
              user: user,
              hasMultiCamera: false,
              sharing: isUserSharing,
              preview: false,
              focused: user.userId.toString() == localUserId,
              multiCameraIndex: "0",
              videoAspect: "16:9",
              fullScreen: users.length == 1,
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                isUserSharing ? "${user.userName} (Sharing)" : user.userName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }
}