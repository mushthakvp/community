import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/spin_provider.dart';
import '../widgets/spin_history_item.dart';

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
      context.read<SpinProvider>().loadSpinHistory(refresh: true);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SpinProvider>().loadSpinHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Spin History',
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: () => _refreshHistory(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF1A1A1A)],
          ),
        ),
        child: Consumer<SpinProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.spinHistory.isEmpty) {
              return const Center(child: LoadingWidget());
            }

            if (provider.hasError && provider.spinHistory.isEmpty) {
              return _buildErrorState(provider);
            }

            if (provider.spinHistory.isEmpty) {
              return _buildEmptyState();
            }

            return _buildHistoryList(provider);
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(SpinProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: 'Failed to load history',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text: provider.errorMessage ?? 'Please try again',
              fontSize: 14,
              color: Colors.grey.shade400,
              align: TextAlign.center,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _refreshHistory(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            CommonTextWidget(
              text: 'No Spin History',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
              align: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonTextWidget(
              text:
                  'Your spin history will appear here after you start playing',
              fontSize: 14,
              color: Colors.grey.shade500,
              align: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Start Spinning'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(SpinProvider provider) {
    return RefreshIndicator(
      onRefresh: () => _refreshHistory(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header stats
          SliverToBoxAdapter(child: _buildHeaderStats(provider)),

          // History list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == provider.spinHistory.length) {
                  return _buildLoadingMore(provider);
                }

                final history = provider.spinHistory[index];
                return SpinHistoryItem(
                  history: history,
                  onTap: () => _showHistoryDetails(history),
                );
              },
              childCount:
                  provider.spinHistory.length +
                  (provider.hasMoreHistory ? 1 : 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStats(SpinProvider provider) {
    final totalSpins = provider.spinHistory.fold<int>(
      0,
      (sum, history) => sum + history.totalSpins,
    );

    final totalWins = provider.spinHistory.fold<int>(
      0,
      (sum, history) => sum + history.winningSpins,
    );

    final totalPoints = provider.spinHistory.fold<int>(
      0,
      (sum, history) => sum + history.loyaltyPointsEarned,
    );

    final totalCoupons = provider.spinHistory.fold<int>(
      0,
      (sum, history) => sum + history.couponsEarned.length,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.appPrimaryColor.withOpacity(0.2),
            AppConstants.appPrimaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          CommonTextWidget(
            text: 'Your Spin Stats',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            align: TextAlign.center,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.casino,
                  label: 'Total Spins',
                  value: totalSpins.toString(),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.emoji_events,
                  label: 'Total Wins',
                  value: totalWins.toString(),
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.stars,
                  label: 'Points Earned',
                  value: totalPoints.toString(),
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.local_offer,
                  label: 'Coupons Won',
                  value: totalCoupons.toString(),
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          if (totalSpins > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  CommonTextWidget(
                    text:
                        'Win Rate: ${((totalWins / totalSpins) * 100).toStringAsFixed(1)}%',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: value,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          CommonTextWidget(
            text: label,
            fontSize: 12,
            color: Colors.grey.shade400,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMore(SpinProvider provider) {
    if (!provider.isLoadingMoreHistory) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(child: LoadingWidget()),
    );
  }

  Future<void> _refreshHistory() async {
    await context.read<SpinProvider>().loadSpinHistory(refresh: true);
  }

  void _showHistoryDetails(history) {
    showDialog(
      context: context,
      builder: (context) => _buildHistoryDetailsDialog(history),
    );
  }

  Widget _buildHistoryDetailsDialog(history) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.appPrimaryColor,
                    AppConstants.appPrimaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.history, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  CommonTextWidget(
                    text: 'Spin Details',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  CommonTextWidget(
                    text: history.formattedDate,
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Results list
                  Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: history.results.length,
                      itemBuilder: (context, index) {
                        final result = history.results[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: result.isWinning
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: result.isWinning
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                result.spinOption.rewardIcon,
                                color: result.spinOption.rewardColor,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonTextWidget(
                                      text: result.spinOption.rewardDisplayText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    if (result
                                        .spinOption
                                        .description
                                        .isNotEmpty)
                                      CommonTextWidget(
                                        text: result.spinOption.description,
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                        maxLines: 2,
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                result.isWinning
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: result.isWinning
                                    ? Colors.green
                                    : Colors.grey,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.appPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
