import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/promos_data.dart';
import 'promo_card.dart';
import 'social_media/social_media_icons.dart';
import 'video_cards/youtube_video_card.dart';

class PromosContent extends StatelessWidget {
  final PromosData promosData;

  const PromosContent({super.key, required this.promosData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const CommonTextWidget(
            text: 'Rewards',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppConstants.white,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),

          // YouTube Videos Section
          if (promosData.hasVideos) ...[
            const CommonTextWidget(
              text: 'YouTube Videos',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppConstants.white,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            _buildYouTubeVideosSection(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          ],

          // Social Media Section
          if (promosData.hasSocialLinks) ...[
            const CommonTextWidget(
              text: 'Subscribe and Get Loyalty Points',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppConstants.white,
              align: TextAlign.start,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SocialMediaIcons(socialLinks: promosData.socialLinks!),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],

          // Promos Section
          if (promosData.hasPromos) ...[
            const CommonTextWidget(
              text: 'Promos',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppConstants.white,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            _buildPromosGrid(),
          ],

          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        ],
      ),
    );
  }

  Widget _buildYouTubeVideosSection() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: promosData.videos.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final video = promosData.videos[index];
          return YouTubeVideoCard(video: video);
        },
      ),
    );
  }

  Widget _buildPromosGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: promosData.promos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final promo = promosData.promos[index];
        return PromoCard(promo: promo);
      },
    );
  }
}
