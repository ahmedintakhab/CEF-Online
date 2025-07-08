import 'package:flutter/material.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_share_helper.dart';
import 'dart:convert';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';


class ZoomScreenShareWidget extends StatefulWidget {
  final ZoomVideoSdk zoom;
  final ValueNotifier<bool> isSharing;
  final ValueNotifier<ZoomVideoSdkUser?> sharingUser;
  final bool isInstructor; // Add this parameter


  const ZoomScreenShareWidget({
    super.key,
    required this.zoom,
    required this.isSharing,
    required this.sharingUser,
    this.isInstructor = false, // Default to false


  });

  @override
  State<ZoomScreenShareWidget> createState() => _ZoomScreenShareWidgetState();
}

class _ZoomScreenShareWidgetState extends State<ZoomScreenShareWidget> {
  late ZoomVideoSdkShareHelper shareHelper;
  late ZoomVideoSdkEventListener eventListener;

  @override
  void initState() {
    super.initState();
    shareHelper = widget.zoom.shareHelper;
    eventListener = ZoomVideoSdkEventListener();
    _setupEventListeners();
  }

  void _setupEventListeners() {
    eventListener.addListener('onUserShareStatusChanged', (data) async {
      data = data as Map;
      ZoomVideoSdkUser? mySelf = await widget.zoom.session.getMySelf();
      ZoomVideoSdkUser shareUser = ZoomVideoSdkUser.fromJson(jsonDecode(data['user'].toString()));
      var shareAction = jsonDecode(data['shareAction'].toString());

      if (shareAction['shareStatus'] == 'Start' || shareAction['shareStatus'] == 'Resume') {
        widget.sharingUser.value = shareUser;
        widget.isSharing.value = (shareUser.userId == mySelf?.userId);
      } else {
        widget.sharingUser.value = null;
        widget.isSharing.value = false;
      }
      setState(() {});
    });
  }

  Future<void> _toggleScreenShare() async {
    final isOtherSharing = await shareHelper.isOtherSharing();
    final isShareLocked = await shareHelper.isShareLocked();

    if (isOtherSharing) {
      _showAlert("Other is sharing");
      return;
    }
    // If current user is student and someone else is sharing, prevent takeover
    if (!widget.isInstructor && isOtherSharing) {
      _showAlert("The instructor is currently sharing. Please wait.");
      return;
    }

    if (isShareLocked) {
      _showAlert("Screen sharing is locked by host");
      return;
    }

    if (widget.isSharing.value) {
      await shareHelper.stopShare();
    } else {
      // For instructor, can override others' sharing
      if (widget.isInstructor && isOtherSharing) {
        await shareHelper.stopShare(); // Stop current share first
      }
      await shareHelper.shareScreen();
      print('🔔 shareScreen() called');
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
            // Hide button if someone else is sharing and current user is student
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
