import 'package:flutter/material.dart';

import '../../../../../../core/router/routers/chat_router.dart';
import '../../../domain/entities/community_entity.dart';
import 'community_tile.dart';

class CommunityGrid extends StatelessWidget {
  final List<CommunityEntity> communities;

  const CommunityGrid({super.key, required this.communities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        return CommunityTile(
          community: community,
          onTap: () {
            ChatRouter.navigateToCommunityChat(
              context,
              communityId: community.id,
              communityName: community.name,
              communityImage: community.profileImage,
            );
          },
        );
      },
    );
  }
}
