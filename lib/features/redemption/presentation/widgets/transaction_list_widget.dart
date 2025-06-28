import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../../core/widgets/loading/loading_widget.dart';
import '../providers/redemption_provider.dart';
import 'transaction_item_widget.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RedemptionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.redemptionData?.transactions;

        if (transactions == null || transactions.isEmpty) {
          return SliverToBoxAdapter(child: _buildEmptyState());
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < transactions.length) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: index == transactions.length - 1 ? 100 : 12,
                  ),
                  child: TransactionItemWidget(
                    transaction: transactions[index],
                    index: index,
                  ),
                );
              } else if (provider.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: LoadingWidget(
                    message: 'Loading more transactions...',
                    size: 30,
                    showMessage: false,
                  ),
                );
              }
              return null;
            },
            childCount: transactions.length + (provider.isLoadingMore ? 1 : 0),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppConstants.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          CommonTextWidget(
            text: 'No Transactions Found',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppConstants.white.withOpacity(0.7),
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text:
                'Your transaction history will appear here once you make your first transaction.',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.5),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
