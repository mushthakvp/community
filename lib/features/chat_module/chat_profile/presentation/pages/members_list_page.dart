import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../providers/chat_profile_provider.dart';
import '../widgets/member_list_item.dart';
import '../widgets/member_search_field.dart';

class MembersListPage extends StatelessWidget {
  final String communityId;
  final String communityName;

  const MembersListPage({
    super.key,
    required this.communityId,
    required this.communityName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
          ),
        ),
        child: Consumer<ChatProfileProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // Custom App Bar
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Members (${provider.totalMemberCount})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MemberSearchField(
                    controller: provider.memberSearchController,
                    onChanged: provider.searchMembers,
                    hintText: 'Search members...',
                  ),
                ),

                const SizedBox(height: 16),

                // Members List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.refreshMembers,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: provider.members.length,
                      itemBuilder: (context, index) {
                        final member = provider.members[index];
                        return MemberListItem(
                          member: member,
                          isCreator: provider.isCreator,
                          onRemove: provider.isCreator && !member.isCurrentUser
                              ? () => _showRemoveMemberDialog(
                                  context,
                                  provider,
                                  member,
                                  index,
                                )
                              : null,
                          onSendFriendRequest:
                              !member.isFriend &&
                                  !member.isRequested &&
                                  !member.isCurrentUser
                              ? () => provider.sendFriendRequestToUser(
                                  member.id,
                                  index,
                                )
                              : null,
                          onChat: member.isFriend && !member.isCurrentUser
                              ? () => _navigateToChat(context, member)
                              : null,
                          isLoading: provider.isRequestLoading,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showRemoveMemberDialog(
    BuildContext context,
    ChatProfileProvider provider,
    member,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardColor,
        title: const Text(
          'Remove Member',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove ${member.name} from the community?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.removeMemberFromCommunity(member.id, index);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToChat(BuildContext context, member) {
    context.pushNamed(
      'singleChat',
      pathParameters: {'chatId': member.id},
      queryParameters: {
        'chatName': member.name,
        'chatImage': member.profileImage ?? '',
      },
    );
  }
}
