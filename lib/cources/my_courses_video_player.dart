import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  // Initialize with temporary URL
  late FlickManager flickManager = FlickManager(
    videoPlayerController: VideoPlayerController.network(""),  // Temporary URL until API response
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
    if (widget.previewSrcType == 'course_intro_video' && widget.videoUrl.isNotEmpty) {
      if (widget.videoUrl.contains('youtube.com')) {
        String videoId = '';
        if (widget.videoUrl.contains('embed/')) {
          videoId = widget.videoUrl.split('embed/').last;
        } else if (widget.videoUrl.contains('watch?v=')) {
          videoId = Uri.parse(widget.videoUrl).queryParameters['v'] ?? '';
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
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(22),
        child: widget.previewSrcType == 'course_intro_video'
            ? (isYouTubeVideo
            ? YoutubePlayer(controller: youtubeController)
            : FlickVideoPlayer(flickManager: flickManager))
            : widget.previewSrcType == 'course_intro_image'
            ? AspectRatio(
          aspectRatio: 16 / 9,
              child: Image.network(
                      widget.videoUrl, // Assuming videoUrl is the image URL in this case
                      fit: BoxFit.cover,
                    ),
            )
            : Container(), // Fallback in case of unexpected previewSrcType
      ),
    );
  }
}