import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../../core/constants/app_constants.dart';
import '../../../../../../core/widgets/common/text_widget.dart';
import '../../../domain/entities/post_entity.dart';

class PostCardWidget extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLike;

  const PostCardWidget({super.key, required this.post, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff0F0F0F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildImage(),
          const SizedBox(height: 16),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final timeAgo = timeago.format(post.createdAt);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              _buildUserAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget(
                      text: post.user.name,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.white,
                    ),
                    const SizedBox(height: 2),
                    CommonTextWidget(
                      text: timeAgo,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.white.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildLikeButton(),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppConstants.white.withOpacity(0.1),
      backgroundImage: post.user.profileImage != null
          ? NetworkImage(post.user.profileImage!)
          : null,
      child: post.user.profileImage == null
          ? Icon(
              Icons.person,
              color: AppConstants.white.withOpacity(0.7),
              size: 20,
            )
          : null,
    );
  }

  Widget _buildLikeButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onLike,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              post.isLiked ? Icons.favorite : Icons.favorite_border,
              color: post.isLiked
                  ? Colors.red
                  : AppConstants.white.withOpacity(0.6),
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 6),
        CommonTextWidget(
          text: '${post.likesCount}',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (post.image == null) return const SizedBox.shrink();

    final bool isPdf = _isPdfUrl(post.image!);

    return Container(
      height: 174,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppConstants.white.withOpacity(0.05),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isPdf
            ? _buildPdfPreview()
            : Image.network(
                post.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImageError();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildImageLoading();
                },
              ),
      ),
    );
  }

  Widget _buildPdfPreview() {
    return Container(
      color: AppConstants.white.withOpacity(0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 48,
            color: Colors.red.withOpacity(0.8),
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: 'PDF Document',
            fontSize: 14,
            color: AppConstants.white.withOpacity(0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: AppConstants.white.withOpacity(0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 48,
            color: AppConstants.white.withOpacity(0.5),
          ),
          const SizedBox(height: 8),
          CommonTextWidget(
            text: 'Failed to load image',
            fontSize: 12,
            color: AppConstants.white.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildImageLoading() {
    return Container(
      color: AppConstants.white.withOpacity(0.05),
      child: Center(
        child: CircularProgressIndicator(
          color: AppConstants.appPrimaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: post.title,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppConstants.white,
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: post.description,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppConstants.white.withOpacity(0.8),
          maxLines: 3,
        ),
      ],
    );
  }

  bool _isPdfUrl(String url) {
    return url.toLowerCase().contains('.pdf') ||
        url.toLowerCase().contains('pdf');
  }
}
