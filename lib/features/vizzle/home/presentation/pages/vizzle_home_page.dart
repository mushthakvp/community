// lib/features/vizzle/home/presentation/pages/vizzle_home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/common/app_bar.dart';
import '../../../../../core/widgets/common/text_widget.dart';
import '../../../../../core/widgets/loading/loading_widget.dart';
import '../providers/vizzle_home_provider.dart';
import '../widgets/vizzle_category_grid.dart';
import '../widgets/vizzle_home_search_bar.dart';
import '../widgets/vizzle_product_grid.dart';

class VizzleHomePage extends StatefulWidget {
  const VizzleHomePage({super.key});

  @override
  State<VizzleHomePage> createState() => _VizzleHomePageState();
}

class _VizzleHomePageState extends State<VizzleHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VizzleHomeProvider>().loadVizzleHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      appBar: CommonAppBar(
        title: 'Vizzle',
        actions: [
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.person_outline, color: AppConstants.white),
          ),
        ],
      ),
      body: Consumer<VizzleHomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasData) {
            return const Center(child: LoadingWidget());
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshData(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const VizzleHomeSearchBar(),
                      const SizedBox(height: 20),
                      const VizzleCategoryGrid(),
                      const SizedBox(height: 20),
                    ]),
                  ),
                ),

                // Motors Section
                if (provider.vizzleHome?.motors.isNotEmpty == true) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildSectionHeader('Popular Cars'),
                    ),
                  ),
                  VizzleProductGrid(
                    products: provider.vizzleHome!.motors,
                    section: 'motors',
                    currencyCode: provider.vizzleHome!.currencyCode,
                  ),
                ],

                // Classifieds Section
                if (provider.vizzleHome?.classifieds.isNotEmpty == true) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildSectionHeader('Popular Classifieds'),
                    ),
                  ),
                  VizzleProductGrid(
                    products: provider.vizzleHome!.classifieds,
                    section: 'classifieds',
                    currencyCode: provider.vizzleHome!.currencyCode,
                  ),
                ],

                // Furniture & Garden Section
                if (provider.vizzleHome?.furnitureGarden.isNotEmpty ==
                    true) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildSectionHeader('Furniture & Garden'),
                    ),
                  ),
                  VizzleProductGrid(
                    products: provider.vizzleHome!.furnitureGarden,
                    section: 'furnitureGarden',
                    currencyCode: provider.vizzleHome!.currencyCode,
                  ),
                ],

                // Property For Sale Section
                if (provider.vizzleHome?.propertyForSale.isNotEmpty ==
                    true) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildSectionHeader('Property For Sale'),
                    ),
                  ),
                  VizzleProductGrid(
                    products: provider.vizzleHome!.propertyForSale,
                    section: 'propertyForSale',
                    currencyCode: provider.vizzleHome!.currencyCode,
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: CommonTextWidget(
        text: title,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppConstants.white,
      ),
    );
  }
}
