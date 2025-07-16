import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../providers/profile_provider.dart';
import '../widgets/loyalty_card_widget.dart';
import '../widgets/point_transaction_item.dart';
import '../widgets/shimmer_widgets.dart';

class LoyaltyPointsPage extends StatefulWidget {
  const LoyaltyPointsPage({super.key});

  @override
  State<LoyaltyPointsPage> createState() => _LoyaltyPointsPageState();
}

class _LoyaltyPointsPageState extends State<LoyaltyPointsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      provider.getLoyaltyCard();
      provider.getPointTransactions(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProfileProvider>().getPointTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: const CommonAppBar(title: 'Loyalty Points'),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildLoyaltyCard(provider),
              _buildTabBar(provider),
              Expanded(child: _buildTransactionsList(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoyaltyCard(ProfileProvider provider) {
    if (provider.loyaltyCardState == ProfileState.loading &&
        provider.loyaltyCard == null) {
      return const LoyaltyCardShimmer();
    }

    return LoyaltyCardWidget(
      loyaltyCard: provider.loyaltyCard,
      onClaimPressed: () => _claimLoyaltyPoints(provider),
      isLoading: false, // You can add claim loading state if needed
    );
  }

  Widget _buildTabBar(ProfileProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) => provider.selectTab(index),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppConstants.appPrimaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        labelColor: AppConstants.black,
        labelStyle: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: AppConstants.white,
        tabs: const [
          Tab(text: 'Claimed'),
          Tab(text: 'Earned'),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(ProfileProvider provider) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTransactionsTab(provider, isEarnTab: false),
        _buildTransactionsTab(provider, isEarnTab: true),
      ],
    );
  }

  Widget _buildTransactionsTab(
    ProfileProvider provider, {
    required bool isEarnTab,
  }) {
    if (provider.transactionsState == ProfileState.loading &&
        provider.transactions.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => const TransactionItemShimmer(),
      );
    }

    if (provider.transactions.isEmpty) {
      return _buildEmptyState(isEarnTab);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          provider.transactions.length +
          (provider.transactionsState == ProfileState.loading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < provider.transactions.length) {
          return PointTransactionItem(
            transaction: provider.transactions[index],
            isEarnType: isEarnTab,
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                color: AppConstants.appPrimaryColor,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildEmptyState(bool isEarnTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isEarnTab ? Icons.stars_outlined : Icons.wallet_outlined,
            size: 80,
            color: AppConstants.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          CommonTextWidget(
            text: isEarnTab ? 'No earned points yet' : 'No claimed points yet',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.white.withOpacity(0.7),
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: isEarnTab
                ? 'Start earning points by participating in activities'
                : 'Claim your loyalty points when you have enough',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.5),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _claimLoyaltyPoints(ProfileProvider provider) {
    final loyaltyCard = provider.loyaltyCard;
    if (loyaltyCard == null || loyaltyCard.loyaltyPoints < 5000) {
      context.showErrorSnackBar(
        'You need at least 5000 loyalty points to claim',
      );
      return;
    }

    provider.claimLoyaltyPoints().then((_) {
      if (provider.loyaltyCardError != null) {
        context.showErrorSnackBar(provider.loyaltyCardError!);
      } else {
        context.showSuccessSnackBar('Loyalty points claimed successfully!');
      }
    });
  }
}
