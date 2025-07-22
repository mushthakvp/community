import 'package:flutter/material.dart';

import '../bindings/vcart_order_history_bindings.dart';

class VCartOrderHistoryInitializationWrapper extends StatefulWidget {
  final Widget child;
  final String? pageName;
  final bool isOrderDetails;

  const VCartOrderHistoryInitializationWrapper({
    super.key,
    required this.child,
    this.pageName,
    this.isOrderDetails = false,
  });

  @override
  State<VCartOrderHistoryInitializationWrapper> createState() =>
      _VCartOrderHistoryInitializationWrapperState();
}

class _VCartOrderHistoryInitializationWrapperState
    extends State<VCartOrderHistoryInitializationWrapper> {
  bool isInitializing = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _initializeOrderHistory();
  }

  Future<void> _initializeOrderHistory() async {
    try {
      if (widget.isOrderDetails) {
        final binding = VCartOrderDetailsBinding();
        await binding.dependencies();
      } else {
        final binding = VCartOrderHistoryBinding();
        await binding.dependencies();
      }

      if (mounted) {
        setState(() {
          isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Order History initialization failed: $e');
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
      return Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFFF0B90A),
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading ${widget.pageName ?? "page"}...',
                style: const TextStyle(color: Color(0xFFACACAC), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF000000),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFF75555),
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load page',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isInitializing = true;
                    error = null;
                  });
                  _initializeOrderHistory();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
