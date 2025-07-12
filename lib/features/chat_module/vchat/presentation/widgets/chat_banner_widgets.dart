import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExploreBanner extends StatelessWidget {
  const ExploreBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
          colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Fixed with Flexible
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.explore, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Discover Communities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description Text
          const Text(
            'Explore vibrant communities tailored to your interests. From tech to books, find your perfect match.',
            style: TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // Action Button Row
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search, color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Start Exploring',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.public, size: 24, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PopularBanner extends StatelessWidget {
  const PopularBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.6, 1.0],
          colors: [Color(0xFFffecd2), Color(0xFFfcb69f), Color(0xFFFF6B6B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Fixed with Flexible
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: Color(0xFF8B0000),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Trending Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('🔥', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description Text
          const Text(
            'Join the hottest conversations! Connect with trending topics and popular communities.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8B0000),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // Action Buttons Row
          Row(
            children: [
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to birthday wishes
                  },
                  icon: const Icon(Icons.celebration, size: 16),
                  label: const Text(
                    'Birthday Wishes',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.trending_up,
                  size: 24,
                  color: Color(0xFF8B0000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyGroupBanner extends StatelessWidget {
  const MyGroupBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.4, 0.8, 1.0],
          colors: [
            Color(0xFF134e5e),
            Color(0xFF71b280),
            Color(0xFF56ab2f),
            Color(0xFFa8edea),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF56ab2f).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Fixed with Flexible
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.groups_2,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Your Communities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      size: 10,
                      color: Colors.white,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description Text
          const Text(
            'Manage your communities and build lasting relationships with members.',
            style: TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // Action Buttons Row
          Row(
            children: [
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/create-community');
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const Text(
                    'Create Community',
                    style: TextStyle(fontSize: 11),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF134e5e),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.groups, size: 24, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Additional Banner for Community Features
class FeaturesBanner extends StatelessWidget {
  const FeaturesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
          colors: [Color(0xFF6a11cb), Color(0xFF2575fc), Color(0xFF0ba360)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2575fc).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row - Fixed with Flexible
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Amazing Features',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description Text
          const Text(
            'Unlock powerful community tools: messaging, voice channels, file sharing, polls, and events.',
            style: TextStyle(fontSize: 13, color: Colors.white, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          // Feature Chips - Using Wrap for overflow handling
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeatureChip(Icons.chat, 'Chat'),
              _buildFeatureChip(Icons.event, 'Events'),
              _buildFeatureChip(Icons.poll, 'Polls'),
              _buildFeatureChip(Icons.voice_chat, 'Voice'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Responsive Banner Container for consistent usage
class ResponsiveBannerContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;

  const ResponsiveBannerContainer({
    super.key,
    required this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }
}

// Usage Example:
class BannerUsageExample extends StatelessWidget {
  const BannerUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          ResponsiveBannerContainer(child: ExploreBanner()),
          ResponsiveBannerContainer(child: PopularBanner()),
          ResponsiveBannerContainer(child: MyGroupBanner()),
          ResponsiveBannerContainer(child: FeaturesBanner()),
        ],
      ),
    );
  }
}
