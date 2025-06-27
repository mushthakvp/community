import 'dart:async';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../providers/promos_provider.dart';

class VideoPlayerNew extends StatefulWidget {
  final String videoUrl;
  final bool isYoutube;
  final int points;

  const VideoPlayerNew({
    super.key,
    required this.videoUrl,
    required this.isYoutube,
    required this.points,
  });

  @override
  State<VideoPlayerNew> createState() => _VideoPlayerNewState();
}

class _VideoPlayerNewState extends State<VideoPlayerNew> {
  YoutubePlayerController? _youtubeController;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool _isVideoCompleted = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isInitializationError = false;

  // Verification code for YouTube videos
  String _verificationCode = '';
  late int _codeDuration;
  bool _showVerificationDialog = false;
  final TextEditingController _codeController = TextEditingController();
  Timer? _verificationTimer;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializePlayer() {
    try {
      if (widget.isYoutube) {
        _initYoutubePlayer();
      } else {
        _initVideoPlayer();
      }
    } catch (e) {
      setState(() {
        _isInitializationError = true;
      });
    }
  }

  void _initYoutubePlayer() {
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
    if (videoId == null) {
      setState(() {
        _isInitializationError = true;
      });
      return;
    }

    _youtubeController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        strictRelatedVideos: true,
        showControls: false,
        showFullscreenButton: false,
        enableJavaScript: true,
        loop: false,
      ),
    );

    _youtubeController!.listen((value) {
      if (_youtubeController!.metadata.duration.inSeconds > 0) {
        _generateVerificationCode(_youtubeController!.metadata.duration);
      }

      if (value.playerState == PlayerState.ended) {
        _onVideoComplete();
      }
    });
  }

  void _initVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowPlaybackSpeedChanging: false,
        allowedScreenSleep: false,
        allowFullScreen: false,
        showControls: false,
      );

      _videoPlayerController.addListener(_onVideoStateChange);

      setState(() {
        _totalDuration = _videoPlayerController.value.duration;
      });
    } catch (e) {
      setState(() {
        _isInitializationError = true;
      });
    }
  }

  void _generateVerificationCode(Duration totalDuration) {
    if (widget.isYoutube && _verificationCode.isEmpty) {
      final random = Random();
      _verificationCode = (1000 + random.nextInt(9000)).toString();

      if (totalDuration.inSeconds > 0) {
        int minDuration = (totalDuration.inSeconds * 0.25).toInt();
        int maxDuration = (totalDuration.inSeconds * 0.75).toInt();
        _codeDuration =
            minDuration + random.nextInt(maxDuration - minDuration + 1);

        _startVerificationTimer();
      }
    }
  }

  void _startVerificationTimer() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer(Duration(seconds: _codeDuration), () {
      if (mounted && widget.isYoutube) {
        setState(() {
          _showVerificationDialog = true;
        });

        _showVerificationCodeDialog();
      }
    });
  }

  void _showVerificationCodeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppConstants.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const CommonTextWidget(
            text: 'Verification Code',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          content: CommonTextWidget(
            text: 'Remember this code: $_verificationCode',
            fontSize: 16,
            color: AppConstants.appPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _showVerificationDialog = false;
                });
              },
              child: const CommonTextWidget(
                text: 'OK',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ),
          ],
        );
      },
    );

    // Auto close after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _showVerificationDialog = false;
        });
      }
    });
  }

  void _onVideoStateChange() {
    if (_videoPlayerController.value.position >=
        _videoPlayerController.value.duration) {
      _onVideoComplete();
    }
    setState(() {
      _currentPosition = _videoPlayerController.value.position;
    });
  }

  void _onVideoComplete() {
    _verificationTimer?.cancel();

    if (widget.isYoutube) {
      _showVerificationPopup();
    } else {
      _addRewardPoints();
    }
  }

  void _showVerificationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstants.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const CommonTextWidget(
            text: 'Verification Required',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CommonTextWidget(
                text: 'Enter the code you saw during the video:',
                fontSize: 14,
                color: AppConstants.white,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppConstants.white),
                decoration: InputDecoration(
                  hintText: 'Enter 4-digit code',
                  hintStyle: TextStyle(
                    color: AppConstants.white.withOpacity(0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppConstants.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppConstants.appPrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_codeController.text.trim() == _verificationCode) {
                  Navigator.of(context).pop();
                  _addRewardPoints();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect code. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const CommonTextWidget(
                text: 'Submit',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _addRewardPoints() {
    setState(() {
      _isVideoCompleted = true;
    });

    final provider = context.read<PromosProvider>();
    provider.addRewardPoints(
      points: widget.points,
      action: 'Watch promo video',
      context: context,
    );
  }

  Future<bool> _onWillPop() async {
    if (!_isVideoCompleted) {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppConstants.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const CommonTextWidget(
            text: 'Cannot Exit',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.white,
          ),
          content: const CommonTextWidget(
            text:
                'You cannot get loyalty points without watching the full video.',
            fontSize: 14,
            color: AppConstants.white,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const CommonTextWidget(
                text: 'Continue Watching',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const CommonTextWidget(
                text: 'Exit',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    }
    return true;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _disposeControllers() {
    _verificationTimer?.cancel();
    _codeController.dispose();

    if (widget.isYoutube && _youtubeController != null) {
      _youtubeController?.close();
    } else {
      _videoPlayerController.removeListener(_onVideoStateChange);
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializationError) {
      return _buildErrorScreen();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.isYoutube && _youtubeController != null
          ? _buildYouTubePlayer()
          : _buildRegularVideoPlayer(),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: AppBar(
        title: const CommonTextWidget(
          text: 'Video Error',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        backgroundColor: AppConstants.black,
        foregroundColor: AppConstants.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 64),
            SizedBox(height: 16),
            CommonTextWidget(
              text: 'Unable to load video',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
            SizedBox(height: 8),
            CommonTextWidget(
              text: 'Please check your internet connection and try again',
              fontSize: 14,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYouTubePlayer() {
    return YoutubePlayerScaffold(
      controller: _youtubeController!,
      builder: (context, player) {
        return Scaffold(
          backgroundColor: AppConstants.black,
          appBar: AppBar(
            backgroundColor: AppConstants.black,
            foregroundColor: AppConstants.white,
            title: const CommonTextWidget(
              text: 'YouTube Video',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Stack(
                    children: [
                      player,
                      if (_showVerificationDialog)
                        _buildVerificationCodeOverlay(),
                    ],
                  ),
                ),
              ),
              _buildVideoControls(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRegularVideoPlayer() {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: AppBar(
        backgroundColor: AppConstants.black,
        foregroundColor: AppConstants.white,
        title: const CommonTextWidget(
          text: 'Promo Video',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _chewieController != null
                  ? Chewie(controller: _chewieController!)
                  : const CircularProgressIndicator(
                      color: AppConstants.appPrimaryColor,
                    ),
            ),
          ),
          _buildVideoControls(),
        ],
      ),
    );
  }

  Widget _buildVerificationCodeOverlay() {
    return Positioned.fill(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            _verificationCode,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 72,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppConstants.black,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextWidget(
                text: _formatDuration(_currentPosition),
                color: AppConstants.white,
                fontSize: 14,
              ),
              CommonTextWidget(
                text: _formatDuration(_totalDuration),
                color: AppConstants.white,
                fontSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _totalDuration.inSeconds > 0
                ? _currentPosition.inSeconds / _totalDuration.inSeconds
                : 0,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppConstants.appPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
