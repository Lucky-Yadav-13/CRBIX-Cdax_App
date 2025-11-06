import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? _videoCtrl;
  ChewieController? _chewieCtrl;
  YoutubePlayerController? _youtubeCtrl;
  bool _initError = false;
  bool _isYouTubeUrl = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only reinitialize if the URL actually changed
    if (oldWidget.videoUrl != widget.videoUrl) {
      _dispose();
      _initialize();
    }
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check if the URL is a YouTube URL
      final String? youtubeId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      
      if (youtubeId != null) {
        // YouTube URL - use youtube_player_flutter for mobile/APK
        if (!kIsWeb) {
          // Mobile platform - use YoutubePlayerController
          final youtubeController = YoutubePlayerController(
            initialVideoId: youtubeId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              enableCaption: true,
              loop: false,
              showLiveFullscreenButton: true,
              forceHD: false,
              useHybridComposition: true, // Important for Android
            ),
          );
          
          if (!mounted) return;
          setState(() {
            _youtubeCtrl = youtubeController;
            _isYouTubeUrl = true;
            _isInitialized = true;
          });
        } else {
          // Web platform - show message or use iframe
          if (!mounted) return;
          setState(() {
            _isYouTubeUrl = true;
            _isInitialized = true;
          });
        }
      } else {
        // Regular video URL - use video_player with chewie
        final video = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        await video.initialize();
        final chewie = ChewieController(
          videoPlayerController: video,
          autoPlay: false,
          looping: false,
          allowMuting: true,
          allowFullScreen: true,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: Colors.redAccent,
            bufferedColor: Colors.white70,
            handleColor: Colors.white,
            backgroundColor: Colors.black26,
          ),
        );
        if (!mounted) return;
        setState(() {
          _videoCtrl = video;
          _chewieCtrl = chewie;
          _isYouTubeUrl = false;
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Video initialization error: $e');
      if (!mounted) return;
      setState(() {
        _initError = true;
        _isInitialized = true;
      });
    }
  }

  void _dispose() {
    _chewieCtrl?.dispose();
    _videoCtrl?.dispose();
    _youtubeCtrl?.dispose();
    _chewieCtrl = null;
    _videoCtrl = null;
    _youtubeCtrl = null;
    _isInitialized = false;
    _initError = false;
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error state
    if (_initError) {
      return Container(
        height: 200,
        color: Colors.black12,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Unable to load video',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              SizedBox(height: 8),
              Text(
                'Please check your internet connection',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Show loading state
    if (!_isInitialized) {
      return Container(
        height: 200,
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show YouTube player
    if (_isYouTubeUrl) {
      if (kIsWeb) {
        // Web platform - show iframe or message
        return Container(
          height: 200,
          color: Colors.black,
          child: const Center(
            child: Text(
              'YouTube videos not fully supported on web.\nPlease use the mobile app.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (_youtubeCtrl != null) {
        // Mobile platform - use YoutubePlayer
        return Container(
          color: Colors.black,
          child: YoutubePlayer(
            controller: _youtubeCtrl!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.redAccent,
            progressColors: const ProgressBarColors(
              playedColor: Colors.redAccent,
              handleColor: Colors.redAccent,
            ),
            topActions: [
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _youtubeCtrl!.metadata.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
            onReady: () {
              print('YouTube player is ready');
            },
            onEnded: (data) {
              print('YouTube video ended');
            },
          ),
        );
      }
    }

    // Show regular video player
    if (!_isYouTubeUrl && _videoCtrl != null && _chewieCtrl != null) {
      final aspect = _videoCtrl!.value.isInitialized && _videoCtrl!.value.size.width > 0
          ? _videoCtrl!.value.aspectRatio
          : 16 / 9;
      return AspectRatio(
        aspectRatio: aspect,
        child: Chewie(controller: _chewieCtrl!),
      );
    }

    // Fallback loading state
    return Container(
      height: 200,
      color: Colors.black12,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}


