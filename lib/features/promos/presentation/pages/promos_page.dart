import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../../path/animated_promos_background.dart';
import '../providers/promos_provider.dart';
import '../widgets/loading/promos_shimmer.dart';
import '../widgets/promos_content.dart';
import '../widgets/promos_error_widget.dart';

class PromosPage extends StatefulWidget {
  const PromosPage({super.key});

  @override
  State<PromosPage> createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromosProvider>().loadPromos();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: AnimatedPromosBackground(
        child: RefreshIndicator(
          onRefresh: () => context.read<PromosProvider>().retry(),
          color: AppConstants.appPrimaryColor,
          backgroundColor: AppConstants.black,
          child: Consumer<PromosProvider>(
            builder: (context, provider, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SafeArea(child: _buildContent(provider)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PromosProvider provider) {
    switch (provider.status) {
      case PromosStatus.loading:
        return const PromosShimmer();

      case PromosStatus.error:
        return PromosErrorWidget(
          message: provider.errorMessage ?? 'Something went wrong',
          onRetry: provider.retry,
        );

      case PromosStatus.loaded:
        if (!provider.hasData) {
          return _buildEmptyState();
        }
        return PromosContent(promosData: provider.promosData!);

      default:
        return const Center(child: LoadingWidget());
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: AppConstants.white,
            ),
            SizedBox(height: 16),
            CommonTextWidget(
              text: 'No Promos Available',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            SizedBox(height: 8),
            CommonTextWidget(
              text: 'Check back later for new promotional content',
              fontSize: 14,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
