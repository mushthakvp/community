import 'package:flutter/material.dart';

import '../bridge/vcart_getx_bridge.dart';

class VCartProviderBridge extends StatefulWidget {
  final Widget child;

  const VCartProviderBridge({super.key, required this.child});

  @override
  State<VCartProviderBridge> createState() => _VCartProviderBridgeState();
}

class _VCartProviderBridgeState extends State<VCartProviderBridge> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
  }

  Future<void> _initializeDependencies() async {
    try {
      // Wait for the next frame to ensure context is available
      await Future.delayed(Duration.zero);

      if (mounted) {
        VCartGetXBridge.initializeVCartDependencies(context);
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle initialization error
      debugPrint('VCart initialization error: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true; // Allow rendering even if init fails
        });
      }
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      VCartGetXBridge.disposeVCartDependencies();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFF0B90A)),
        ),
      );
    }

    return widget.child;
  }
}
