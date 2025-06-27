import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/social_links_entity.dart';
import '../../providers/promos_provider.dart';

class SocialMediaIcons extends StatelessWidget {
  final SocialLinksEntity socialLinks;

  const SocialMediaIcons({super.key, required this.socialLinks});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PromosProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSocialMediaColumn(
          context,
          provider.socialMediaList[0],
          socialLinks.youtubeChannel,
          provider,
        ),
        _buildSocialMediaColumn(
          context,
          provider.socialMediaList[1],
          socialLinks.facebook,
          provider,
        ),
        _buildSocialMediaColumn(
          context,
          provider.socialMediaList[2],
          socialLinks.instagram,
          provider,
        ),
      ],
    );
  }

  Widget _buildSocialMediaColumn(
    BuildContext context,
    SocialMediaItem item,
    String url,
    PromosProvider provider,
  ) {
    return Column(
      children: [
        SocialMediaIconWidget(
          url: url,
          item: item,
          onTap: () => _handleSocialMediaTap(context, url, item, provider),
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: "Get ${item.points} Loyalty Points",
          color: AppConstants.appPrimaryColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          align: TextAlign.center,
        ),
      ],
    );
  }

  void _handleSocialMediaTap(
    BuildContext context,
    String url,
    SocialMediaItem item,
    PromosProvider provider,
  ) async {
    if (url.isNotEmpty) {
      // Launch URL
      await provider.launchUrl(url);

      // Add reward points
      await provider.addRewardPoints(
        points: item.points,
        action: 'Subscribe to ${item.name}',
        context: context,
      );
    }
  }
}

class SocialMediaIconWidget extends StatelessWidget {
  final double height;
  final double width;
  final double fontSize;
  final SocialMediaItem item;
  final String? url;
  final Color color;
  final FontWeight fontWeight;
  final VoidCallback? onTap;

  const SocialMediaIconWidget({
    super.key,
    required this.item,
    this.url,
    this.height = 40,
    this.width = 40,
    this.fontSize = 14,
    this.color = AppConstants.white,
    this.fontWeight = FontWeight.w400,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppConstants.appPrimaryColor.withOpacity(0.3),
              ),
            ),
            child: SvgPicture.string(item.icon, fit: BoxFit.contain),
          ),
          const SizedBox(height: 6),
          CommonTextWidget(
            text: item.name,
            align: TextAlign.center,
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ],
      ),
    );
  }
}
