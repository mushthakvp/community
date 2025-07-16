import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:livera/core/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/loading_widget.dart';
import '../providers/chat_profile_provider.dart';
import '../widgets/friend_selection_item.dart';
import '../widgets/member_search_field.dart';

class AddMemberPage extends StatefulWidget {
  final String communityId;
  final String communityName;

  const AddMemberPage({
    super.key,
    required this.communityId,
    required this.communityName,
  });

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProfileProvider>().loadFriends();
    });
  }

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
                        const Text(
                          'Add Members',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (provider.hasSelectedMembers)
                          Text(
                            '${provider.selectedMemberIds.length} selected',
                            style: TextStyle(
                              color: AppConstants.primary,
                              fontSize: 14,
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
                    controller: provider.friendSearchController,
                    onChanged: provider.searchFriends,
                    hintText: 'Search friends...',
                    prefixIcon: Icons.search,
                  ),
                ),

                const SizedBox(height: 16),

                // Friends List
                Expanded(child: _buildFriendsList(provider)),

                // Add Button
                if (provider.hasSelectedMembers)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PrimaryButton(
                        text:
                            'Add ${provider.selectedMemberIds.length} Member(s)',
                        onPressed: provider.isRequestLoading
                            ? null
                            : () => _addSelectedMembers(provider),
                        isLoading: provider.isRequestLoading,
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

  Widget _buildFriendsList(ChatProfileProvider provider) {
    if (provider.isLoading) {
      return const Center(child: LoadingWidget(message: 'Loading friends...'));
    }

    if (!provider.hasFriends) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No friends found',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Add friends first to invite them to the community',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.friends.length,
      itemBuilder: (context, index) {
        final friend = provider.friends[index];
        return FriendSelectionItem(
          friend: friend,
          isSelected: provider.isMemberSelected(friend.id),
          onToggle: () => provider.toggleMemberSelection(friend.id),
        );
      },
    );
  }

  Future<void> _addSelectedMembers(ChatProfileProvider provider) async {
    await provider.addSelectedMembers();
    if (mounted && provider.requestStatus == RequestStatus.success) {
      context.pop(); // Go back to previous screen
    }
  }
}
