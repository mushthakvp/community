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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A1A),
            const Color(0xFF2A2A2A).withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainContent(),
                const SizedBox(height: 16),
                _buildStatusSection(),
                if (ad.isRejected &&
                    ad.rejectionReason?.isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  _buildRejectionReason(),
                ],
              ],
            ),
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
        const SizedBox(width: 16),
        Expanded(child: _buildContentSection()),
      ],
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppConstants.white.withOpacity(0.05),
        border: Border.all(
          color: AppConstants.appPrimaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ad.primaryImage.isNotEmpty
            ? CommonImageWidget(
                imageUrl: ad.primaryImage,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : Container(
                color: AppConstants.white.withOpacity(0.1),
                child: Icon(
                  Icons.image_outlined,
                  color: AppConstants.white.withOpacity(0.5),
                  size: 40,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget(
                    text: ad.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.white,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.appPrimaryColor,
                          AppConstants.appPrimaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.appPrimaryColor.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CommonTextWidget(
                      text: ad.formattedPrice,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.black,
                    ),
                  ),
                ],
              ),
            ),
            _buildActionButton(),
          ],
        ),
        const SizedBox(height: 12),
        _buildDetailsRow(),
      ],
    );
  }

  Widget _buildActionButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: PopupMenuButton<String>(
        onSelected: _handleMenuSelection,
        color: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: isOperating
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppConstants.appPrimaryColor,
                    ),
                  ),
                )
              : const Icon(
                  Icons.more_vert,
                  color: AppConstants.white,
                  size: 20,
                ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: AppConstants.appPrimaryColor,
                  size: 18,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Edit listing',
                  style: TextStyle(color: AppConstants.white),
                ),
              ],
            ),
          ),
          if (!ad.isSold)
            PopupMenuItem(
              value: 'sold',
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Mark as sold',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                const SizedBox(width: 12),
                const Text(
                  'Delete listing',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow() {
    final details = <String>[];

    if (ad.brandModel.isNotEmpty) {
      details.add(ad.brandModel);
    }

    if (ad.createdAt != null) {
      final formatter = DateFormat('dd MMM yyyy');
      details.add('Added ${formatter.format(ad.createdAt!)}');
    }

    return Row(
      children: [
        Icon(
          Icons.info_outline,
          color: AppConstants.white.withOpacity(0.6),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonTextWidget(
            text: details.isNotEmpty
                ? details.join(' • ')
                : 'No additional details',
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: _getStatusColor(), size: 18),
          const SizedBox(width: 12),
          _buildStatusChip(
            label: ad.isSold ? 'Sold' : 'Available',
            color: ad.isSold ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 8),
          _buildStatusChip(label: ad.statusDisplay, color: _getStatusColor()),
          if (ad.insights.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.appPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstants.appPrimaryColor.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility,
                    color: AppConstants.appPrimaryColor,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  CommonTextWidget(
                    text: '${ad.insights.length} views',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.appPrimaryColor,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: CommonTextWidget(
        text: label,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget _buildRejectionReason() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.error_outline, color: Colors.red, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CommonTextWidget(
                  text: 'Rejection Reason:',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
                const SizedBox(height: 4),
                CommonTextWidget(
                  text: ad.rejectionReason!,
                  fontSize: 12,
                  color: Colors.red,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
