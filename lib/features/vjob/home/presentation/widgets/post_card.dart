import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onLike;

  const PostCard({super.key, required this.post, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: post.user.profileImage != null
                  ? CachedNetworkImageProvider(post.user.profileImage!)
                  : null,
              backgroundColor: const Color(0xFF2A2A2A),
              child: post.user.profileImage == null
                  ? const Icon(
                      Icons.person,
                      color: AppConstants.white,
                      size: 20,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget(
                  text: post.user.name,
                  color: AppConstants.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                CommonTextWidget(
                  text: timeago.format(post.createdAt),
                  color: AppConstants.white.withOpacity(0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: onLike,
              child: Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                color: post.isLiked
                    ? Colors.red
                    : AppConstants.white.withOpacity(0.6),
                size: 20,
              ),
            ),
            const SizedBox(width: 6),
            CommonTextWidget(
              text: '${post.likesCount}',
              color: AppConstants.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    final isPdf = post.image.toLowerCase().endsWith('.pdf');

    return Container(
      height: 174,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isPdf
            ? Container(
                color: const Color(0xFF2A2A2A),
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: AppConstants.white,
                  size: 48,
                ),
              )
            : CachedNetworkImage(
                imageUrl: post.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xFF2A2A2A),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.appPrimaryColor,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xFF2A2A2A),
                  child: const Icon(
                    Icons.image,
                    color: AppConstants.white,
                    size: 48,
                  ),
                ),
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
          color: AppConstants.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: post.description,
          color: AppConstants.white.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
