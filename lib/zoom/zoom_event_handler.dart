import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:flutter_zoom_videosdk/flutter_zoom_view.dart' as flutter_zoom_view;

class VideoView extends StatelessWidget {
  final ZoomVideoSdkUser? user;
  final bool sharing;
  final bool preview;
  final bool focused;
  final bool hasMultiCamera;
  final String multiCameraIndex;
  final String? videoAspect;
  final bool fullScreen;

  const VideoView({
    Key? key,
    required this.user,
    required this.sharing,
    required this.preview,
    required this.focused,
    required this.hasMultiCamera,
    required this.multiCameraIndex,
    this.videoAspect,
    required this.fullScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null || user?.userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final creationParams = {
      'userId': user!.userId.toString(),
      'isLocal': preview,
      'isSharing': sharing,
      'canvasType': sharing ? 'share' : 'video', // Fallback for SDK compatibility
      'width': MediaQuery.of(context).size.width.toInt(),
      'height': fullScreen
          ? MediaQuery.of(context).size.height.toInt()
          : (MediaQuery.of(context).size.width / 2).toInt(),
      'videoAspect': videoAspect ?? '16:9',
      'hasMultiCamera': hasMultiCamera,
      'multiCameraIndex': multiCameraIndex,
      'focused': focused,
    };

    print('🔔 VideoView creationParams: $creationParams');

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'flutter_zoom_videosdk_view',
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            print('🔔 AndroidView created with id: $id');
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'flutter_zoom_videosdk_view',
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            print('🔔 UiKitView created with id: $id');
          },
        );
      default:
        return const Text("Unsupported platform");
    }
  }
}