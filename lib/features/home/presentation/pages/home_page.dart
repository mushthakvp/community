import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../providers/home_provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/essentials_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_shimmer.dart';
import '../widgets/loyalty_card.dart';
import '../widgets/marquee_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/videos/moon.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const HomeShimmer();
            }

            if (provider.hasError) {
              return _buildErrorState(provider);
            }

            return RefreshIndicator(
              onRefresh: () => provider.loadUserDetails(forceRefresh: true),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const HomeAppBar(),
                        const SizedBox(height: 16),
                        const LoyaltyCard(),
                        const MarqueeText(),
                        const SizedBox(height: 16),
                        const BannerCarousel(),
                        const SizedBox(height: 30),
                        _buildEssentialsSection(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(HomeProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppConstants.white, size: 64),
          const SizedBox(height: 16),
          Text(
            provider.errorMessage ?? 'Something went wrong',
            style: const TextStyle(color: AppConstants.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => provider.loadUserDetails(forceRefresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appPrimaryColor,
              foregroundColor: AppConstants.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEssentialsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25.0),
          child: Text(
            'Essentials',
            style: TextStyle(
              color: AppConstants.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 16),
        EssentialsGrid(),
      ],
    );
  }
}
