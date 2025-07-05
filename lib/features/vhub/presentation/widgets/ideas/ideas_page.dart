import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../providers/vhub_provider.dart';
import 'ideas_error_widget.dart';
import 'ideas_filter_tabs.dart';
import 'ideas_list.dart';
import 'ideas_search_bar.dart';

class IdeasPage extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const IdeasPage({super.key, this.onNavigateToTab});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VHubProvider>().loadIdeas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Consumer<VHubProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.black,
                      AppConstants.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CommonTextWidget(
                          text: 'My Ideas',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.appPrimaryColor,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => widget.onNavigateToTab?.call(3),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.appPrimaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: AppConstants.black,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                CommonTextWidget(
                                  text: 'New Idea',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const IdeasSearchBar(),
                    const SizedBox(height: 16),
                    const IdeasFilterTabs(),
                  ],
                ),
              ),

              // Content
              Expanded(child: _buildContent(provider)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(VHubProvider provider) {
    if (provider.isLoading && provider.ideas.isEmpty) {
      return const Center(child: LoadingWidget());
    }

    if (provider.hasError && provider.ideas.isEmpty) {
      return IdeasErrorWidget(
        message: provider.errorMessage ?? 'Something went wrong',
        onRetry: () => provider.loadIdeas(forceRefresh: true),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadIdeas(forceRefresh: true),
      child: IdeasList(onNavigateToTab: widget.onNavigateToTab),
    );
  }
}
