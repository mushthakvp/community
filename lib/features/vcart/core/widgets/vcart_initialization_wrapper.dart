import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/vcart_colors.dart';
import '../di/vcart_dependency_injection.dart';

/// Wrapper widget that ensures VCart DI is initialized before showing child widget
class VCartInitializationWrapper extends StatefulWidget {
  final Widget child;
  final String? pageName;

  const VCartInitializationWrapper({
    super.key,
    required this.child,
    this.pageName,
  });

  @override
  State<VCartInitializationWrapper> createState() =>
      _VCartInitializationWrapperState();
}

class _VCartInitializationWrapperState
    extends State<VCartInitializationWrapper> {
  bool isInitializing = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initializeVCart();
  }

  Future<void> _initializeVCart() async {
    try {
      debugPrint(
        '🚀 Initializing VCart for ${widget.pageName ?? "unknown page"}...',
      );

      // Check if already initialized
      if (VCartDI.isInitialized) {
        debugPrint('✅ VCart already initialized');
        if (mounted) {
          setState(() {
            isInitializing = false;
          });
        }
        return;
      }

      // Wait for any ongoing initialization
      if (VCartDI.isInitializing) {
        debugPrint('⏳ VCart initialization in progress, waiting...');
        while (VCartDI.isInitializing) {
          await Future.delayed(const Duration(milliseconds: 50));
        }
        if (mounted) {
          setState(() {
            isInitializing = false;
          });
        }
        return;
      }

      // Initialize VCart DI
      await VCartDI.init();

      debugPrint('✅ VCart initialization completed successfully');

      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('❌ VCart initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          isInitializing = false;
          error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isInitializing) {
      return _buildLoadingScreen();
    }

    if (error != null) {
      return _buildErrorScreen();
    }

    return widget.child;
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: VCartColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: VCartColors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Initializing ${widget.pageName ?? "VCart"}...',
              style: const TextStyle(
                color: VCartColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: VCartColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: VCartColors.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to initialize VCart',
                style: TextStyle(
                  color: VCartColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error ?? 'Unknown error occurred',
                style: const TextStyle(
                  color: VCartColors.textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isInitializing = true;
                    error = null;
                  });
                  _initializeVCart();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: VCartColors.primary,
                  foregroundColor: VCartColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Retry'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Navigate back or to home
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    // Navigate to main app home
                    Get.offAllNamed('/home');
                  }
                },
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: VCartColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mixin to add VCart initialization support to pages
mixin VCartInitializationMixin<T extends StatefulWidget> on State<T> {
  bool _vcartInitialized = false;
  bool _vcartInitializing = false;
  String? _vcartError;

  bool get isVCartInitialized => _vcartInitialized;
  bool get isVCartInitializing => _vcartInitializing;
  String? get vcartError => _vcartError;

  Future<void> ensureVCartInitialized() async {
    if (_vcartInitialized) return;
    if (_vcartInitializing) {
      while (_vcartInitializing) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }

    _vcartInitializing = true;
    _vcartError = null;

    try {
      if (!VCartDI.isInitialized) {
        await VCartDI.init();
      }

      _vcartInitialized = true;
      debugPrint('✅ VCart ensured for ${widget.runtimeType}');
    } catch (e) {
      _vcartError = e.toString();
      debugPrint('❌ VCart initialization failed for ${widget.runtimeType}: $e');
      rethrow;
    } finally {
      _vcartInitializing = false;
    }
  }

  Widget buildWithVCartCheck(Widget Function() builder) {
    if (_vcartInitializing) {
      return const Center(
        child: CircularProgressIndicator(color: VCartColors.primary),
      );
    }

    if (_vcartError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: VCartColors.error),
            const SizedBox(height: 8),
            Text(
              'VCart initialization failed',
              style: const TextStyle(color: VCartColors.textPrimary),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _vcartError = null;
                });
                ensureVCartInitialized();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!_vcartInitialized) {
      // Auto-initialize on first build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ensureVCartInitialized().then((_) {
          if (mounted) setState(() {});
        });
      });
      return const Center(
        child: CircularProgressIndicator(color: VCartColors.primary),
      );
    }

    return builder();
  }
}
