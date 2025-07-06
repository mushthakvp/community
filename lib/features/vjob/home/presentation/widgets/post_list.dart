import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vjob_home_provider.dart';
import 'empty_posts_widget.dart';
import 'post_card.dart';

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VJobHomeProvider>(
      builder: (context, provider, child) {
        if (provider.posts.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyPostsWidget(
              message: 'No posts available at the moment',
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final post = provider.posts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PostCard(
                  post: post,
                  onLike: () => provider.likePost(post.id, index),
                ),
              );
            }, childCount: provider.posts.length),
          ),
        );
      },
    );
  }
}
