import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../providers/vhub_provider.dart';
import 'empty_ideas_widget.dart';
import 'idea_card.dart';

class IdeasList extends StatefulWidget {
  const IdeasList({super.key});

  @override
  State<IdeasList> createState() => _IdeasListState();
}

class _IdeasListState extends State<IdeasList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<VHubProvider>().loadMoreIdeas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VHubProvider>(
      builder: (context, provider, child) {
        if (provider.ideas.isEmpty) {
          return EmptyIdeasWidget(
            message: provider.searchController.text.isNotEmpty
                ? 'No ideas found for "${provider.searchController.text}"'
                : 'No ideas found',
            onRefresh: () => provider.loadIdeas(forceRefresh: true),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: provider.ideas.length + (provider.hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= provider.ideas.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: LoadingWidget()),
              );
            }

            final idea = provider.ideas[index];
            return IdeaCard(
              idea: idea,
              onTap: () => _navigateToIdeaDetails(idea.id),
              onDelete: idea.isRequested
                  ? () => _showDeleteDialog(idea.id)
                  : null,
            );
          },
        );
      },
    );
  }

  void _navigateToIdeaDetails(String ideaId) {
    // Navigate to idea details page
    // This would typically use your navigation system
  }

  void _showDeleteDialog(String ideaId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        title: const CommonTextWidget(
          text: 'Delete Idea',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: const CommonTextWidget(
          text:
              'Are you sure you want to delete this idea? This action cannot be undone.',
          fontSize: 14,
          color: AppConstants.white,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const CommonTextWidget(
              text: 'Cancel',
              fontSize: 14,
              color: AppConstants.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<VHubProvider>().deleteIdea(ideaId);
            },
            child: const CommonTextWidget(
              text: 'Delete',
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
