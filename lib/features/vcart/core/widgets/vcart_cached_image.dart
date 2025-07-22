import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/vcart_colors.dart';
import '../constants/vcart_constants.dart';

class VCartCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? placeholder;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;
  final FilterQuality filterQuality;

  const VCartCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.onTap,
    this.backgroundColor,
    this.errorWidget,
    this.loadingWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.filterQuality = FilterQuality.low,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildCachedImage();

    // Apply border radius if provided
    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    // Add container with background color if provided
    if (backgroundColor != null || width != null || height != null) {
      imageWidget = Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: imageWidget,
      );
    }

    // Add tap functionality if provided
    if (onTap != null) {
      imageWidget = GestureDetector(onTap: onTap, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildCachedImage() {
    // Handle empty or invalid URLs
    final validImageUrl = _getValidImageUrl();

    return CachedNetworkImage(
      imageUrl: validImageUrl,
      width: width,
      height: height,
      fit: fit,
      filterQuality: filterQuality,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 300),
      fadeOutDuration: fadeOutDuration ?? const Duration(milliseconds: 300),
      placeholder: (context, url) => loadingWidget ?? _buildLoadingWidget(),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            filterQuality: filterQuality,
          ),
        ),
      ),
    );
  }

  String _getValidImageUrl() {
    if (imageUrl.isEmpty || !_isValidUrl(imageUrl)) {
      return VCartConstants.placeholderImageUrl;
    }
    return imageUrl;
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: VCartColors.surface.withOpacity(0.3),
        borderRadius: borderRadius,
      ),
      child: Center(child: _buildLoadingIndicator()),
    );
  }

  Widget _buildLoadingIndicator() {
    // Use a shimmer-like effect for loading
    return Container(
      width: (width ?? 100) * 0.6,
      height: (height ?? 100) * 0.6,
      decoration: BoxDecoration(
        color: VCartColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.image_outlined,
        color: VCartColors.textSecondary,
        size: 24,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: VCartColors.surface.withOpacity(0.3),
        borderRadius: borderRadius,
        border: Border.all(
          color: VCartColors.border.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: VCartColors.textSecondary.withOpacity(0.5),
              size: _getErrorIconSize(),
            ),
            if (_shouldShowErrorText()) ...[
              const SizedBox(height: 4),
              Text(
                'Image not available',
                style: TextStyle(
                  color: VCartColors.textSecondary.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _getErrorIconSize() {
    if (width != null && height != null) {
      final minDimension = width! < height! ? width! : height!;
      return (minDimension * 0.4).clamp(16.0, 48.0);
    }
    return 32.0;
  }

  bool _shouldShowErrorText() {
    if (width != null && height != null) {
      return width! > 80 && height! > 80;
    }
    return true;
  }
}
