import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/vcart_colors.dart';
import '../../../core/utils/vcart_extensions.dart';
import '../controllers/product_overview_controller.dart';

class ProductImageCarousel extends StatefulWidget {
  final VCartProductOverviewController controller;

  const ProductImageCarousel({super.key, required this.controller});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentPage = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_pageListener);
    _startAutoScroll();
  }

  void _pageListener() {
    if (_pageController.hasClients) {
      final nextPage = _pageController.page?.round() ?? 0;
      if (_currentPage != nextPage) {
        setState(() {
          _currentPage = nextPage;
        });
      }
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients &&
          widget.controller.productImages.isNotEmpty) {
        if (_currentPage < widget.controller.productImages.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.controller.productImages;

    if (images.isEmpty) {
      return Container(
        width: double.infinity,
        height: context.screenHeight * 0.7,
        color: VCartColors.surface,
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            size: 64,
            color: VCartColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: context.screenHeight * 0.7,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index].orPlaceholder,
                fit: BoxFit.cover,
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
              );
            },
          ),
        ),
        const SizedBox(height: 1),
        _buildCarouselControls(images.length),
      ],
    );
  }

  Widget _buildCarouselControls(int imageCount) {
    return Padding(
      padding: EdgeInsets.only(left: context.screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: VCartColors.primaryOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${_currentPage + 1}/$imageCount',
                style: const TextStyle(
                  color: VCartColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              imageCount,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? VCartColors.primary
                      : VCartColors.primaryOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => widget.controller.toggleWishlist(context),
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: VCartColors.primaryOpacity(0.2),
              child: Icon(
                widget.controller.isAddedWishList
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.controller.isAddedWishList
                    ? VCartColors.error
                    : VCartColors.textPrimary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
