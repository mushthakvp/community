import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/spin_provider.dart';
import '../widgets/spin_history_widgets.dart';

class SpinHistoryPage extends StatefulWidget {
  const SpinHistoryPage({super.key});

  @override
  State<SpinHistoryPage> createState() => _SpinHistoryPageState();
}

class _SpinHistoryPageState extends State<SpinHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SpinProvider>().loadSpinHistory(isInitialLoad: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<SpinProvider>().loadSpinHistory();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildGradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              const CommonAppBar(
                title: 'Spin History',
                showBackButton: true,
                backgroundColor: Colors.transparent,
              ),
              Expanded(
                child: Consumer<SpinProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading && provider.spinHistory.isEmpty) {
                      return const Center(child: LoadingWidget());
                    }

                    if (provider.spinHistory.isEmpty) {
                      return _buildEmptyState();
                    }

                    final groupedHistory = provider.groupSpinHistoryByDate();

                    return RefreshIndicator(
                      onRefresh: () =>
                          provider.loadSpinHistory(isInitialLoad: true),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            groupedHistory.length +
                            (provider.hasMoreHistory ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == groupedHistory.length) {
                            return provider.isLoadingHistory
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: LoadingWidget()),
                                  )
                                : const SizedBox.shrink();
                          }

                          final dateKey = groupedHistory.keys.elementAt(index);
                          final spinsForDate = groupedHistory[dateKey]!;

                          return SpinHistoryDateGroup(
                            dateKey: dateKey,
                            spins: spinsForDate,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppConstants.appPrimaryColor.withOpacity(0.3),
                    AppConstants.appPrimaryColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.history,
                size: 50,
                color: AppConstants.appPrimaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const CommonTextWidget(
              text: 'No Spin History Available',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const CommonTextWidget(
              text: 'You haven\'t played any spins yet. Try your luck!',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              align: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }
}
