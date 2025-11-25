import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../theme/app_colors.dart';

class AiCoachPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isLooping;

  const AiCoachPlayer({
    super.key,
    required this.videoUrl,
    this.isLooping = true,
  });

  @override
  State<AiCoachPlayer> createState() => _AiCoachPlayerState();
}

class _AiCoachPlayerState extends State<AiCoachPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: widget.isLooping,
        showControls: false, // Hide default controls for "Hologram" look
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'COACH OFFLINE',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.alertRed),
            ),
          );
        },
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing AI Coach: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.neonGreen),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.neonGreen.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonGreen.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The Video
          Chewie(controller: _chewieController!),

          // "Hologram" Scanlines Overlay
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.neonGreen.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
