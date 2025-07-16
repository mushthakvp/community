import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../../providers/vhub_provider.dart';
import 'faq_error_widget.dart';
import 'faq_list.dart';
import 'faq_search_bar.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VHubProvider>().loadFaqs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                    const CommonTextWidget(
                      text: 'Frequently Asked Questions',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.appPrimaryColor,
                    ),
                    const SizedBox(height: 8),
                    CommonTextWidget(
                      text: 'Find answers to common questions',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConstants.white.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    FaqSearchBar(
                      controller: _searchController,
                      onSearch: (query) => provider.loadFaqs(search: query),
                    ),
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
    if (provider.isLoading && provider.faqs.isEmpty) {
      return const Center(child: LoadingWidget());
    }

    if (provider.hasError && provider.faqs.isEmpty) {
      return FaqErrorWidget(
        message: provider.errorMessage ?? 'Something went wrong',
        onRetry: () => provider.loadFaqs(forceRefresh: true),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadFaqs(forceRefresh: true),
      child: const FaqList(),
    );
  }
}
