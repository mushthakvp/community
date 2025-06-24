// lib/features/coupons/presentation/widgets/coupon_card_optimized.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/coupon_entity.dart';
import 'dislike_reason_dialog.dart';

class CouponCardOptimized extends StatefulWidget {
  final CouponEntity coupon;
  final VoidCallback onLike;
  final Function(String reason) onDislike;
  final VoidCallback onUse;
  final String Function(DateTime?) formatTime;

  const CouponCardOptimized({
    super.key,
    required this.coupon,
    required this.onLike,
    required this.onDislike,
    required this.onUse,
    required this.formatTime,
  });

  @override
  State<CouponCardOptimized> createState() => _CouponCardOptimizedState();
}

class _CouponCardOptimizedState extends State<CouponCardOptimized>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.fastAnimationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: _buildCard(),
        );
      },
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), _buildContent(), _buildActions()],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.appPrimaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.defaultBorderRadius),
          topRight: Radius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonTextWidget(
              text: widget.coupon.couponCode,
              color: AppConstants.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: _copyToClipboard,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.content_copy,
                color: AppConstants.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppLogo(),
          const SizedBox(width: 16),
          Expanded(child: _buildCouponInfo()),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: widget.coupon.app.logo,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(
              color: AppConstants.appPrimaryColor,
            ),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.image, color: AppConstants.white),
        ),
      ),
    );
  }

  Widget _buildCouponInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: widget.coupon.description,
          color: AppConstants.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: widget.coupon.app.name,
          color: AppConstants.white.withOpacity(0.7),
          fontSize: 12,
        ),
        const SizedBox(height: 12),
        _buildUsageInfo(),
      ],
    );
  }

  Widget _buildUsageInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CommonTextWidget(
            text: 'Used ${widget.coupon.usageCount} times',
            color: Colors.blue,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CommonTextWidget(
            text: widget.formatTime(widget.coupon.lastUsed),
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.defaultBorderRadius),
          bottomRight: Radius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      child: Row(
        children: [
          _buildLikeDislikeSection(),
          const Spacer(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildLikeDislikeSection() {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.thumb_up_outlined,
          count: widget.coupon.likes,
          isActive: widget.coupon.isLiked,
          onTap: widget.coupon.isLiked ? null : widget.onLike,
          activeColor: AppConstants.appPrimaryColor,
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.thumb_down_outlined,
          count: widget.coupon.dislikes,
          isActive: widget.coupon.isDisliked,
          onTap: widget.coupon.isDisliked ? null : _showDislikeDialog,
          activeColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    required bool isActive,
    required VoidCallback? onTap,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? activeColor : AppConstants.white.withOpacity(0.6),
            size: 20,
          ),
          const SizedBox(width: 4),
          CommonTextWidget(
            text: count.toString(),
            color: AppConstants.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        PrimaryButton(
          text: 'Shop Now',
          onPressed: _openWebsite,
          backgroundColor: Colors.transparent,
          borderColor: AppConstants.appPrimaryColor,
          textColor: AppConstants.appPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          fontSize: 12,
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _share,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppConstants.appPrimaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.share,
              color: AppConstants.appPrimaryColor,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _copyToClipboard() async {
    await _animatePress(() async {
      await Clipboard.setData(ClipboardData(text: widget.coupon.couponCode));
      widget.onUse();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Coupon code copied!')));
      }
    });
  }

  void _showDislikeDialog() {
    showDialog(
      context: context,
      builder: (context) => DislikeReasonDialog(onSubmit: widget.onDislike),
    );
  }

  void _openWebsite() {
    widget.onUse();
    // Implement URL launcher
  }

  void _share() {
    widget.onUse();
    // Implement share functionality
  }

  Future<void> _animatePress(Future<void> Function() action) async {
    await _animationController.forward();
    await action();
    await _animationController.reverse();
  }
}
