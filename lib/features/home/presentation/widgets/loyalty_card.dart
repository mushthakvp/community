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

class _EnhancedLoyaltyCardState extends State<EnhancedLoyaltyCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.userDetails == null) {
          return const SizedBox.shrink();
        }
        return SlideTransition(
          position: _slideAnimation,
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProfileSection(provider),
                _buildCenterSection(provider),
                _buildLogoSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileSection(HomeProvider provider) {
    return Container(
      height: 70,
      width: 70,
      padding: const EdgeInsets.only(top: 8.0),
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
          height: 70,
          width: 70,
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
            radius: MediaQuery.of(context).size.width * 0.075,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // LOYALTY CARD Title
        Text(
          "LOYALTY CARD",
          style: TextStyle(
            fontSize: 26,
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

        SizedBox(height: MediaQuery.of(context).size.height * 0.01),

        // Border decoration
        SvgPicture.string(AppConstants.homeCardBorder, height: 4, width: 60),

        SizedBox(height: MediaQuery.of(context).size.height * 0.01),

        // User details section
        if (provider.userDetails != null) ...[
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRedemptionCardField(
                    label: "Name",
                    value:
                        provider.userDetails?.name.capitalizeFirstLetter() ??
                        "",
                  ),
                  _buildRedemptionCardField(
                    label: "Loyalty Points",
                    value: "${provider.userDetails?.loyaltyPoints ?? ""}",
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRedemptionCardField(
                    label: "Wallet Amount",
                    value:
                        "${provider.userDetails?.currencyCode ?? ""} ${provider.userDetails?.walletAmount ?? ""}",
                  ),
                  const SizedBox(width: 10),
                  _buildRedemptionCardField(
                    label: "Community Id",
                    value: provider.userDetails?.communityId ?? "",
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.018),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLogoSection() {
    return Expanded(
      child: SizedBox(
        height: 80,
        width: 80,
        child: Image.asset(AppConstants.viveraLogo),
      ),
    );
  }

  Widget _buildRedemptionCardField({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: AppConstants.white,
              fontSize: 12,
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
