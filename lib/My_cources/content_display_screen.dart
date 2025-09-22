import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class ContentDisplayScreen extends StatefulWidget {
  final String title;
  final String contentType;
  final String source;

  const ContentDisplayScreen({
    Key? key,
    required this.title,
    required this.contentType,
    required this.source,
  }) : super(key: key);

  @override
  _ContentDisplayScreenState createState() => _ContentDisplayScreenState();
}

class _ContentDisplayScreenState extends State<ContentDisplayScreen> {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  AudioPlayer? _audioPlayer;
  WebViewController? _webViewController;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isLandscape = false;

  @override
  void initState() {
    super.initState();
    _initializeContent();
    // Set initial orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _initializeContent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      switch (widget.contentType) {
        case 'video':
          _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.source))
            ..initialize().then((_) {
              if (mounted) {
                setState(() {
                  _isInitialized = true;
                  _isLoading = false;
                });
                _videoController?.play();
              }
            }).catchError((e) {
              if (mounted) {
                setState(() {
                  _errorMessage = 'Failed to load video: $e';
                  _isLoading = false;
                });
              }
            });
          break;
        case 'youtube':
          final videoId = YoutubePlayer.convertUrlToId(widget.source);
          if (videoId != null) {
            _youtubeController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: true, // Changed to autoPlay: true
                mute: false,
              ),
            );
            setState(() {
              _isInitialized = true;
              _isLoading = false;
            });
          } else {
            setState(() {
              _errorMessage = 'Invalid YouTube URL: ${widget.source}';
              _isLoading = false;
            });
          }
          break;
        case 'audio':
          _audioPlayer = AudioPlayer();
          await _audioPlayer!.setUrl(widget.source).then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
                _isLoading = false;
              });
              _audioPlayer?.play();
            }
          }).catchError((e) {
            if (mounted) {
              setState(() {
                _errorMessage = 'Failed to load audio: $e';
                _isLoading = false;
              });
            }
          });
          break;
        case 'image':
        case 'pdf':
        case 'text':
          setState(() {
            _isInitialized = true;
            _isLoading = false;
          });
          break;
        case 'webview':
          try {
            _webViewController = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(Colors.white)
              ..setUserAgent('Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36')
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Handle progress if needed
                  },
                  onPageStarted: (String url) {
                    if (mounted) {
                      setState(() {
                        _isLoading = true;
                      });
                    }
                  },
                  onPageFinished: (String url) {
                    if (mounted) {
                      setState(() {
                        _isInitialized = true;
                        _isLoading = false;
                      });
                    }
                  },
                  onWebResourceError: (WebResourceError error) {
                    print('WebView Resource Error: ${error.description}');
                    // Don't show error for minor resource failures
                    if (error.errorType == WebResourceErrorType.hostLookup ||
                        error.errorType == WebResourceErrorType.timeout) {
                      if (mounted) {
                        setState(() {
                          _errorMessage = 'Failed to load content. Please check your internet connection.';
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  onNavigationRequest: (NavigationRequest request) {
                    // Allow all navigation within the webview
                    return NavigationDecision.navigate;
                  },
                ),
              );

            // Android-specific settings
            if (_webViewController!.platform is AndroidWebViewController) {
              final androidController = _webViewController!.platform as AndroidWebViewController;

              // Configure media playback
              await androidController.setMediaPlaybackRequiresUserGesture(false);

              // Handle console messages more gracefully
              androidController.setOnConsoleMessage((message) {
                // Filter out common media playback warnings/errors
                if (!message.message.contains('AbortError') &&
                    !message.message.contains('NotSupportedError') &&
                    !message.message.contains('autoplay')) {
                  print('WebView Console: ${message.message}');
                }
              });

              // Add a small delay before injecting JavaScript
              Future.delayed(const Duration(milliseconds: 500), () async {
                try {
                  // Inject JavaScript to handle media playback issues
                  await androidController.runJavaScript('''
                    (function() {
                      // Handle media elements gracefully
                      document.addEventListener('DOMContentLoaded', function() {
                        const mediaElements = document.querySelectorAll('video, audio');
                        mediaElements.forEach(function(element) {
                          element.addEventListener('loadstart', function() {
                            console.log('Media loading started');
                          });
                          element.addEventListener('error', function(e) {
                            console.log('Media error handled gracefully');
                            e.preventDefault();
                          });
                        });
                        
                        // Prevent multiple play/pause calls
                        let isPlaying = false;
                        const videos = document.querySelectorAll('video');
                        videos.forEach(function(video) {
                          video.addEventListener('play', function() {
                            if (!isPlaying) {
                              isPlaying = true;
                            }
                          });
                          video.addEventListener('pause', function() {
                            isPlaying = false;
                          });
                          
                          // Handle promise rejections
                          const originalPlay = video.play;
                          video.play = function() {
                            const playPromise = originalPlay.call(this);
                            if (playPromise !== undefined) {
                              playPromise.catch(function() {
                                console.log('Play interrupted, handled gracefully');
                              });
                            }
                            return playPromise;
                          };
                        });
                      });
                      
                      // If DOM is already loaded
                      if (document.readyState === 'complete' || document.readyState === 'interactive') {
                        const event = new Event('DOMContentLoaded');
                        document.dispatchEvent(event);
                      }
                    })();
                  ''');
                } catch (e) {
                  print('JavaScript injection failed: $e');
                }
              });
            }

            // Load the URL
            await _webViewController!.loadRequest(Uri.parse(widget.source));

          } catch (e) {
            if (mounted) {
              setState(() {
                _errorMessage = 'Failed to initialize content: $e';
                _isLoading = false;
              });
            }
          }
          break;
        default:
          setState(() {
            _errorMessage = 'Unsupported content type: ${widget.contentType}';
            _isLoading = false;
          });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error initializing content: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    _audioPlayer?.dispose();
    _webViewController = null;
    // Reset orientation to portrait when disposing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Show system UI when leaving
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  // Toggle screen orientation and fullscreen mode
  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
    });

    if (_isLandscape) {
      // Hide system UI for fullscreen experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Show system UI when returning to portrait
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Conditionally show AppBar - hide in landscape mode
      appBar: _isLandscape ? null : AppBar(
        backgroundColor: const Color(0XFF78A02A),
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textDirection: TextDirection.ltr,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isLandscape ? Icons.screen_lock_portrait : Icons.screen_rotation,
              color: Colors.white,
            ),
            onPressed: _toggleOrientation,
            tooltip: _isLandscape ? 'Switch to Portrait' : 'Switch to Landscape',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          _errorMessage != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.w,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                      _isInitialized = false;
                    });
                    _initializeContent();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00AFEE),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
              : _isLoading
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Color(0xFF8CC13F)),
                SizedBox(height: 16),
                Text('Loading content...'),
              ],
            ),
          )
              : !_isInitialized
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF8CC13F)))
              : _buildContent(),

          // Floating action button for landscape mode (to show controls)
          if (_isLandscape)
            Positioned(
              top: 40,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    ),
                    IconButton(
                      icon: const Icon(Icons.screen_lock_portrait, color: Colors.white),
                      onPressed: _toggleOrientation,
                      tooltip: 'Switch to Portrait',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (widget.contentType) {
      case 'video':
        return Column(
          children: [
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
            VideoProgressIndicator(_videoController!, allowScrubbing: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () {
                    setState(() {
                      _videoController!.value.isPlaying
                          ? _videoController!.pause()
                          : _videoController!.play();
                    });
                  },
                ),
              ],
            ),
          ],
        );
      case 'youtube':
        return _youtubeController != null
            ? YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          onReady: () {
            _youtubeController!.play();
          },
        )
            : Center(
          child: Text(
            'Failed to load YouTube video',
            style: TextStyle(fontSize: 16.sp, color: Colors.red),
          ),
        );
      case 'image':
        return Center(
          child: CachedNetworkImage(
            imageUrl: widget.source,
            placeholder: (context, url) => const CircularProgressIndicator(color: Color(0XFF8CC13F),),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
          ),
        );
      case 'audio':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Playing: ${widget.title}',
              style: TextStyle(fontSize: 18.sp, fontFamily: 'Gilroy'),
            ),
            SizedBox(height: 20.h),
            StreamBuilder<Duration?>(
              stream: _audioPlayer!.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = _audioPlayer!.duration ?? Duration.zero;
                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        _audioPlayer!.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Text(
                      '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / '
                          '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    _audioPlayer!.playing ? Icons.pause : Icons.play_arrow,
                  ),
                  onPressed: () {
                    setState(() {
                      _audioPlayer!.playing ? _audioPlayer!.pause() : _audioPlayer!.play();
                    });
                  },
                ),
              ],
            ),
          ],
        );
      case 'pdf':
        return SfPdfViewer.network(widget.source);
      case 'text':
        return SingleChildScrollView(
          child: Html(
            data: widget.source,
            style: {
              'body': Style(
                fontSize: FontSize(16.sp),
                fontFamily: 'Gilroy',
                color: Colors.black,
              ),
            },
          ),
        );
      case 'webview':
        return _webViewController != null
            ? WebViewWidget(controller: _webViewController!)
            : const Center(child: Text('Failed to initialize WebView'));
      default:
        return const Center(child: Text('Unsupported content type'));
    }
  }
}