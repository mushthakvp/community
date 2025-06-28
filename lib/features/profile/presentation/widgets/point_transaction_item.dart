import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/point_transaction_entity.dart';

class PointTransactionItem extends StatelessWidget {
  final PointTransactionEntity transaction;
  final bool isEarnType;

  const PointTransactionItem({
    super.key,
    required this.transaction,
    this.isEarnType = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CommonTextWidget(
                  text: _getTransactionTitle(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.white,
                  maxLines: 2,
                ),
              ),
              CommonTextWidget(
                text: _getPointsOrAmountText(),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.appPrimaryColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextWidget(
                text: _getFormattedDate(),
                fontSize: 14,
                color: AppConstants.white.withOpacity(0.7),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppConstants.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const CommonTextWidget(
                  text: 'Success',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTransactionTitle() {
    if (!isEarnType) {
      return '${transaction.points} Points Claim Successful';
    }
    return transaction.through;
  }

  String _getPointsOrAmountText() {
    if (isEarnType) {
      return '+${transaction.points} pts';
    }
    return '₹ ${transaction.amount?.toStringAsFixed(2) ?? '0.00'}';
  }

  String _getFormattedDate() {
    return DateFormat('MMM dd, yyyy, HH:mm').format(transaction.createdAt);
  }
}
