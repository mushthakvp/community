import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/image_widget.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/advertisement_entity.dart';

class ProfileAdCardWidget extends StatelessWidget {
  final AdvertisementEntity ad;
  final bool isOperating;
  final VoidCallback onDelete;
  final VoidCallback onMarkAsSold;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  const ProfileAdCardWidget({
    super.key,
    required this.ad,
    required this.isOperating,
    required this.onDelete,
    required this.onMarkAsSold,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF161616),
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppConstants.white.withOpacity(0.1), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainContent(),
              const SizedBox(height: 12),
              _buildStatusSection(),
              if (ad.isRejected && ad.rejectionReason?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                _buildRejectionReason(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageSection(),
        const SizedBox(width: 12),
        Expanded(child: _buildContentSection()),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppConstants.white.withOpacity(0.05),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ad.primaryImage.isNotEmpty
            ? CommonImageWidget(
                imageUrl: ad.primaryImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppConstants.white.withOpacity(0.1),
                child: Icon(
                  Icons.image_outlined,
                  color: AppConstants.white.withOpacity(0.5),
                  size: 32,
                ),
              ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CommonTextWidget(
                text: ad.title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildActionButton(),
          ],
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: ad.formattedPrice,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.appPrimaryColor,
        ),
        const SizedBox(height: 4),
        _buildDetailsRow(),
      ],
    );
  }

  Widget _buildActionButton() {
    return PopupMenuButton<String>(
      onSelected: _handleMenuSelection,
      color: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppConstants.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: isOperating
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConstants.appPrimaryColor,
                  ),
                ),
              )
            : const Icon(Icons.more_vert, color: AppConstants.white, size: 16),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: AppConstants.white, size: 18),
              SizedBox(width: 8),
              Text('Edit listing', style: TextStyle(color: AppConstants.white)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text('Delete listing', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        if (!ad.isSold)
          const PopupMenuItem(
            value: 'sold',
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text('Mark as sold', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsRow() {
    final details = <String>[];

    if (ad.brandModel.isNotEmpty) {
      details.add(ad.brandModel);
    }

    if (ad.createdAt != null) {
      final formatter = DateFormat('dd/MM/yyyy');
      details.add('Added ${formatter.format(ad.createdAt!)}');
    }

    return Row(
      children: [
        Expanded(
          child: CommonTextWidget(
            text: details.join(' • '),
            fontSize: 12,
            color: AppConstants.white.withOpacity(0.6),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Row(
      children: [
        _buildStatusChip(
          label: ad.isSold ? 'Sold' : 'Available',
          color: ad.isSold ? Colors.orange : Colors.green,
        ),
        const SizedBox(width: 8),
        _buildStatusChip(label: ad.statusDisplay, color: _getStatusColor()),
      ],
    );
  }

  Widget _buildStatusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: CommonTextWidget(
        text: label,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }

  Widget _buildRejectionReason() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: CommonTextWidget(
              text: 'Rejection Reason: ${ad.rejectionReason!}',
              fontSize: 12,
              color: Colors.red,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (ad.isActive) return Colors.green;
    if (ad.isRejected) return Colors.red;
    if (ad.isPending) return Colors.orange;
    return Colors.grey;
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        onEdit();
        break;
      case 'delete':
        onDelete();
        break;
      case 'sold':
        onMarkAsSold();
        break;
    }
  }
}
