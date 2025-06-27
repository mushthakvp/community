import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/image_widget.dart';
import '../../../../core/widgets/common/spacer_widget.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/redemption_provider.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionEntity transaction;
  final int index;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RedemptionProvider>(
      builder: (context, provider, child) {
        final isExpanded = provider.transactionDetailsVisible.length > index 
            ? provider.transactionDetailsVisible[index] 
            : false;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2A2A2A).withOpacity(0.8),
                const Color(0xFF1A1A1A).withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isExpanded 
                  ? AppConstants.appPrimaryColor.withOpacity(0.3)
                  : AppConstants.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildTransactionHeader(context, provider, isExpanded),
              if (isExpanded) _buildTransactionDetails(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionHeader(
    BuildContext context,
    RedemptionProvider provider,
    bool isExpanded,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Transaction Icon/Image
          _buildTransactionIcon(),
          
          AppSpacing.horizontalMD,
          
          // Transaction Type
          Expanded(
            flex: 2,
            child: CommonTextWidget(
              text: _getTransactionTypeText(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppConstants.white,
            ),
          ),
          
          // Transaction Date
          Expanded(
            flex: 2,
            child: CommonTextWidget(
              text: _formatDate(transaction.createdAt),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppConstants.white.withOpacity(0.7),
              align: TextAlign.center,
            ),
          ),
          
          // Transaction Amount
          Expanded(
            flex: 2,
            child: CommonTextWidget(
              text: '₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppConstants.green,
              align: TextAlign.end,
            ),
          ),
          
          AppSpacing.horizontalSM,
          
          // Expand Button
          IconButton(
            onPressed: () => provider.toggleTransactionDetails(index),
            icon: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppConstants.appPrimaryColor,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionIcon() {
    if (transaction.through == "Purchase" && 
        transaction.productImage != null && 
        transaction.productImage!.isNotEmpty) {
      return CommonImageWidget(
        imageUrl: transaction.productImage,
        width: 48,
        height: 48,
        borderRadius: BorderRadius.circular(24),
      );
    }

    IconData iconData;
    Color iconColor;

    switch (transaction.through) {
      case "Claimed":
        iconData = Icons.redeem;
        iconColor = AppConstants.appPrimaryColor;
        break;
      case "Purchase":
        iconData = Icons.shopping_bag;
        iconColor = Colors.blue;
        break;
      default: // Recharge
        iconData = Icons.account_balance_wallet;
        iconColor = Colors.green;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.black.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            '',
            _getTransactionDescription(),
            isFullWidth: true,
          ),
          AppSpacing.verticalSM,
          _buildDetailRow('Status:', 'Success', valueColor: AppConstants.green),
          _buildDetailRow('Date:', _formatDate(transaction.createdAt)),
          _buildDetailRow('Time:', _formatTime(transaction.createdAt)),
          if (transaction.paymentMethod != null)
            _buildDetailRow('Payment Method:', transaction.paymentMethod!),
          _buildDetailRow('Transaction ID:', _getFormattedTransactionId()),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool isFullWidth = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            SizedBox(
              width: 120,
              child: CommonTextWidget(
                text: label,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppConstants.white.withOpacity(0.7),
              ),
            ),
            AppSpacing.horizontalSM,
          ],
          Expanded(
            child: CommonTextWidget(
              text: value,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: valueColor ?? AppConstants.white,
              align: label.isEmpty ? TextAlign.start : TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  String _getTransactionTypeText() {
    switch (transaction.through) {
      case "Purchase":
        return "Purchased";
      case "Claimed":
        return "Claimed";
      default:
        return "Recharged";
    }
  }

  String _getTransactionDescription() {
    switch (transaction.through) {
      case "Purchase":
        return transaction.productName ?? "Product Purchase";
      case "Claimed":
        return "${transaction.points ?? 0} loyalty points";
      default:
        return "Recharge of ₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}";
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  String _formatTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat('HH:mm:ss').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  String _getFormattedTransactionId() {
    final id = transaction.id;
    if (id == null || id.isEmpty) return 'N/A';
    return id.length > 10 ? id.substring(id.length - 10) : id;
  }
}
