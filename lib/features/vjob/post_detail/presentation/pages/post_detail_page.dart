import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../mypost_view/domain/entities/my_post_entity.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;
  final MyPostEntity? post;
  final bool owner;

  const PostDetailPage({
    super.key,
    required this.postId,
    this.post,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return Scaffold(
        backgroundColor: AppConstants.black,
        appBar: AppBar(
          backgroundColor: AppConstants.black,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppConstants.white),
          ),
          title: const CommonTextWidget(
            text: 'Post Details',
            color: AppConstants.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        body: const Center(
          child: CommonTextWidget(
            text: 'Post not found',
            color: AppConstants.white,
            fontSize: 16,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.black,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back, color: AppConstants.white),
      ),
      title: const CommonTextWidget(
        text: 'Post Details',
        color: AppConstants.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      actions: owner == true
          ? [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppConstants.white),
                color: const Color(0xff1A1A1A),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit,
                          color: AppConstants.white,
                          size: 18,
                        ),
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
                      context.push('/vjob/edit-post/${post!.id}');
                      break;
                    case 'delete':
                      _showDeleteDialog(context);
                      break;
                  }
                },
              ),
            ]
          : null,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(),
          const SizedBox(height: 20),
          _buildPostImage(),
          const SizedBox(height: 20),
          _buildPostContent(),
          const SizedBox(height: 30),
          _buildPostStats(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    final timeAgo = timeago.format(post!.createdAt);

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppConstants.white.withOpacity(0.1),
          backgroundImage: post!.user.profileImage != null
              ? NetworkImage(post!.user.profileImage!)
              : null,
          child: post!.user.profileImage == null
              ? Icon(
                  Icons.person,
                  color: AppConstants.white.withOpacity(0.7),
                  size: 24,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextWidget(
                text: post!.user.name,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppConstants.white,
              ),
              const SizedBox(height: 4),
              CommonTextWidget(
                text: timeAgo,
                fontSize: 12,
                color: AppConstants.white.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostImage() {
    if (post!.image == null) return const SizedBox.shrink();

    final bool isPdf = _isPdfUrl(post!.image!);

    return Container(
      height: 300,
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
                post!.image!,
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
            size: 64,
            color: Colors.red.withOpacity(0.8),
          ),
          const SizedBox(height: 12),
          const CommonTextWidget(
            text: 'PDF Document',
            fontSize: 16,
            color: AppConstants.white,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Handle PDF opening
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
            ),
            child: const CommonTextWidget(
              text: 'Open PDF',
              color: AppConstants.black,
              fontWeight: FontWeight.w600,
            ),
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
            size: 64,
            color: AppConstants.white.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          CommonTextWidget(
            text: 'Failed to load image',
            fontSize: 14,
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

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget(
          text: post!.title,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppConstants.white,
          maxLines: null,
        ),
        const SizedBox(height: 16),
        CommonTextWidget(
          text: post!.description,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppConstants.white.withOpacity(0.8),
          maxLines: null,
        ),
      ],
    );
  }

  Widget _buildPostStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff0F0F0F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.favorite,
            label: 'Likes',
            value: post!.likesCount.toString(),
            color: Colors.red,
          ),
          Container(
            height: 40,
            width: 1,
            color: AppConstants.white.withOpacity(0.2),
          ),
          _buildStatItem(
            icon: Icons.visibility,
            label: 'Views',
            value: '0', // You can add view count to your entity if needed
            color: Colors.blue,
          ),
          Container(
            height: 40,
            width: 1,
            color: AppConstants.white.withOpacity(0.2),
          ),
          _buildStatItem(
            icon: Icons.share,
            label: 'Shares',
            value: '0', // You can add share count to your entity if needed
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        CommonTextWidget(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        const SizedBox(height: 4),
        CommonTextWidget(
          text: label,
          fontSize: 12,
          color: AppConstants.white.withOpacity(0.6),
        ),
      ],
    );
  }

  bool _isPdfUrl(String url) {
    return url.toLowerCase().contains('.pdf') ||
        url.toLowerCase().contains('pdf');
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1A1A1A),
        title: const CommonTextWidget(
          text: 'Delete Post',
          color: AppConstants.white,
          fontWeight: FontWeight.w600,
        ),
        content: CommonTextWidget(
          text:
              'Are you sure you want to delete "${post!.title}"? This action cannot be undone.',
          color: AppConstants.white.withOpacity(0.8),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CommonTextWidget(
              text: 'Cancel',
              color: AppConstants.white.withOpacity(0.7),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // Go back to previous screen
              // You can also emit a delete event here if needed
            },
            child: const CommonTextWidget(
              text: 'Delete',
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
