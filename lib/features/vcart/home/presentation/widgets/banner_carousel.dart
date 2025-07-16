import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide Banner;

import '../../../core/constants/vcart_colors.dart';
import '../../../core/constants/vcart_constants.dart';
import '../../domain/entities/banner.dart';

class BannerCarousel extends StatefulWidget {
  final List<Banner> banners;
  final Function(Banner) onBannerTap;

  const BannerCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    final activeBanners = widget.banners
        .where((banner) => banner.isActive)
        .toList();
    if (activeBanners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: activeBanners.length,
          options: CarouselOptions(
            height: 160,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: VCartConstants.mediumAnimation,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = activeBanners[index];
            return BannerItem(
              banner: banner,
              onTap: () => widget.onBannerTap(banner),
            );
          },
        ),
        const SizedBox(height: 12),
        if (activeBanners.length > 1) _buildIndicators(activeBanners.length),
      ],
    );
  }

  Widget _buildIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? VCartColors.primary
                : VCartColors.textSecondary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class BannerItem extends StatelessWidget {
  final Banner banner;
  final VoidCallback onTap;

  const BannerItem({super.key, required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: VCartConstants.defaultPadding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(VCartConstants.defaultRadius),
          child: CachedNetworkImage(
            imageUrl: banner.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (context, url) => Container(
              color: VCartColors.surface,
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: VCartColors.textSecondary,
                  size: 32,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: VCartColors.surface,
              child: const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: VCartColors.textSecondary,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
