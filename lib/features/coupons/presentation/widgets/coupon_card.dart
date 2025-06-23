// lib/features/coupons/presentation/widgets/coupon_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../data/models/coupon_model.dart';
import 'dislike_bottom_sheet.dart';

class CouponCard extends StatefulWidget {
  final CouponReward coupon;
  final VoidCallback onLike;
  final Function(String reason) onDislike;
  final VoidCallback onUse;
  final String Function(DateTime?) formatLastUsedTime;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.onLike,
    required this.onDislike,
    required this.onUse,
    required this.formatLastUsedTime,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isActionInProgress = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppConstants.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCouponCodeSection(),
          _buildContentSection(),
          _buildActionSection(),
        ],
      ),
    );
  }

  Widget _buildCouponCodeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: AppConstants.appPrimaryColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: CommonTextWidget(
                  text: widget.coupon.couponCode ?? '',
                  align: TextAlign.start,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.black,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _handleCopyCode,
                child: const Icon(
                  Icons.content_copy_outlined,
                  color: AppConstants.black,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppLogo(),
          const SizedBox(width: 14),
          Expanded(child: _buildCouponInfo()),
        ],
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: widget.coupon.app?.logo ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: const Color(0xff2A2A2A),
            child: const Icon(Icons.image, color: AppConstants.white, size: 24),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xff2A2A2A),
            child: const Icon(Icons.error, color: AppConstants.white, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: widget.coupon.description ?? '',
          align: TextAlign.start,
          fontSize: 14,
          maxLines: 2,
          fontWeight: FontWeight.w500,
          color: AppConstants.white,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: widget.coupon.app?.appName ?? '',
          align: TextAlign.start,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.7),
        ),
        const SizedBox(height: 12),
        _buildUsageInfo(),
      ],
    );
  }

  Widget _buildUsageInfo() {
    return Row(
      children: [
        Expanded(
          child: CommonTextWidget(
            text: 'USED ${widget.coupon.usageByUsers?.count ?? 0} Times',
            align: TextAlign.start,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E9BFF),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: CommonTextWidget(
            text: widget.formatLastUsedTime(
              widget.coupon.usageByUsers?.lastUsed,
            ),
            align: TextAlign.start,
            fontSize: 11,
            maxLines: 1,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFFF9100),
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: AppConstants.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildLikeDislikeSection(), _buildActionButtons()],
      ),
    );
  }

  Widget _buildLikeDislikeSection() {
    return Row(
      children: [
        _buildLikeButton(),
        const SizedBox(width: 4),
        CommonTextWidget(
          text: widget.coupon.likes?.toString() ?? '0',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF737373),
        ),
        const SizedBox(width: 16),
        Container(width: 1, height: 20, color: const Color(0xFF737373)),
        const SizedBox(width: 16),
        _buildDislikeButton(),
        const SizedBox(width: 4),
        CommonTextWidget(
          text: widget.coupon.dislikes?.toString() ?? '0',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF737373),
        ),
      ],
    );
  }

  Widget _buildLikeButton() {
    final isLiked = widget.coupon.isLiked ?? false;

    return GestureDetector(
      onTap: _isActionInProgress || isLiked ? null : _handleLike,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLiked ? AppConstants.appPrimaryColor.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.string(
          AppConstants.likeSvg,
          width: 16,
          height: 16,
          color: isLiked
              ? AppConstants.appPrimaryColor
              : const Color(0xFF737373),
        ),
      ),
    );
  }

  Widget _buildDislikeButton() {
    final isDisliked = widget.coupon.isDisliked ?? false;

    return GestureDetector(
      onTap: _isActionInProgress || isDisliked ? null : _handleDislike,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDisliked ? Colors.red.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.string(
          AppConstants.disLikeSvg,
          width: 16,
          height: 16,
          color: isDisliked ? Colors.red : const Color(0xFF737373),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildShopNowButton(),
        const SizedBox(width: 8),
        _buildShareButton(),
      ],
    );
  }

  Widget _buildShopNowButton() {
    return GestureDetector(
      onTap: _handleShopNow,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.appPrimaryColor),
          color: AppConstants.appPrimaryColor.withOpacity(0.1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextWidget(
              text: 'Shop Now',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppConstants.appPrimaryColor,
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_rounded,
              color: AppConstants.appPrimaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: _handleShare,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.appPrimaryColor),
          color: AppConstants.appPrimaryColor.withOpacity(0.1),
        ),
        child: const Icon(
          Icons.share_rounded,
          color: AppConstants.appPrimaryColor,
          size: 16,
        ),
      ),
    );
  }

  // Action Handlers
  void _handleCopyCode() async {
    await _animateAndExecute(() async {
      await Clipboard.setData(
        ClipboardData(text: widget.coupon.couponCode ?? ''),
      );
      widget.onUse();

      Fluttertoast.showToast(
        msg: "Copied to Clipboard!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppConstants.appPrimaryColor,
        textColor: Colors.black,
        fontSize: 14.0,
      );
    });
  }

  void _handleLike() async {
    await _animateAndExecute(() async {
      widget.onLike();
    });
  }

  void _handleDislike() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => DislikeBottomSheet(onDislike: widget.onDislike),
    );
  }

  void _handleShopNow() async {
    await _animateAndExecute(() async {
      final websiteLink = widget.coupon.app?.websiteLink ?? '';
      if (websiteLink.isNotEmpty) {
        if (await canLaunchUrl(Uri.parse(websiteLink))) {
          await launchUrl(Uri.parse(websiteLink));
          widget.onUse();
        } else {
          _showErrorToast('Unable to open website');
        }
      } else {
        _showErrorToast('Website link not available');
      }
    });
  }

  void _handleShare() async {
    await _animateAndExecute(() async {
      widget.onUse();

      final shareText =
          "${widget.coupon.description} Coupon code: ${widget.coupon.couponCode ?? ''}";
      await Share.share(shareText, subject: 'Check out this amazing coupon!');
    });
  }

  Future<void> _animateAndExecute(Future<void> Function() action) async {
    if (_isActionInProgress) return;

    setState(() => _isActionInProgress = true);

    await _animationController.forward();
    await action();
    await _animationController.reverse();

    setState(() => _isActionInProgress = false);
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
