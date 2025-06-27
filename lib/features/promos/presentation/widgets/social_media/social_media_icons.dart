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
          provider.socialMediaList[0], // YouTube
          socialLinks.youtubeChannel,
          provider,
        ),
        _buildSocialMediaColumn(
          context,
          provider.socialMediaList[1], // Facebook
          socialLinks.facebook,
          provider,
        ),
        _buildSocialMediaColumn(
          context,
          provider.socialMediaList[2], // Instagram
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
      // Try to open the native app first, then fallback to web
      final appUrl = _getAppUrl(item.name, url);
      final webUrl = _getWebUrl(item.name, url);

      try {
        // First try to open the native app
        await provider.launchUrl(appUrl);

        // Show success message and add reward points
        _showSuccessMessage(context, item.name);
        await provider.addRewardPoints(
          points: item.points,
          action: 'Subscribe to ${item.name}',
          context: context,
        );
      } catch (e) {
        try {
          // If app fails, try web version
          await provider.launchUrl(webUrl);

          // Show success message and add reward points
          _showSuccessMessage(context, item.name);
          await provider.addRewardPoints(
            points: item.points,
            action: 'Subscribe to ${item.name}',
            context: context,
          );
        } catch (webError) {
          // Show error message
          _showErrorMessage(context, item.name);
        }
      }
    } else {
      _showErrorMessage(context, item.name, isLinkMissing: true);
    }
  }

  String _getAppUrl(String platform, String url) {
    switch (platform.toLowerCase()) {
      case 'youtube':
        // Extract channel ID or username from URL
        if (url.contains('channel/')) {
          final channelId = url.split('channel/').last.split('/').first;
          return 'youtube://channel/$channelId';
        } else if (url.contains('@')) {
          final username = url.split('@').last.split('/').first;
          return 'youtube://user/$username';
        } else if (url.contains('c/')) {
          final channelName = url.split('c/').last.split('/').first;
          return 'youtube://c/$channelName';
        }
        return 'youtube://';

      case 'facebook':
        // Extract page name or ID from URL
        if (url.contains('facebook.com/')) {
          final pageName = url.split('facebook.com/').last.split('/').first;
          return 'fb://page/$pageName';
        }
        return 'fb://';

      case 'instagram':
        // Extract username from URL
        if (url.contains('instagram.com/')) {
          final username = url.split('instagram.com/').last.split('/').first;
          return 'instagram://user?username=$username';
        }
        return 'instagram://';

      default:
        return url;
    }
  }

  String _getWebUrl(String platform, String url) {
    // Return the original URL as web fallback
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      // Add https if missing
      return 'https://$url';
    }
  }

  void _showSuccessMessage(BuildContext context, String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('Opened $platform successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(
    BuildContext context,
    String platform, {
    bool isLinkMissing = false,
  }) {
    final message = isLinkMissing
        ? '$platform link not available'
        : 'Could not open $platform. Please check if the app is installed.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
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
    final bool hasUrl = url != null && url!.isNotEmpty;

    return GestureDetector(
      onTap: hasUrl ? onTap : () => _showNoLinkMessage(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasUrl
                    ? AppConstants.white.withOpacity(0.1)
                    : AppConstants.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasUrl
                      ? AppConstants.appPrimaryColor.withOpacity(0.3)
                      : AppConstants.white.withOpacity(0.1),
                ),
                boxShadow: hasUrl
                    ? [
                        BoxShadow(
                          color: AppConstants.appPrimaryColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Opacity(
                opacity: hasUrl ? 1.0 : 0.5,
                child: SvgPicture.string(item.icon, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 6),
            CommonTextWidget(
              text: item.name,
              align: TextAlign.center,
              color: hasUrl ? color : color.withOpacity(0.5),
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ],
        ),
      ),
    );
  }

  void _showNoLinkMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} link not available'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
