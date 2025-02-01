import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String courseType;

  const CourseVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.courseType,
  }) : super(key: key);

  @override
  State<CourseVideoPlayer> createState() => _CourseVideoPlayerState();
}

class _CourseVideoPlayerState extends State<CourseVideoPlayer> {
  // Initialize with temporary URL
  late FlickManager flickManager = FlickManager(
    videoPlayerController: VideoPlayerController.network(""),  // Temporary URL until API response
    //https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4
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
    if (widget.videoUrl.isNotEmpty) {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: isYouTubeVideo
          ? YoutubePlayer(controller: youtubeController)
          : FlickVideoPlayer(flickManager: flickManager),
    );
  }
}