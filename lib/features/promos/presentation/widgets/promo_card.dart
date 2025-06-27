import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/promo_entity.dart';
import 'video_player/video_player_new.dart';

class PromoCard extends StatelessWidget {
  final PromoEntity promo;

  const PromoCard({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToVideoPlayer(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.appPrimaryColor,
              AppConstants.green,
              AppConstants.appPrimaryColor,
              AppConstants.red,
            ],
          ),
        ),
        child: Column(
          children: [
            // Cover Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: promo.coverImage,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppConstants.appPrimaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.error,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    // Play Button Overlay
                    Positioned.fill(
                      child: Center(
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: AppConstants.white.withOpacity(0.5),
                          child: const Icon(
                            Icons.play_circle_outline,
                            color: AppConstants.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Points Information
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: CommonTextWidget(
                    text:
                        "Watch and earn ${promo.loyaltyPoints} Loyalty points",
                    color: AppConstants.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                    align: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToVideoPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerNew(
          videoUrl: promo.videoUrl,
          isYoutube: promo.isYoutube,
          points: promo.loyaltyPoints,
        ),
      ),
    );
  }
}
