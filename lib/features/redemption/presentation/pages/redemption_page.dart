import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/common/app_bar.dart';
import '../../../../core/widgets/common/text_widget.dart';
import '../../../promos/presentation/animation/animated_promos_background.dart';
import '../providers/redemption_provider.dart';
import '../widgets/redemption_card_widget.dart';
import '../widgets/transaction_filter_widget.dart';
import '../widgets/transaction_list_widget.dart';

class RedemptionPage extends StatefulWidget {
  const RedemptionPage({super.key});

  @override
  State<RedemptionPage> createState() => _RedemptionPageState();
}

class _RedemptionPageState extends State<RedemptionPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RedemptionProvider>();
      provider.initialize();

      // Start animations
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      final provider = context.read<RedemptionProvider>();
      if (provider.hasMoreData && !provider.isLoadingMore) {
        provider.getTransactions(loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.black,
      body: AnimatedPromosBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: RefreshIndicator(
                onRefresh: () => context.read<RedemptionProvider>().refresh(),
                color: AppConstants.appPrimaryColor,
                backgroundColor: const Color(0xFF2A2A2A),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Animated App Bar
                    SliverToBoxAdapter(
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, -50 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: const CommonAppBar(
                                title: 'Redemption',
                                showBackButton: false,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Content with staggered animations
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Animated Redemption Card
                            _buildAnimatedSection(
                              delay: 200,
                              child: const RedemptionCardWidget(),
                            ),

                            const SizedBox(height: 24),

                            // Animated Transaction Filters
                            _buildAnimatedSection(
                              delay: 400,
                              child: const TransactionFilterWidget(),
                            ),

                            const SizedBox(height: 16),

                            // Animated Transactions Header
                            _buildAnimatedSection(
                              delay: 600,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppConstants.appPrimaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.history,
                                      color: AppConstants.appPrimaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const CommonTextWidget(
                                    text: 'Transaction History',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppConstants.white,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    // Animated Transaction List
                    Consumer<RedemptionProvider>(
                      builder: (context, provider, child) {
                        if (provider.error != null) {
                          return SliverToBoxAdapter(
                            child: _buildAnimatedErrorWidget(provider.error!),
                          );
                        }

                        if (provider.isLoadingTransactions &&
                            provider.allTransactions.isEmpty) {
                          return SliverToBoxAdapter(
                            child: _buildAnimatedLoadingWidget(),
                          );
                        }

                        return const TransactionListWidget();
                      },
                    ),

                    // Bottom padding for better scrolling
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  Widget _buildAnimatedErrorWidget(String error) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                CommonTextWidget(
                  text: 'Oops! Something went wrong',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 8),
                CommonTextWidget(
                  text: error,
                  color: Colors.red.withOpacity(0.8),
                  fontSize: 14,
                  align: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.appPrimaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<RedemptionProvider>().clearError();
                      context.read<RedemptionProvider>().refresh();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.appPrimaryColor,
                      foregroundColor: AppConstants.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const CommonTextWidget(
                      text: 'Try Again',
                      color: AppConstants.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLoadingWidget() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                // Animated loading circles
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.appPrimaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppConstants.appPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const CommonTextWidget(
                  text: 'Loading transactions...',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.white,
                ),
                const SizedBox(height: 8),
                CommonTextWidget(
                  text: 'Please wait while we fetch your data',
                  fontSize: 14,
                  color: AppConstants.white.withOpacity(0.6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
