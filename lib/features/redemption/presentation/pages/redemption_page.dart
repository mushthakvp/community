import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/redemption_provider.dart';
import '../widgets/redemption_card_widget.dart';
import '../widgets/transaction_filter_widget.dart';
import '../widgets/transaction_list_widget.dart';

class RedemptionPage extends StatefulWidget {
  const RedemptionPage({super.key});

  @override
  State<RedemptionPage> createState() => _RedemptionPageState();
}

class _RedemptionPageState extends State<RedemptionPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RedemptionProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      context.read<RedemptionProvider>().getTransactions(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.black, Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<RedemptionProvider>().refresh(),
            color: AppConstants.appPrimaryColor,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                const SliverToBoxAdapter(
                  child: CommonAppBar(
                    title: 'Redemption',
                    showBackButton: false,
                  ),
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Redemption Card
                        const RedemptionCardWidget(),

                        const SizedBox(height: 24),

                        // Transaction Filters
                        const TransactionFilterWidget(),

                        const SizedBox(height: 16),

                        // Transactions Header
                        const CommonTextWidget(
                          text: 'Transaction History',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.white,
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                // Transaction List
                Consumer<RedemptionProvider>(
                  builder: (context, provider, child) {
                    if (provider.error != null) {
                      return SliverToBoxAdapter(
                        child: _buildErrorWidget(provider.error!),
                      );
                    }

                    if (provider.isLoadingTransactions &&
                        provider.redemptionData == null) {
                      return const SliverToBoxAdapter(
                        child: LoadingWidget(
                          message: 'Loading transactions...',
                        ),
                      );
                    }

                    return const TransactionListWidget();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 12),
          CommonTextWidget(
            text: error,
            color: Colors.red,
            fontSize: 14,
            align: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<RedemptionProvider>().clearError();
              context.read<RedemptionProvider>().refresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              foregroundColor: AppConstants.black,
            ),
            child: const CommonTextWidget(
              text: 'Retry',
              color: AppConstants.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
