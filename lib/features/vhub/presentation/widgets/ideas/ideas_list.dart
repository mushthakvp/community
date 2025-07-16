import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../providers/create_idea_provider.dart';
import '../../providers/vhub_provider.dart';
import 'empty_ideas_widget.dart';
import 'idea_card.dart';
import 'idea_details_page.dart';

class IdeasList extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const IdeasList({super.key, this.onNavigateToTab});

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
              onEdit: idea.isRejected ? () => _editIdea(idea) : null,
              onDelete: (idea.isRequested || idea.isRejected)
                  ? () => _showDeleteDialog(idea.id)
                  : null,
            );
          },
        );
      },
    );
  }

  void _navigateToIdeaDetails(String ideaId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IdeaDetailsPage(
          ideaId: ideaId,
          onEdit: () => _editIdeaFromDetails(ideaId),
        ),
      ),
    );
  }

  void _editIdea(idea) {
    // Set up the create idea provider with existing data for editing
    final createProvider = context.read<CreateIdeaProvider>();
    createProvider.setReapplyData(idea);

    // Navigate to create idea tab (index 3)
    widget.onNavigateToTab?.call(3);
  }

  void _editIdeaFromDetails(String ideaId) {
    // Find the idea from the provider
    final provider = context.read<VHubProvider>();
    final idea = provider.ideas.firstWhere((i) => i.id == ideaId);

    // Set up the create idea provider with existing data for editing
    final createProvider = context.read<CreateIdeaProvider>();
    createProvider.setReapplyData(idea);

    // Navigate to create idea tab (index 3)
    widget.onNavigateToTab?.call(3);
  }

  void _showDeleteDialog(String ideaId) {
    final provider = context.read<VHubProvider>();
    final idea = provider.ideas.firstWhere((i) => i.id == ideaId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const CommonTextWidget(
          text: 'Delete Idea',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppConstants.white,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget(
              text: 'Are you sure you want to delete "${idea.projectName}"?',
              fontSize: 14,
              color: AppConstants.white,
            ),
            const SizedBox(height: 8),
            const CommonTextWidget(
              text: 'This action cannot be undone.',
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ],
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
              _deleteIdea(ideaId);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
            ),
            child: const CommonTextWidget(
              text: 'Delete',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteIdea(String ideaId) async {
    final provider = context.read<VHubProvider>();

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Deleting idea...'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );

    final success = await provider.deleteIdea(ideaId);

    // Hide loading indicator
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Idea deleted successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(provider.errorMessage ?? 'Failed to delete idea'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _deleteIdea(ideaId),
          ),
        ),
      );
    }
  }
}
