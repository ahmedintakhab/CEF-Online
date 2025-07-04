import 'package:flutter/material.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';

class ZoomButtonsControllbar extends StatelessWidget {
  final bool isMuted;
  final bool isVideoOn;
  final VoidCallback onLeaveSession;

  final double circleButtonSize = 40.0;
  final zoom = ZoomVideoSdk();

  ZoomButtonsControllbar({
    super.key,
    required this.isMuted,
    required this.isVideoOn,
    required this.onLeaveSession,
  });

  Future<void> toggleAudio() async {
    final mySelf = await zoom.session.getMySelf();
    if (mySelf?.audioStatus == null) return;

    final muted = await mySelf!.audioStatus!.isMuted();
    if (muted) {
      await zoom.audioHelper.unMuteAudio(mySelf.userId);
    } else {
      await zoom.audioHelper.muteAudio(mySelf.userId);
    }
  }

  Future<void> toggleVideo() async {
    final mySelf = await zoom.session.getMySelf();
    if (mySelf?.videoStatus == null) return;

    final isOn = await mySelf!.videoStatus!.isOn();
    if (isOn) {
      await zoom.videoHelper.stopVideo();
    } else {
      await zoom.videoHelper.startVideo();
    }
  }

  Future<void> leaveSession() async {
    await zoom.leaveSession(false);
    onLeaveSession();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: toggleAudio,
                icon: Icon(
                  isMuted ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
                iconSize: circleButtonSize,
                tooltip: isMuted ? "Unmute" : "Mute",
              ),
              IconButton(
                onPressed: toggleVideo,
                icon: Icon(
                  isVideoOn ? Icons.videocam : Icons.videocam_off,
                  color: Colors.white,
                ),
                iconSize: circleButtonSize,
              ),
              IconButton(
                onPressed: leaveSession,
                icon: const Icon(
                  Icons.call_end,
                  color: Colors.red,
                ),
                iconSize: circleButtonSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
