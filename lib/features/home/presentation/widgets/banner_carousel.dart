import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/home_provider.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final banners = provider.userDetails?.banners ?? [];

        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: CarouselSlider.builder(
            itemCount: banners.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final banner = banners[index];
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: banner.image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SkeletonAnimation(
                      shimmerColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppConstants.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppConstants.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            color: AppConstants.white.withOpacity(0.5),
                            size: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image not available',
                            style: TextStyle(
                              color: AppConstants.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 200,
              autoPlay: banners.length > 1,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              viewportFraction: 0.9,
              enableInfiniteScroll: banners.length > 1,
              scrollDirection: Axis.horizontal,
              pauseAutoPlayOnTouch: true,
              pauseAutoPlayOnManualNavigate: true,
              pauseAutoPlayInFiniteScroll: false,
            ),
          ),
        );
      },
    );
  }
}
