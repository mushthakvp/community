import 'package:flutter/material.dart';

import '../bridge/vcart_getx_bridge.dart';

class VCartProviderBridge extends StatefulWidget {
  final Widget child;

  const VCartProviderBridge({super.key, required this.child});

  @override
  State<VCartProviderBridge> createState() => _VCartProviderBridgeState();
}

class _VCartProviderBridgeState extends State<VCartProviderBridge> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VCartGetXBridge.initializeVCartDependencies(context);
    });
  }

  @override
  void dispose() {
    VCartGetXBridge.disposeVCartDependencies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
