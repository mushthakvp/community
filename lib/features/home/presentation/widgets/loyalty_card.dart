import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/home_provider.dart';

class EnhancedLoyaltyCard extends StatefulWidget {
  const EnhancedLoyaltyCard({super.key});

  @override
  State<EnhancedLoyaltyCard> createState() => _EnhancedLoyaltyCardState();
}

class _EnhancedLoyaltyCardState extends State<EnhancedLoyaltyCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.userDetails == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          padding: const EdgeInsets.only(left: 8, right: 8),
          height: MediaQuery.of(context).size.height * 0.24,
          width: MediaQuery.of(context).size.width * 1.0,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/animation/bg.gif'),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 1),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileSection(provider),
              Expanded(child: _buildCenterSection(provider)),
              _buildLogoSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(HomeProvider provider) {
    return Container(
      height: 70,
      width: 70,
      margin: const EdgeInsets.only(top: 8.0, right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: AppConstants.appPrimaryColor.withOpacity(0.8),
            blurRadius: 16,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Center(
        child: CachedNetworkImage(
          height: 60,
          width: 60,
          imageUrl: provider.userDetails?.profileImage ?? '',
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(22.0),
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 35,
            child: Image.asset(
              'assets/animation/vivera-animation.gif',
              color: AppConstants.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterSection(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LOYALTY CARD Title
          Text(
            "LOYALTY CARD",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppConstants.white,
              shadows: [
                Shadow(
                  offset: const Offset(0.0, 1.48),
                  blurRadius: 1.48,
                  color: AppConstants.black.withOpacity(.25),
                ),
                Shadow(
                  offset: const Offset(0.0, 3.48),
                  blurRadius: 4,
                  color: AppConstants.black.withOpacity(.80),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Border decoration
          SvgPicture.string(AppConstants.homeCardBorder, height: 4, width: 60),

          const SizedBox(height: 12),

          // User details section
          if (provider.userDetails != null) ...[
            // First row - Name and Loyalty Points
            Row(
              children: [
                Expanded(
                  child: _buildRedemptionCardField(
                    label: "Name",
                    value:
                        provider.userDetails?.name.capitalizeFirstLetter() ??
                        "",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRedemptionCardField(
                    label: "Loyalty Points",
                    value: "${provider.userDetails?.loyaltyPoints ?? ""}",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Second row - Wallet Amount and Community Id
            Row(
              children: [
                Expanded(
                  child: _buildRedemptionCardField(
                    label: "Wallet Amount",
                    value:
                        "${provider.userDetails?.currencyCode ?? ""} ${provider.userDetails?.walletAmount ?? ""}",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRedemptionCardField(
                    label: "Community Id",
                    value: provider.userDetails?.communityId ?? "",
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return SizedBox(
      height: 80,
      width: 80,
      child: Image.asset(AppConstants.viveraLogo, fit: BoxFit.contain),
    );
  }

  Widget _buildRedemptionCardField({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.white.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppConstants.white.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppConstants.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
