import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String courseType;
  final String previewSrcType;

  const CourseVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.courseType,
    required this.previewSrcType,
  }) : super(key: key);

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  late FlickManager flickManager = FlickManager(
    videoPlayerController: VideoPlayerController.network(""),
    autoPlay: false,
  );
  late YoutubePlayerController youtubeController;
  bool isYouTubeVideo = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    if (widget.previewSrcType == 'course_intro_youtube_video' ||
        widget.previewSrcType == 'course_intro_video') {
      if (widget.videoUrl.contains('youtube.com') || widget.videoUrl.contains('youtu.be')) {
        String videoId = '';
        if (widget.videoUrl.contains('embed/')) {
          videoId = widget.videoUrl.split('embed/').last;
        } else if (widget.videoUrl.contains('watch?v=')) {
          videoId = Uri.parse(widget.videoUrl).queryParameters['v'] ?? '';
        } else if (widget.videoUrl.contains('youtu.be')) {
          videoId = widget.videoUrl.split('youtu.be/').last.split('?').first;
        }

        if (videoId.isNotEmpty) {
          isYouTubeVideo = true;
          youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          );
        }
      } else if (widget.videoUrl.endsWith('.mp4')) {
        flickManager = FlickManager(
          videoPlayerController: VideoPlayerController.network(widget.videoUrl),
          autoPlay: false,
        );
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    flickManager.dispose();
    if (isYouTubeVideo) {
      youtubeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 295.h,
      width: double.infinity,
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(22.r),
        child: widget.previewSrcType == 'course_intro_image' && widget.videoUrl.isNotEmpty
            ? Image.network(
          widget.videoUrl,
          fit: BoxFit.fill, // Show full image without stretching
          width: double.infinity,
          height: 295.h,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey[400],
                  size: 40.sp,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                color: Color(0XFF8CC13F),
              ),
            );
          },
        )
            : widget.previewSrcType == 'course_intro_youtube_video' && isYouTubeVideo
            ? YoutubePlayer(controller: youtubeController)
            : widget.previewSrcType == 'course_intro_video'
            ? FlickVideoPlayer(flickManager: flickManager)
            : Container(
          color: Colors.grey[200],
          child: Center(
            child: Icon(
              Icons.image,
              color: Colors.grey[400],
              size: 40.sp,
            ),
          ),
        ),
      ),
    );
  }
}