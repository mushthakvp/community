import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../core/constants/route_constants.dart';
import 'presentation/providers/splash_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SplashProvider>();
      provider.initializeApp().then((_) {
        _navigateToNextScreen();
      });
    });
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/animation/splah_video.mp4',
      );
      await _videoController.initialize();
      _videoController.setLooping(true);
      _videoController.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Video initialization error: $e');
      if (mounted) {
        setState(() {
          _isVideoInitialized = false;
        });
      }
    }
  }

  void _navigateToNextScreen() {
    final provider = context.read<SplashProvider>();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        if (provider.isAuthenticated) {
          context.go(RouteConstants.home);
        } else {
          context.go(RouteConstants.login);
        }
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffde56),
      body: Consumer<SplashProvider>(
        builder: (context, provider, child) {
          return _isVideoInitialized
              ? AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
