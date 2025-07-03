import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/common/text_widget.dart';

class VizzleMarketplaceCategories extends StatefulWidget {
  const VizzleMarketplaceCategories({super.key});

  @override
  State<VizzleMarketplaceCategories> createState() =>
      _VizzleMarketplaceCategoriesState();
}

class _VizzleMarketplaceCategoriesState
    extends State<VizzleMarketplaceCategories>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    final categories = _getMarketplaceCategories();

    _animationControllers = List.generate(
      categories.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers
        .map(
          (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticOut),
          ),
        )
        .toList();

    _fadeAnimations = _animationControllers
        .map(
          (controller) => Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn)),
        )
        .toList();

    // Start animations with staggered delay
    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getMarketplaceCategories();

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final category = categories[index];
        return AnimatedBuilder(
          animation: _animationControllers[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[index].value,
              child: Opacity(
                opacity: _fadeAnimations[index].value,
                child: _CategoryCard(
                  title: category['title'],
                  icon: category['icon'],
                  color: category['color'],
                  index: index,
                  onTap: () {
                    context.push(
                      '${RouteConstants.vizzleCategory}/${category['categoryName']}',
                    );
                  },
                ),
              ),
            );
          },
        );
      }, childCount: categories.length),
    );
  }

  List<Map<String, dynamic>> _getMarketplaceCategories() {
    return [
      {
        'title': 'Classifieds',
        'icon': Icons.category,
        'categoryName': 'Classifieds',
        'color': const Color(0xFF4285F4),
      },
      {
        'title': 'Motors',
        'icon': Icons.directions_car,
        'categoryName': 'Motors',
        'color': const Color(0xFF34A853),
      },
      {
        'title': 'Furniture & Garden',
        'icon': Icons.chair,
        'categoryName': 'Furniture & Garden',
        'color': const Color(0xFFEA4335),
      },
      {
        'title': 'Freshly Grown',
        'icon': Icons.eco,
        'categoryName': 'Freshly Grown',
        'color': const Color(0xFFFBBC04),
      },
      {
        'title': 'Property For Sale',
        'icon': Icons.home,
        'categoryName': 'Property For Sale',
        'color': const Color(0xFFFF6B35),
      },
      {
        'title': 'Property For Rent',
        'icon': Icons.house,
        'categoryName': 'Property For Rent',
        'color': const Color(0xFF9C27B0),
      },
    ];
  }
}

class _CategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.index,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _colorAnimation =
        ColorTween(
          begin: const Color(0xFF1A1A1A),
          end: widget.color.withOpacity(0.1),
        ).animate(
          CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _hoverAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _hoverController.forward(),
            onTapUp: (_) {
              _hoverController.reverse();
              widget.onTap();
            },
            onTapCancel: () => _hoverController.reverse(),
            child: Container(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.color.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(
                      milliseconds: 800 + (widget.index * 100),
                    ),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.color.withOpacity(0.8),
                                widget.color,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(
                        milliseconds: 600 + (widget.index * 100),
                      ),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: CommonTextWidget(
                              text: widget.title,
                              color: AppConstants.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              maxLines: 2,
                              align: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
