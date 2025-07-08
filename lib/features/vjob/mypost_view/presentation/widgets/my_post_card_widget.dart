import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../domain/entities/my_post_entity.dart';

class MyPostCardWidget extends StatelessWidget {
  final MyPostEntity post;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const MyPostCardWidget({
    super.key,
    required this.post,
    required this.onTap,
    required this.onLike,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
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

  Widget _buildFooter() {
    return Row(
      children: [
        _buildFooterItem(icon: Icons.visibility, text: 'Views', count: 0),
        const SizedBox(width: 16),
        _buildFooterItem(icon: Icons.comment, text: 'Comments', count: 0),
        const Spacer(),
        _buildShareButton(),
      ],
    );
  }

  Widget _buildFooterItem({
    required IconData icon,
    required String text,
    required int count,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppConstants.white.withOpacity(0.6)),
        const SizedBox(width: 4),
        CommonTextWidget(
          text: '$count',
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildShareButton() {
    return GestureDetector(
      onTap: () {
        // Handle share functionality
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.share,
          color: AppConstants.white.withOpacity(0.6),
          size: 18,
        ),
      ),
    );
  }

  bool _isPdfUrl(String url) {
    return url.toLowerCase().contains('.pdf') ||
        url.toLowerCase().contains('pdf');
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
        _buildActionButtons(),
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLikeButton(),
        const SizedBox(width: 8),
        _buildMenuButton(),
      ],
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
        const SizedBox(width: 4),
        CommonTextWidget(
          text: '${post.likesCount}',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: AppConstants.white.withOpacity(0.6),
        size: 20,
      ),
      color: const Color(0xff1A1A1A),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit, color: AppConstants.white, size: 18),
              const SizedBox(width: 8),
              const CommonTextWidget(
                text: 'Edit',
                color: AppConstants.white,
                fontSize: 14,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              const CommonTextWidget(
                text: 'Delete',
                color: Colors.red,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
    );
  }
}
