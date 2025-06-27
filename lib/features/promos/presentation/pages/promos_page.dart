import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/promos_provider.dart';
import '../widgets/loading/promos_shimmer.dart';
import '../widgets/promos_content.dart';
import '../widgets/promos_error_widget.dart';

class PromosPage extends StatefulWidget {
  const PromosPage({super.key});

  @override
  State<PromosPage> createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PromosProvider>().loadPromos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffF0B90A), Color(0xffA52EA1), AppConstants.black],
            begin: Alignment.topLeft,
            end: AlignmentDirectional.bottomCenter,
          ),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(AppConstants.promoseBg),
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<PromosProvider>().retry(),
            child: Consumer<PromosProvider>(
              builder: (context, provider, child) {
                return _buildContent(provider);
              },
            ),
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
