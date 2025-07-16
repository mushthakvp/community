import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../providers/vhub_provider.dart';
import '../widgets/vhub_navigation_widget.dart';

class VHubHomePage extends StatefulWidget {
  const VHubHomePage({super.key});

  @override
  State<VHubHomePage> createState() => _VHubHomePageState();
}

class _VHubHomePageState extends State<VHubHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VHubProvider>().loadIdeas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'V-Hub', showBackButton: true),
      body: const VHubNavigationWidget(),
    );
  }
}
