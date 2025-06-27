import 'package:flutter/material.dart';

class PromosShimmer extends StatefulWidget {
  const PromosShimmer({super.key});

  @override
  State<PromosShimmer> createState() => _PromosShimmerState();
}

class _PromosShimmerState extends State<PromosShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          _buildShimmerContainer(width: 120, height: 24),
          const SizedBox(height: 24),

          // YouTube videos section shimmer
          _buildShimmerContainer(width: 140, height: 20),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemBuilder: (context, index) => _buildVideoShimmer(),
            ),
          ),
          const SizedBox(height: 32),

          // Social media section shimmer
          _buildShimmerContainer(width: 200, height: 20),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) => _buildSocialMediaShimmer()),
          ),
          const SizedBox(height: 32),

          // Promos section shimmer
          _buildShimmerContainer(width: 100, height: 20),
          const SizedBox(height: 16),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) => _buildPromoShimmer(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.grey[800]!, Colors.grey[700]!, Colors.grey[800]!],
              stops: [0.0, _animation.value, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoShimmer() {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[800],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildShimmerContainer(width: 220, height: 150),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildShimmerContainer(width: 180, height: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaShimmer() {
    return Column(
      children: [
        _buildShimmerContainer(width: 40, height: 40),
        const SizedBox(height: 8),
        _buildShimmerContainer(width: 60, height: 12),
        const SizedBox(height: 4),
        _buildShimmerContainer(width: 80, height: 10),
      ],
    );
  }

  Widget _buildPromoShimmer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[800],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildShimmerContainer(width: double.infinity, height: 120),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: _buildShimmerContainer(width: double.infinity, height: 16),
          ),
        ],
      ),
    );
  }
}
