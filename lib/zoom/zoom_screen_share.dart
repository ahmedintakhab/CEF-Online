import 'package:flutter/material.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_share_helper.dart';
import 'dart:convert';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ZoomScreenShareWidget extends StatefulWidget {
  final ZoomVideoSdk zoom;
  final ValueNotifier<bool> isSharing;
  final ValueNotifier<ZoomVideoSdkUser?> sharingUser;
  final bool isInstructor;

  const ZoomScreenShareWidget({
    super.key,
    required this.zoom,
    required this.isSharing,
    required this.sharingUser,
    this.isInstructor = false,
  });

  @override
  State<ZoomScreenShareWidget> createState() => _ZoomScreenShareWidgetState();
}

class _ZoomScreenShareWidgetState extends State<ZoomScreenShareWidget> {
  late ZoomVideoSdkShareHelper shareHelper;
  late ZoomVideoSdkEventListener eventListener;
  static const MethodChannel _platform = MethodChannel('com.codiro.cef_online/zoom');

  @override
  void initState() {
    super.initState();
    shareHelper = widget.zoom.shareHelper;
    eventListener = ZoomVideoSdkEventListener();
    _setupEventListeners();
  }

  void _setupEventListeners() {
    eventListener.addListener('onUserShareStatusChanged', (data) async {
      try {
        data = data as Map;
        ZoomVideoSdkUser? mySelf = await widget.zoom.session.getMySelf();
        ZoomVideoSdkUser shareUser = ZoomVideoSdkUser.fromJson(jsonDecode(data['user'].toString()));
        var shareAction = jsonDecode(data['shareAction'].toString());

        print('onUserShareStatusChanged: user=${shareUser.userId}, shareStatus=${shareAction['shareStatus']}');
        if (shareAction['shareStatus'] == 'Start' || shareAction['shareStatus'] == 'Resume') {
          widget.sharingUser.value = shareUser;
          widget.isSharing.value = (shareUser.userId == mySelf?.userId);
        } else {
          widget.sharingUser.value = null;
          widget.isSharing.value = false;
        }
      } catch (e, stackTrace) {
        print('Error in onUserShareStatusChanged: $e\n$stackTrace');
      }
    });
    // Add listener for share errors
    eventListener.addListener('onError', (data) async {
      print(' Zoom SDK Error: $data');
    });
  }

  Future<bool> _requestScreenSharePermission() async {
    if (Platform.isAndroid) {
      try {
        print('Requesting media projection permission');
        final result = await _platform.invokeMethod('requestMediaProjection');
        print('Media projection permission result: $result');
        return result == true;
      } on PlatformException catch (e, stackTrace) {
        print('Failed to request media projection: code=${e.code}, message=${e.message}\n$stackTrace');
        return false;
      }
    }
    return true;
  }

  Future<void> _toggleScreenShare() async {
    try {
      final isOtherSharing = await shareHelper.isOtherSharing();
      final isShareLocked = await shareHelper.isShareLocked();
      print('isOtherSharing: $isOtherSharing, isShareLocked: $isShareLocked');

      if (isOtherSharing && !widget.isInstructor) {
        _showAlert("Another user is currently sharing. Please wait.");
        return;
      }

      if (isShareLocked) {
        _showAlert("Screen sharing is locked by the host.");
        return;
      }

      if (widget.isSharing.value) {
        print('Attempting to stop screen sharing');
        await shareHelper.stopShare();
        final isSharingOut = await shareHelper.isSharingOut();
        print('isSharingOut after stop: $isSharingOut');
        if (!isSharingOut) {
          _showSuccess("Screen sharing stopped successfully");
          print('Screen sharing stopped successfully');
        } else {
          _showAlert("Failed to stop screen sharing.");
          print('Failed to stop screen sharing');
        }
      } else {
        print('Requesting screen share permission');
        final permissionGranted = await _requestScreenSharePermission();
        if (!permissionGranted) {
          _showAlert("Screen sharing permission denied.");
          print('Screen sharing permission denied');
          return;
        }
        if (widget.isInstructor && isOtherSharing) {
          print('Instructor stopping other user’s share');
          await shareHelper.stopShare();
          print(' Stopped other user’s share');
        }
        print(' Starting screen share');
        await shareHelper.shareScreen();
        final isSharingOut = await shareHelper.isSharingOut();
        print('isSharingOut after start: $isSharingOut');
        if (isSharingOut) {
          _showSuccess("Screen sharing started successfully");
          print(' Screen sharing started successfully');
        } else {
          _showAlert("Failed to start screen sharing.");
          print('Failed to start screen sharing');
        }
      }
    } catch (e, stackTrace) {
      _showAlert("Error toggling screen share: $e");
      print('Screen share error: $e\n$stackTrace');
    }
  }

  void _showAlert(String message) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Screen Share Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isSharing,
      builder: (context, isSharing, child) {
        return ValueListenableBuilder<ZoomVideoSdkUser?>(
          valueListenable: widget.sharingUser,
          builder: (context, sharingUser, _) {
            if (!widget.isInstructor && sharingUser != null && !isSharing) {
              return const SizedBox.shrink();
            }

            return IconButton(
              onPressed: _toggleScreenShare,
              icon: Icon(
                isSharing ? Icons.stop_screen_share : Icons.screen_share,
                color: isSharing ? Colors.red : Colors.white,
              ),
              iconSize: 40.0,
              tooltip: isSharing
                  ? "Stop Sharing"
                  : widget.isInstructor
                  ? "Share Your Screen"
                  : "Request to Share",
            );
          },
        );
      },
    );
  }
}